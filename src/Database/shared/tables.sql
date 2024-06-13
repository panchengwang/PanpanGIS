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


