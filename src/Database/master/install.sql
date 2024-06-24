create extension "uuid-ossp";
create extension "sqlcarto";
create extension "dblink";

set client_encoding to utf8;


-- 系统配置参数

create table pan_configuration(
    keyname varchar unique not null,
    keyvalue varchar 
) ;
insert into pan_configuration(keyname,keyvalue) 
values 
    ('VERIFY_CODE_VALID_TIME', '10 minutes'),         -- 验证码有效时长
    ('TOKEN_VALID_TIME', '10 minutes')                  -- token有效时长
    ;

-- 邮件发送参数配置
update sc_configuration set key_value = 'sqlcartotest@126.com' where key_name = 'EMAIL_USER';
update sc_configuration set key_value = 'smtps://smtp.126.com:465' where key_name = 'EMAIL_SMTP';
update sc_configuration set key_value = 'SCUGOXHGWAEZUEQH' where key_name = 'EMAIL_PASSWORD';


-- 用户数据库
-- drop table if exists pan_user;
create table pan_user(
    id varchar(32) default sc_uuid() primary key,
    username varchar(64) unique not null,
    nickname varchar(64) NOT NULL default '',
    password varchar(128) not null default '',
    salt  varchar(32) not null default sc_generate_code(32),
    register_time timestamp default now(),
    verify_code varchar(8) default '',
    verify_code_expire_time timestamp default now() ,
    token varchar(128) not null  default '',
    token_expire_time timestamp default now() ,
    status integer  default 1,    -- 1 注册状态，2 有效用户，2 失效用户，
    server_id integer not null default 0
);


-- 服务节点元数据
create table pan_server(
    id integer not null,
    db_host varchar default '127.0.0.1',
    db_port integer default 5432,
    db_name varchar(32) default 'pan_gis_db',
    db_user varchar(32) default 'pcwang',
    db_password varchar(32) default '',
    web_url varchar(1024) default '' unique not null,       -- 
    max_user_count integer default 100 not null,            -- 可容纳最大用户数
    user_count integer default 0 not null                   -- 当前已有用户数
);


-- 请求 <--> 内部函数映射表
create table pan_service_function(
    id varchar default sc_uuid() not null,
    request_type varchar not null,
    func_name varchar not null
);


-- 系统需要的一些杂项函数


create or replace function pan_requirements() returns text as 
$$
    select 'panpangis 数据库端需要
            数据库扩展：ossp-uuid, sqlcarto';
$$ language 'sql';


create or replace function pan_generate_token() returns varchar as 
$$
    select sc_generate_token(128);
$$ language 'sql';


--  函数:   pan_dblink_execute_sql
--  功能:   连接另外一个数据库，执行sql
--  参数:   
--          connstr 数据库连接字符串 
--          sqlstr sql语句，字符串，注意转义
--  返回：
--          总是返回ok
--          如果在远程数据库中执行的sql出现错误，通过exception机制报错，无需返回
create or replace function pan_dblink_execute_sql(connstr text, sqlstr text) returns text as 
$$
declare
    connname text;
    ret text;
begin
    connname := 'connection_' || sc_uuid();
    perform dblink_connect(connname, connstr);
    perform  dblink_exec(connname, sqlstr);
    perform dblink_disconnect(connname);
    return ret;
end;
$$ language 'plpgsql';


-- 获取配置
create or replace function pan_get_configuration(
    keyname varchar
) returns varchar as 
$$
    select keyvalue from pan_configuration where keyname = $1;
$$ language 'sql';


-- 向系统中添加一个新的服务节点
create or replace function pan_add_server(
    dbhost varchar,
    dbport integer,
    dbname varchar,
    dbuser varchar,
    dbpassword varchar,
    weburl varchar
) returns integer as 
$$
declare
    maxid integer;
begin
    select max(id) into maxid from pan_server;
    if maxid is null then
        maxid := 1;
    else 
        maxid := maxid + 1 ;
    end if;

    insert into pan_server(id,db_host,db_port,db_name,db_user,db_password, web_url) 
    values
        (maxid, dbhost,dbport,dbname,dbuser,dbpassword,weburl);
    return maxid;
end;
$$ language 'plpgsql';


