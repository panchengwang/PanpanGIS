-- 服务节点元数据
create table pan_server(
    id integer not null,
    db_host varchar default '127.0.0.1',
    db_port integer default 5432,
    db_name varchar(32) default 'pan_gis_db',
    db_user varchar(32) default 'pcwang',
    db_password varchar(32) default '',
    web_url varchar(1024) default '' unique not null,       -- 
    max_user_count integer default 100 not null,            -- 可容纳最大用户数
    user_count integer default 0 not null                   -- 当前已有用户数
);

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
