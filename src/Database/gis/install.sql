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
$$ language 'sql';

-- 由token，获取用户id
create or replace function pan_user_get_id_by_token(token varchar) returns varchar as 
$$
    select id from pan_user where token = $1;
$$ language 'sql';

-- token是否过期
create or replace function pan_token_is_expired(token varchar) returns boolean as 
$$
    select token_expire_time <= now() from pan_user where token = $1;
$$ language 'sql';


-- 服务api函数





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

    -- 检查token是否过期
    if (params->>'type') <> 'USER_LOGIN'  
        and  (params->>'type') <> 'USER_REGISTER'
        and  (params->>'type') <> 'USER_RESET_PASSWORD'
        and  (params->>'type') <> 'USER_GET_VERIFY_CODE' then 
        if pan_token_is_expired(params->'data'->>'token') then 
            return jsonb_build_object(
                'success', false,
                'message', 'token已过期，请重新登录'
            );
        else
            -- 否则更新最新的操作时间 
            sqlstr := '
                update pan_user 
                set
                    token_expire_time = now() + pan_get_configuration(' || quote_literal('TOKEN_VALID_TIME') || ')::interval
                where 
                    token = ' || quote_literal(params->'data'->>'token') || ' 
            ';
            execute sqlstr;
        end if; 
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


-- 数据管理

-- panpangis 支持的数据类型
create table pan_dataset_type(
    id integer not null ,
    type_name varchar(32)
);

insert into pan_dataset_type(id,type_name)
values
    (0,'folder'),                                               --  数据集分组
    (1,'geometry'),                                             --  几何数据，兼容所有的矢量数据    
    (2,'point'),                                                --  点
    (3,'linestring'),                                           --  线
    (4,'polygon'),                                              --  多边形
    (5,'multipoint'),
    (6,'multilinestring'),
    (7,'multipolygon')
;


-- 数据集元数据表
-- 每个用户会对应一个名为pan_catalog_<user_id>的元数据表
-- create table pan_catalog(
--     id varchar(32) default sc_uuid() primary key,               -- id
--     dataset_type integer default 0,                             -- 数据类型
--     parent_id varchar(32) default '0',                          -- 当parent_id为字符串0的时候，为数据集的根分组
--     name varchar(256),                                          -- 数据集名称
--     author_id varchar(32) not null,
--     create_time timestamp default now() not null,                --
--     last_modify_time timestamp default now() not null 
-- );



--------------------------------------------------------------------------------
--  获取用户空间数据管理 目录树
--------------------------------------------------------------------------------

insert into pan_service_function(request_type, func_name) 
values
    ('CATALOG_GET_DATASET_TREE','pan_catalog_get_dataset_tree');


--  函数:   pan_catalog_get_dataset_tree 
--  功能:   辅助函数, 内部使用
--          从指定的catalog表中获取节点id及其子节点树信息
--  参数: 
--      catalog_table_name      catalog表名，每个用户都有单独的catalog表
--      id                      节点id
--  返回:
--      {
--          "id": "0",
--          "name": "文件夹/数据表/数据集 名称",
--          "dataset_type": "folder/point/...",
--          "parent_id": "父节点id",
--          "children":[{
--              子节点信息
--          }]    
--      }

create or replace function pan_catalog_get_dataset_tree(catalog_table_name varchar, id varchar) returns jsonb as 
$$
declare
    response jsonb;
    children jsonb;
    sqlstr text;
begin
    sqlstr := '
        select
            jsonb_agg( 
                pan_catalog_get_dataset_tree(' || quote_literal(catalog_table_name) || ',id) 
            )
        from 
            ' || quote_ident(catalog_table_name) || '
        where 
            parent_id = ' || quote_literal( id ) || '
    ';
    execute sqlstr into children;
    if children is null then 
        children := jsonb_build_array();
    end if;

    sqlstr := '
        select to_jsonb(A) from (
            select 
                B.id,C.type_name as dataset_type, B.parent_id, B.name 
            from
                ' || quote_ident(catalog_table_name) || ' B,
                pan_dataset_type C
            where
                B.id = ' || quote_literal(id) || '
                and 
                B.dataset_type = C.id
            order by 
                B.name desc
        ) A
    ';  
    execute sqlstr into response;
    response := response || jsonb_build_object(
        'children', children
    );
    return response;
