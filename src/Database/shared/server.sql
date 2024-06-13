

-- 向系统中添加一个新的服务节点
create or replace function pan_add_server(
    dbhost varchar,
    dbport integer,
    dbname varchar,
    dbuser varchar,
    dbpassword varchar,
    weburl varchar
) returns integer as 
$$
declare
    maxid integer;
begin
    select max(id) into maxid from pan_server;
    if maxid is null then
        maxid := 1;
    else 
        maxid := maxid + 1 ;
    end if;

    insert into pan_server(id,db_host,db_port,db_name,db_user,db_password, web_url) 
    values
        (maxid, dbhost,dbport,dbname,dbuser,dbpassword,weburl);
    return maxid;
end;
$$ language 'plpgsql';


-- 根据用户名获取所在的数据库连接字符串
create or replace function pan_get_gis_server_connection(username varchar) returns varchar as 
$$
    select 
        'host=' || db_host || ' port=' || db_port || ' dbname=' || db_name || ' user=' || db_user || ' password=' || db_password 
    from 
        pan_server
    where 
        id = (select server_id from pan_user where username = $1 limit 1 );
$$ language 'sql';
