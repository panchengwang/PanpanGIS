set client_encoding to utf8;

-- 当前编辑sql脚本
-- 当sql脚本能正确运行后，请拷贝到相应的其他sql文件里
-- 如：
--      用户相关的sql拷贝到 user.sql
--      服务相关的sql拷贝到 server.sql





--  函数: pan_catalog_create_folder
--  参数: 
--      param
--          {
--              "type":"CATALOG_CREATE_FOLDER",
--              "data": {
--                  "token": "",
--                  "folder": 'folder',
--                  "parent_id": '0'                    
--              }
--          }
--  返回:
--  {
--      "success": true,
--      "message": "ok"
--      "data": { 
--          
--      }
--  }
create or replace function pan_catalog_create_folder(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    folder_id varchar;
    parent_id varchar;
    catalog_table_name varchar;
    folder_exist boolean;
begin
    catalog_table_name := pan_catalog_get_table_name_by_token(params->'data'->>'token');
    -- 判断目录是否存在
    sqlstr := '
        select 
            count(1) = 1 
        from 
            ' || catalog_table_name || ' 
        where 
            parent_id = ' || quote_literal(params->'data'->>'parent_id') || '
            and 
            name = ' || quote_literal(params->'data'->>'folder') || '
        ';
    execute sqlstr into folder_exist;
    if folder_exist then 
        return jsonb_build_object(
            'success', false,
            'message', '文件夹已经存在'
        );
    end if;

    -- 插入目录信息
    folder_id := sc_uuid();
    sqlstr := '
        insert into ' || quote_ident(catalog_table_name) || '
            (id,name,dataset_type,parent_id)
        values (
            ' || quote_literal(folder_id) || ',
            ' || quote_literal(params->'data'->>'folder') || ',
            0,
            ' || quote_literal(params->'data'->>'parent_id') || '
        )
    ';
    execute sqlstr;

    -- 构造返回结果
    return jsonb_build_object(
        'success', true,
        'message', '目录创建成功',
        'data',jsonb_build_object(
            'id', folder_id,
            'name', (params->'data'->>'folder'),
            'dataset_type','folder',
            'parent_id', (params->'data'->>'parent_id')
        )
    );
end;
$$ language 'plpgsql';