end;
$$ language 'plpgsql';


--  函数:   pan_catalog_get_dataset_tree 
--  功能:   辅助函数, 由token获取对应的catalog表
--  参数: 
--      token       用户登录获取的token
--  返回:
--      catalog表名
create or replace function pan_catalog_get_table_name_by_token(token varchar) returns varchar as 
$$
    select 'pan_catalog_' || pan_user_get_id_by_token(token);
$$ language 'sql';



--  函数: pan_catalog_get_dataset_tree
--  请求参数: 
--      param
--          {
--              "type":"CATALOG_GET_DATASET_TREE",
--              "data": {
--                  "token": "",
--                  "parent_id": '0'                    
--              }
--          }
--  返回:
--  {
--      "success": true,
--      "message": "ok"
--      "data": {
--          catalog:{
--    
--          }    
--      }
--  }
create or replace function pan_catalog_get_dataset_tree(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    
    user_id varchar;
    parent_id varchar;
begin
    user_id := pan_user_get_id_by_token(params->'data'->>'token');
    if params->'data'->'parent_id' is null then 
        parent_id := '0';
    else 
        parent_id := (params->'data'->>'parent_id');
    end if;

    response := pan_catalog_get_dataset_tree('pan_catalog_' || user_id, parent_id);
    
    return jsonb_build_object(
        'success', true,
        'message', 'ok',
        'data', jsonb_build_object(
            'catalog', response
        )
    );
end;
$$ language 'plpgsql';



--------------------------------------------------------------------------------
--  新建文件夹
--------------------------------------------------------------------------------

insert into pan_service_function(request_type, func_name) 
values
    ('CATALOG_CREATE_FOLDER','pan_catalog_create_folder');
--  函数: pan_catalog_create_folder
--  参数: 
--      param
--          {
--              "type":"CATALOG_CREATE_FOLDER",
--              "data": {
--                  "token": "",
--                  "folder": 'folder',
--                  "parent_id": '0'                    
--              }
--          }
--  返回:
--  {
--      "success": true,
--      "message": "ok"
--      "data": { 
--          
--      }
--  }
create or replace function pan_catalog_create_folder(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    folder_id varchar;
    parent_id varchar;
    catalog_table_name varchar;
    folder_exist boolean;
begin
    catalog_table_name := pan_catalog_get_table_name_by_token(params->'data'->>'token');
    -- 判断目录是否存在
    sqlstr := '
        select 
            count(1) = 1 
        from 
            ' || catalog_table_name || ' 
        where 
            parent_id = ' || quote_literal(params->'data'->>'parent_id') || '
            and 
            name = ' || quote_literal(params->'data'->>'folder') || '
        ';
    execute sqlstr into folder_exist;
    if folder_exist then 
        return jsonb_build_object(
            'success', false,
            'message', '文件夹已经存在'
        );
    end if;

    -- 插入目录信息
    folder_id := sc_uuid();
    sqlstr := '
        insert into ' || quote_ident(catalog_table_name) || '
            (id,name,dataset_type,parent_id)
        values (
            ' || quote_literal(folder_id) || ',
            ' || quote_literal(params->'data'->>'folder') || ',
            0,
            ' || quote_literal(params->'data'->>'parent_id') || '
        )
    ';
    execute sqlstr;

    -- 构造返回结果
    return jsonb_build_object(
        'success', true,
        'message', '目录创建成功',
        'data',jsonb_build_object(
            'id', folder_id,
            'name', (params->'data'->>'folder'),
            'dataset_type','folder',
            'parent_id', (params->'data'->>'parent_id')
        )
    );
end;
$$ language 'plpgsql';

