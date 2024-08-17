-- 数据管理

-- panpangis 支持的数据类型
create table pan_dataset_type(
    id integer not null ,
    type_name varchar(32)
);

insert into pan_dataset_type(id,type_name)
values
    (0,'folder'),                                               --  数据集分组
    (1,'geometry'),                                             --  几何数据，兼容所有的矢量数据    
    (2,'point'),                                                --  点
    (3,'linestring'),                                           --  线
    (4,'polygon'),                                              --  多边形
    (5,'multipoint'),
    (6,'multilinestring'),
    (7,'multipolygon')
;


-- 数据集元数据表
-- 每个用户会对应一个名为pan_catalog_<user_id>的元数据表
-- create table pan_catalog(
--     id varchar(32) default sc_uuid() primary key,               -- id
--     dataset_type integer default 0,                             -- 数据类型
--     parent_id varchar(32) default '0',                          -- 当parent_id为字符串0的时候，为数据集的根分组
--     name varchar(256),                                          -- 数据集名称
--     author_id varchar(32) not null,
--     create_time timestamp default now() not null,                --
--     last_modify_time timestamp default now() not null 
-- );



--  函数:   pan_catalog_get_table_name_by_token 
--  功能:   辅助函数, 由token获取对应的catalog表
--  参数: 
--      token       用户登录获取的token
--  返回:
--      catalog表名
create or replace function pan_catalog_get_table_name_by_token(token varchar) returns varchar as 
$$
    select 'pan_catalog_' || pan_user_get_id_by_token(token);
$$ language 'sql';