drop extension sqlcarto;
create extension sqlcarto;

SET client_encoding to 'utf8';
select sqlcarto_info();
select sqlcarto_version();
select sc_uuid();


select '测试邮件发送模块';
select sc_send_mail(
    'sqlcartotest@126.com',
    'sqlcartotest@126.com',
    '测试一下',
    '这是一个从postgresql sqlcarto扩展发送过来的测试邮件',
    'smtp.126.com',
    'Sqlcarto251'
);
