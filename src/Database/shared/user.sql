-- 用户数据库初始化




-- 系统管理员账号
-- 特别提示： 在生产环境中请务必修改系统管理员账号信息
--          包括管理员信箱地址和密码
-- insert into pan_user(username,password)
-- values 
--     ('admin@12345.com', md5('admin'));

-- -- 用户pcwang
-- insert into pan_user(username,password)
-- values
--     ('pcwang251@163.com', md5('pcwang251'));


-- 用户是否存在
create or replace function pan_user_exist(username varchar) returns boolean as 
$$
    select count(1)=1 from pan_user where username = $1;
$$ language 'sql';

-- 获取用户id
create or replace function pan_user_get_id(username varchar) returns varchar as 
$$
    select id from pan_user where username = $1;
$$ language 'sql';