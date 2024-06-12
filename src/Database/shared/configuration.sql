-- 系统配置参数

create table pan_configuration(
    keyname varchar unique not null,
    keyvalue varchar 
) ;

insert into pan_configuration(keyname,keyvalue) 
values 
    ('IDENTIFY_CODE_VALID_TIME', '10 minutes'),         -- 验证码有效时长
    ('TOKEN_VALID_TIME', '10 minutes')                  -- token有效时长
    ;

-- 获取配置
create or replace function pan_get_configuration(
    keyname varchar
) returns varchar as 
$$
    select keyvalue from pan_configuration where keyname = $1;
$$ language 'sql';
