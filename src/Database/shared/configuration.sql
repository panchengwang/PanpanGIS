

-- 获取配置
create or replace function pan_get_configuration(
    keyname varchar
) returns varchar as 
$$
    select keyvalue from pan_configuration where keyname = $1;
$$ language 'sql';
