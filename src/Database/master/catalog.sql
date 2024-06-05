-- 数据管理

-- 
create table pan_dataset_type(
    id integer not null ,
    type_name varchar(32)
);

insert into pan_dataset_type(id,type_name)
values
    (0,'folder'),
    (1,'geometry'),
    (2,'point'),
    (3,'linestring'),
    (4,'polygon'),
    (5,'multipoint'),
    (6,'multilinestring'),
    (7,'multipolygon')
;


-- 数据集元数据表
create table pan_catalog(
    id varchar(32) default sc_uuid() primary key,               -- id
    type integer,
    parent_id varchar(32) default '',
    name varchar(256),
    dataset_id  varchar(32),                                    -- 数据集id
    create_time timestamp default now() not null               -- 
);

