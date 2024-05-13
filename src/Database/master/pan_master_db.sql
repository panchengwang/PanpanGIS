-- 系统需要的一些杂项函数
create extension "uuid-ossp";
create extension "sqlcarto";

set client_encoding to utf8;

create or replace function pan_requirement() returns text as 
$$
    select 'panpangis 数据库端需要
            数据库扩展：ossp-uuid, sqlcarto';
$$ language 'sql';

-- 用户数据库初始化



-- 用户数据库
drop table if exists pan_user;
create table pan_user(
    id varchar(32) default sc_uuid() primary key,
    username varchar(64) unique not null,
    nickname varchar(64) NOT NULL default '',
    password varchar(128) not null,
    identify_code varchar(8) default '',
    identify_code_expire timestamp default now() + interval '30 minutes',
    token varchar(128) not null  default '',
    token_expire timestamp default now() + interval '5 minutes'
);

-- 系统管理员账号
-- 特别提示： 在生产环境中请务必修改系统管理员账号信息
--          包括管理员信箱地址和密码
insert into pan_user(username,password)
values 
    ('admin@12345.com', md5('admin'));

-- 用户pcwang
insert into pan_user(username,password)
values
    ('pcwang251@163.com', md5('pcwang251'));

