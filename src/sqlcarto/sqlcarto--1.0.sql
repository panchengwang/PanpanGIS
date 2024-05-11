\echo Use "create EXTENSION sqlcarto;" to add sqlcarto extension. \quit


create or replace function sqlcarto_info() returns json as 
$$
  select '{
      "extension" : "SQLCarto",
      "version" : "1.0",
      "author" : "pcwang",
      "qq" : "593723812"
    }'::json;
$$
language 'sql';


create or replace function sqlcarto_version() returns json as 
$$
  select sqlcarto_info();
$$
language 'sql';


create or replace function sc_uuid() returns text as
$$
  select replace(gen_random_uuid()::text,'-','');
$$
language 'sql';-- 邮件发送模块

-- 函数：sc_send_mail
-- 参数:    sender 发送者信箱
--          reciever 接收者信箱
--          title 邮件标题
--          content 邮件内容
--          smtp smtp服务器
--          password 发送者信箱密码

create or replace function sc_send_mail(
    sender varchar, 
    reciever varchar, 
    title varchar, 
    content text,
    smtp varchar,
    password varchar
) 
returns boolean 
AS '$libdir/sqlcarto','sc_send_mail'
LANGUAGE C IMMUTABLE STRICT;
