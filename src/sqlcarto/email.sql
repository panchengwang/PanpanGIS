-- 邮件发送模块

-- 函数：sc_send_mail
-- 参数:    sender 发送者信箱
--          reciever 接收者信箱
--          title 邮件标题
--          content 邮件内容
--          smtp smtp服务器
--          password 发送者信箱密码, 
--              请注意此密码有时并不是用户登录邮箱时使用的密码
--              如126、163信箱需要经过特别设置开通smtp服务，
--              在开通服务时会告知一个发送邮件所使用的特殊密码，请记住该密码并在sc_send_mail函数中使用
create or replace function sc_send_mail(
    sender varchar, 
    reciever varchar, 
    subject varchar, 
    content text,
    smtp varchar,
    password varchar
) 
returns boolean 
AS '$libdir/sqlcarto','sc_send_mail'
LANGUAGE C IMMUTABLE STRICT;


-- 函数：sc_send_mail
-- 参数:    reciever 接收者信箱
--          title 邮件标题
--          content 邮件内容
create or replace function sc_send_mail(
    reciever varchar, 
    subject varchar, 
    content text
) 
returns boolean AS 
$$
    select sc_send_mail(
        sc_get_configuration('EMAIL_USER'),
        $1,
        $2,
        $3,
        sc_get_configuration('EMAIL_SMTP'),
        sc_get_configuration('EMAIL_PASSWORD')
    );
$$ language 'sql';