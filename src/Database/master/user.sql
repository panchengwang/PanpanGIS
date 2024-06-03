-- 用户数据库初始化

-- 邮件发送参数配置
update sc_configuration set key_value = 'sqlcartotest@126.com' where key_name = 'EMAIL_USER';
update sc_configuration set key_value = 'smtps://smtp.126.com:465' where key_name = 'EMAIL_SMTP';
update sc_configuration set key_value = 'SCUGOXHGWAEZUEQH' where key_name = 'EMAIL_PASSWORD';

-- 用户数据库
drop table if exists pan_user;
create table pan_user(
    id varchar(32) default sc_uuid() primary key,
    username varchar(64) unique not null,
    nickname varchar(64) NOT NULL default '',
    password varchar(128) not null default '',
    identify_code varchar(8) default '',
    identify_code_expire timestamp default now() + interval '30 minutes',
    token varchar(128) not null  default '',
    token_expire timestamp default now() + interval '5 minutes',
    status integer  default 3    -- 1 有效用户，2 失效用户，3 注册状态
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


-- 用户是否存在
create or replace function pan_user_exist(username varchar) returns boolean as 
$$
    select count(1)=1 from pan_user where username = $1;
$$ language 'sql';