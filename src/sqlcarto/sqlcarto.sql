\echo Use "create EXTENSION sqlcarto;" to add sqlcarto extension. \quit

-- sqlcarto的基本信息
create or replace function sqlcarto_info() returns json as 
$$
  select '{
      "extension" : "SQLCarto",
      "version" : "1.0",
      "authors" : ["pcwang","麓山老将"],
      "qq" : "593723812"
    }'::json;
$$
language 'sql';

-- 
create or replace function sqlcarto_version() returns json as 
$$
  select sqlcarto_info();
$$
language 'sql';

-- 去掉uuid中的连字符
create or replace function sc_uuid() returns text as
$$
  select replace(gen_random_uuid()::text,'-','');
$$
language 'sql';


-- sqlcarto配置信息表
create table sc_configuration(
    key_name varchar primary key,
    key_value varchar default '',
    description varchar default '' not null
);
insert into sc_configuration(key_name,key_value, description)
values
    ('EMAIL_USER','','电子信箱用户'),
    ('EMAIL_PASSWORD','','电子信箱密码'),
    ('EMAIL_SMTP','','smtp服务器');

-- 获取配置信息
create or replace function sc_get_configuration(varchar) returns varchar as
$$
    select key_value from sc_configuration where key_name = $1;
$$ language 'sql';


-- 生成一个随机字符串
create or replace function sc_generate_random_string(seedstr varchar, len integer)
returns varchar as
$$
    select array_to_string(
        array(
            select 
                substring(
                    $1 
                    FROM 
                    (ceil(random()*length($1)))::int 
                    FOR 1
                ) 
            FROM 
             generate_series(1, $2)
        ), ''
    );
$$
language 'sql';

-- 用来生成验证码
create or replace function sc_generate_code(len integer) returns varchar as 
$$
    select sc_generate_random_string(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
        $1
    );
$$ language sql;

-- 用来生成token
create or replace function sc_generate_token(len integer) returns varchar as
$$
    select sc_generate_random_string(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',$1-32) || 
        sc_uuid();
$$ language 'sql';

