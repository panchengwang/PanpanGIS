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
    status integer      -- 1 有效用户，2 失效用户，3 注册状态
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
$$ language 'sql';-- 服务api函数

-- 请求 <--> 内部函数映射表
create table pan_server_func(
    id varchar default sc_uuid() not null,
    request_type varchar not null,
    func_name varchar not null
);




-- pan_server
--  参数:   
--      params  此参数根据请求类型的不同包含不同的key-value，下面为示例：
--          {
--              "type": "请求类型，必须包含",         
--              "username": "用户名，一般情况下应该包含"
--          }
--  返回:
--      {
--          "success": true/false,
--          "message": "一些提示信息",
--          "data":{}  返回数据，根据请求类型有所差异
--      }
create or replace function pan_server(params jsonb) returns jsonb as 
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

    sqlstr := 'select func_name from pan_server_func where request_type = ' || quote_literal(params->>'type') ;
    execute sqlstr into server_func_name;
    sqlstr := 'select ' || server_func_name || '(' || quote_literal(params) || '::jsonb)';
    execute sqlstr into response;
    -- response := jsonb_build_object(
    --     'success', true,
    --     'message', 'ok'
    -- );
    return response;
end;
$$ language 'plpgsql';


insert into pan_server_func(request_type, func_name) 
values
    ('USER_GET_IDENTIFY_CODE','pan_user_get_identify_code');

create or replace function pan_user_get_identify_code(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    code varchar;
begin
    code := sc_generate_code(8);
    if not pan_user_exist(params->>'username') then 
        -- 如果用户名不存在，则新建一个
        insert into pan_user(username,identify_code) values( params->>'username',code);
    else 
        -- 如果已经存在，则更新它的identify_code
        update pan_user set identify_code=code where username = (params->>'username');
    end if ;
    -- 发送验证码到指定的电子邮件
    if sc_send_email(params->>'username','验证码',code) then 
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


select pan_server(
    jsonb_build_object(
        'type','USER_GET_IDENTIFY_CODE',
        'username','sqlcartotest@126.com'
    )
);