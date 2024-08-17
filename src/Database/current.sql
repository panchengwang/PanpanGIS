set client_encoding to utf8;

-- 当前编辑sql脚本
-- 当sql脚本能正确运行后，请拷贝到相应的其他sql文件里
-- 如：
--      用户相关的sql拷贝到 user.sql
--      服务相关的sql拷贝到 server.sql





--------------------------------------------------------------------------------
--  删除catalog节点
--------------------------------------------------------------------------------

-- insert into pan_service_function(request_type, func_name) 
-- values
--     ('CATALOG_REMOVE','pan_catalog_remove');
--  函数: pan_catalog_remove
--  参数: 
--      param
--          {
--              "type":"CATALOG_REMOVE",
--              "data": {
--                  "token": "",
--                  "id": 'id'          
--              }
--          }
--  返回:
--  {
--      "success": true,
--      "message": "ok"
--  }
create or replace function pan_catalog_remove(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    catalog_table_name varchar;
    dataset_type integer;
begin
    catalog_table_name := pan_catalog_get_table_name_by_token(params->'data'->>'token');
    sqlstr := '
        select 
            dataset_type 
        from 
            ' || quote_ident(catalog_table_name) || '
        where 
            id = ' || quote_literal(params->'data'->>'id') || '
    '; 
    execute sqlstr into dataset_type;
    if dataset_type = 0 then 
        perform pan_catalog_remove_folder(catalog_table_name, (params->'data'->>'id'));
    end if;

    return jsonb_build_object(
        'success', true,
        'message', 'ok'
    );
end;
$$ language 'plpgsql';


create or replace function pan_catalog_remove_folder(catalog_table_name varchar, id varchar) returns jsonb as 
$$
declare
    sqlstr text;
    myrec record;
    ret jsonb;
begin
    sqlstr := '
        select 
            id, dataset_type 
        from 
            ' || quote_ident(catalog_table_name) || '
        where 
            parent_id = ' || quote_literal(id) || '    
        ';
    for myrec in execute sqlstr loop
        if myrec.dataset_type = 0 then 
            ret := pan_catalog_remove_folder(catalog_table_name, myrec.id);
        end if;
    end loop;

    sqlstr := '
        delete from 
            ' || quote_ident(catalog_table_name) || ' 
        where 
            id = ' || quote_literal(id) || '
    ';
    execute sqlstr;

    return jsonb_build_object(
        'success',true,
        'message', 'ok'
    );

end;
$$ language 'plpgsql';