-- 邮件发送模块

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
