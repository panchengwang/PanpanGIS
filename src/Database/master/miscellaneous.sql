-- 系统需要的一些杂项函数
create extension "uuid-ossp";
create extension "sqlcarto";

set client_encoding to utf8;

create or replace function pan_requirements() returns text as 
$$
    select 'panpangis 数据库端需要
            数据库扩展：ossp-uuid, sqlcarto';
$$ language 'sql';