-- 根据用户名获取所在的数据库连接字符串
create or replace function pan_get_gis_server_connection(username varchar) returns varchar as 
$$
    select 
        'host=' || db_host || ' port=' || db_port || ' dbname=' || db_name || ' user=' || db_user || ' password=' || db_password 
    from 
        pan_server
    where 
        id = (select server_id from pan_user where username = $1 limit 1 );
$$ language 'sql';
-- 用户数据库初始化




-- 系统管理员账号
-- 特别提示： 在生产环境中请务必修改系统管理员账号信息
--          包括管理员信箱地址和密码
-- insert into pan_user(username,password)
-- values 
--     ('admin@12345.com', md5('admin'));

-- -- 用户pcwang
-- insert into pan_user(username,password)
-- values
--     ('pcwang251@163.com', md5('pcwang251'));


-- 用户是否存在
create or replace function pan_user_exist(username varchar) returns boolean as 
$$
    select count(1)=1 from pan_user where username = $1;
$$ language 'sql';

-- 获取用户id
create or replace function pan_user_get_id(username varchar) returns varchar as 
$$
    select id from pan_user where username = $1;
$$ language 'sql';-- 服务api函数





-- pan_service
--  参数:   
--      params  此参数根据请求类型的不同包含不同的key-value，下面为示例：
--          {
--              "type": "请求类型，必须包含",  
--              "data": {
--                  "username": "用户名，一般情况下应该包含"
--              }
--          }
--  返回:
--      {
--          "success": true/false,
--          "message": "一些提示信息",
--          "data":{}  返回数据，根据请求类型有所差异
--      }
create or replace function pan_service(params jsonb) returns jsonb as 
$$
declare
    response jsonb;
    server_func_name varchar;
    sqlstr text;
begin
    -- 是否包含有type
    if params->'type' is null then 
        return jsonb_build_object(
            'success', false,
            'message', '必须设置请求类型type'
        );
    end if;

    sqlstr := 'select func_name from pan_service_function where request_type = ' || quote_literal(params->>'type') ;
    execute sqlstr into server_func_name;
    if server_func_name is null then 
        return jsonb_build_object(
            'success',  false,
            'message', '不支持的请求类型: ' || (params->>'type')
        );
    end if;
    sqlstr := 'select ' || server_func_name || '(' || quote_literal(params) || '::jsonb)';
    execute sqlstr into response;
    -- response := jsonb_build_object(
    --     'success', true,
    --     'message', 'ok'
    -- );
    return response;
end;
$$ language 'plpgsql';


-- master 特有服务
--  1   获取验证码
--  2   用户注册
--  3   用户登录

insert into pan_service_function(request_type, func_name) 
values
    ('USER_GET_VERIFY_CODE','pan_user_get_verify_code');

