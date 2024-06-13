-- 系统需要的一些杂项函数


create or replace function pan_requirements() returns text as 
$$
    select 'panpangis 数据库端需要
            数据库扩展：ossp-uuid, sqlcarto';
$$ language 'sql';


create or replace function pan_generate_token() returns varchar as 
$$
    select sc_generate_token(128);
$$ language 'sql';


--  函数:   pan_dblink_execute_sql
--  功能:   连接另外一个数据库，执行sql
--  参数:   
--          connstr 数据库连接字符串 
--          sqlstr sql语句，字符串，注意转义
--  返回：
--          总是返回ok
--          如果在远程数据库中执行的sql出现错误，通过exception机制报错，无需返回
create or replace function pan_dblink_execute_sql(connstr text, sqlstr text) returns text as 
$$
declare
    connname text;
    ret text;
begin
    connname := 'connection_' || sc_uuid();
    perform dblink_connect(connname, connstr);
    perform  dblink_exec(connname, sqlstr);
    perform dblink_disconnect(connname);
    return ret;
end;
$$ language 'plpgsql';
