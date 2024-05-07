create extension "uuid-ossp";

create or replace function pan_uuid() returns varchar as 
$$
    select replace(uuid_generate_v4()::text,'-','');
$$ language 'sql';