--  请求参数:
--  {
--      "type":"USER_GET_VERIFY_CODE",
--      "data": {
--          "username": ""
--      }
--  }
--  返回:
--  {
--      "success": true,
--      "message": "验证码已经发送到指定的信箱"
--  }
create or replace function pan_user_get_verify_code(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    code varchar;
begin
    code := sc_generate_code(8);
    if not pan_user_exist(params->'data'->>'username') then 
        -- 如果用户名不存在，则新建一个
        insert into pan_user(username) values( params->'data'->>'username');
    end if; 
    -- 如果已经存在，则更新它的verify_code
    update 
        pan_user 
    set 
        verify_code=code,
        verify_code_expire_time = now() + pan_get_configuration('verify_CODE_VALID_TIME')::interval
    where 
        username = (params->'data'->>'username');
    
    -- 发送验证码到指定的电子邮件
    if sc_send_email(params->'data'->>'username','验证码',code) then 
        response := jsonb_build_object(
            'success', true,
            'message', '验证码已经发送到指定的信箱'
        );
    else
        response := jsonb_build_object(
            'success', true,
            'message', '验证码发送错误，请检查您的信箱地址'
        );
    end if;
    
    return response;

end;
$$ language 'plpgsql';



-- ---------------------------------------------------------
--  pan_verify_code_is_valid: 验证码是否有效
--  参数：
--      username
--      verify_code
-- ---------------------------------------------------------
create or replace function pan_verify_code_is_valid(
    username varchar, verify_code varchar
) returns boolean as 
$$
    select 
        count(1) = 1  
    from 
        pan_user 
    where 
        username = $1 
        and 
        verify_code = $2;
$$ language 'sql';

-- ---------------------------------------------------------
--  pan_verify_code_is_expired: 验证码是否过期
--  参数：
--      username
--      verify_code
-- ---------------------------------------------------------
create or replace function pan_verify_code_is_expired(
    username varchar, verify_code varchar
) returns boolean as 
$$
    select 
        now() >= verify_code_expire_time 
    from 
        pan_user 
    where 
        username = $1 
        and 
        verify_code = $2;
$$ language 'sql';









-- ---------------------------------------------------------
--  函数:   pan_check_verify_code
--  功能:   判断验证码是否有效或过期
--  参数:
--      username  用户名
--      verify_code   验证码
--  返回:
--      {
--          "success": true/fase,
--          "message": "验证码有效/过期/无效"
--      }
-- ---------------------------------------------------------
create or replace function pan_check_verify_code(
    username varchar, verify_code varchar
) returns jsonb as 
$$
declare
begin
    -- 检查验证码是否正确
    if pan_verify_code_is_expired(username, verify_code) then 
        return jsonb_build_object(
            'success', false,
            'message', '验证码过期'
        );
    end if;
    if not pan_verify_code_is_valid(username, verify_code) then 
        return jsonb_build_object(
            'success', false,
            'message', '验证码无效'
        );
    end if;   
    return jsonb_build_object(
        'success', true,
        'message', '验证码有效'
    );
end;
$$ language 'plpgsql';









-- ---------------------------------------------------------
--  函数:   pan_user_register
--  功能:   创建（注册）用户：
--  参数:
--      params  用户创建注册参数，jsonb对象
--          {
--              "type":"USER_REGISTER",
--              "data": {
--                  "username": "",
--                  "nickname": "",
--                  "password": "",
--                  "verify_code": ""
--              }
--          }
--  返回:
--      {
--          "success": true,
--          "message": "用户注册成功"
--      }
-- ---------------------------------------------------------

insert into pan_service_function(request_type, func_name) 
values
    ('USER_REGISTER','pan_user_register');

create or replace function pan_user_register(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    server_available boolean;
    gis_server_conn_str varchar;
    gis_server_id integer;
    myrec record;
    user_salt varchar;
    user_id varchar;
    ret text;
    user_status integer;
begin
    -- 检查用户是否已经注册成功
    user_status := 1;
    SELECT status into user_status from pan_user where username = (params->'data'->>'username');
    if  pan_user_exist(params->'data'->>'username') and user_status > 1 then 
        return jsonb_build_object(
            'success', false,
            'message', '用户已经存在'
        );
    end if;

    -- 检查验证码是否正确
    response := pan_check_verify_code(params->'data'->>'username',params->'data'->>'verify_code');
    if not (response->'success')::boolean then 
        return response;
    end if;
    
    --  获取资源最富余的服务数据库节点
    select 
        id ,
        'host=' || db_host || ' port=' || db_port || ' dbname=' || db_name || ' user=' || db_user || ' password=' || db_password 
        into gis_server_id, gis_server_conn_str
    from 
        pan_server
    where 
        user_count <= max_user_count
    order by user_count limit 1;

    if gis_server_id is null then 
        return jsonb_build_object(
            'success',false,
            'message','服务器资源有限，请联系管理员'
        );
    end if;
    

    --  向节点数据库中插入用户信息
    select id,salt into user_id,user_salt from pan_user where username = params->'data'->>'username';
    update 
        pan_user
    set
        nickname = params->'data'->>'nickname',
        password = md5(salt || (params->'data'->>'password')),
        status = 2,
        register_time = now(),
        server_id = gis_server_id
    where 
        id = user_id ;

    sqlstr := 'insert into pan_user(id,username,nickname,salt,password,register_time,status, server_id) values (
            ' || quote_literal(user_id) || ',
            ' || quote_literal(params->'data'->>'username') || ',
            ' || quote_literal(params->'data'->> 'nickname') || ',
            ' || quote_literal(user_salt) || ',
            ' || quote_literal(md5( user_salt || (params->'data'->>'password'))) || ',
            ' || quote_literal(now()) || '::timestamp,
            2, 
            ' || gis_server_id || '
        );
        create table pan_catalog(
            id varchar(32) default sc_uuid() primary key,               
            dataset_type integer default 0,                             
            parent_id varchar(32) default  ' || quote_literal('0') || ',                          
            name varchar(256),                                          
            author_id varchar(32) not null,
            create_time timestamp default now() not null,                
            last_modify_time timestamp default now() not null 
        );
    ';

    perform pan_dblink_execute_sql(gis_server_conn_str,sqlstr);

    response := jsonb_build_object(
        'success',true,
        'message','用户注册（创建）成功'
    );
    return response;
end;
$$ language 'plpgsql';


-- ---------------------------------------------------------
--  用户登录
--  请求参数:
--  {
--      "type":"USER_LOGIN",
--      "data": {
--          "username": "",
--          "password": ""
--      }
--  }
--  返回:
--  {
--      "success": true,
--      "message": "登录成功",
--      "data": {
--          "token": "",                                用户登陆后取得的token
--          "url": ""                                   该用户服务的url
--      }
--  }
-- ---------------------------------------------------------
insert into pan_service_function(request_type, func_name) 
values
    ('USER_LOGIN','pan_user_login');

create or replace function pan_user_login(params jsonb) returns jsonb as 
$$
declare
    mytoken varchar;
    login_success boolean;
    url varchar;
    sqlstr text;
begin
    -- if not pan_user_exist(params->'data'->>'username') then 
    --     return jsonb_build_object(
    --         'success', false,
    --         'message', '登录失败'
    --     );
    -- end if;

    mytoken := pan_generate_token();
    login_success := false;
    select 
        count(1) = 1  into login_success
    from 
        pan_user 
    where
        username = (params->'data'->>'username') 
        and 
        password = md5(salt || (params->'data'->>'password')) ;
    if not login_success then 
        return jsonb_build_object(
            'success', false,
            'message', '登录失败'
        );
    end if;

    -- update pan_user 
    -- set 
    --     token = mytoken,
    --     token_expire_time = now() + pan_get_configuration('TOKEN_VALID_TIME')::interval
    -- where 
    --     username = (params->'data'->>'username');
    
    select web_url into url from pan_server where 
        id = (select server_id from pan_user where username = (params->'data'->>'username') limit 1);

    sqlstr := '
        update pan_user 
        set 
            token = ' || quote_literal(mytoken) || ',
            token_expire_time = ' || quote_literal(now()) ||  '::timestamp + pan_get_configuration(' || quote_literal('TOKEN_VALID_TIME') || ')::interval
        where 
            username = ' || quote_literal(params->'data'->>'username') || '
    ';
    execute sqlstr;
    perform pan_dblink_execute_sql(pan_get_gis_server_connection(params->'data'->>'username'),sqlstr);

    return jsonb_build_object(
        'success',true,
        'message','登录成功',
        'data', jsonb_build_object(
            'token',mytoken,
            'url', url
        )
    );
end;
$$ language 'plpgsql';





-- ---------------------------------------------------------
--  用户密码重置
--  请求参数:
--  {
--      "type":"USER_RESET_PASSWORD",
--      "data": {
--          "username": "",
--          "password": "",
--          "verify_code": ""
--      }
--  }
--  返回:
--  {
--      "success": true,
--      "message": "密码重置成功"
--  }
-- ---------------------------------------------------------
insert into pan_service_function(request_type, func_name) 
values
    ('USER_RESET_PASSWORD','pan_user_reset_password');

create or replace function pan_user_reset_password(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
begin
    response := pan_check_verify_code(params->'data'->>'username', params->'data'->>'verify_code');
    if not (response->'success')::boolean then 
        return respone;
    end if;

    sqlstr := '
        update pan_user 
        set password = md5(salt || ' || quote_literal(params->'data'->>'password') || ')
        where username = ' || quote_literal(params->'data'->>'username') || '
    ';
    execute sqlstr;
    perform pan_dblink_execute_sql(pan_get_gis_server_connection(params->'data'->>'username'), sqlstr);
    return jsonb_build_object(
        'success', true,
        'message', '密码重置成功'
    );

end;
$$ language 'plpgsql';