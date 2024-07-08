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
        create table pan_catalog_' || user_id || '(
            id varchar(32) default sc_uuid() primary key,               
            dataset_type integer default 0,                             
            parent_id varchar(32) default  ' || quote_literal('0') || ',                          
            name varchar(256),                                          
            create_time timestamp default now() not null,                
            last_modify_time timestamp default now() not null ,
            unique(parent_id,name)
        );

        insert into pan_catalog_' || user_id || '(id, dataset_type,parent_id,name) 
        values
            (
                ' || quote_literal('0') || ',
                0,
                ' || quote_literal('-1') || ',
                ' || quote_literal('root') || '
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
            token_expire_time = now() + pan_get_configuration(' || quote_literal('TOKEN_VALID_TIME') || ')::interval
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