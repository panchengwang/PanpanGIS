create table pan_server(
    id integer not null,
    db_host varchar default '127.0.0.1',
    db_port integer default 5432,
    db_name varchar(32) default 'pan_node_db',
    db_user varchar(32) default 'pcwang',
    db_password varchar(32) default '',
    web_url varchar(1024) default '' unique
);



