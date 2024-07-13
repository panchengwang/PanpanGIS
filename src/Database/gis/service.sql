

--------------------------------------------------------------------------------
--  获取用户空间数据管理 目录树
--------------------------------------------------------------------------------

insert into pan_service_function(request_type, func_name) 
values
    ('CATALOG_GET_DATASET_TREE','pan_catalog_get_dataset_tree');


--  函数:   pan_catalog_get_dataset_tree 
--  功能:   辅助函数, 内部使用
--          从指定的catalog表中获取节点id及其子节点树信息
--  参数: 
--      catalog_table_name      catalog表名，每个用户都有单独的catalog表
--      id                      节点id
--  返回:
--      {
--          "id": "0",
--          "name": "文件夹/数据表/数据集 名称",
--          "dataset_type": "folder/point/...",
--          "parent_id": "父节点id",
--          "children":[{
--              子节点信息
--          }]    
--      }

create or replace function pan_catalog_get_dataset_tree(catalog_table_name varchar, id varchar) returns jsonb as 
$$
declare
    response jsonb;
    children jsonb;
    sqlstr text;
begin
    sqlstr := '
        select
            jsonb_agg( 
                pan_catalog_get_dataset_tree(' || quote_literal(catalog_table_name) || ',id) 
            )
        from 
            ' || quote_ident(catalog_table_name) || '
        where 
            parent_id = ' || quote_literal( id ) || '
    ';
    execute sqlstr into children;
    if children is null then 
        children := jsonb_build_array();
    end if;

    sqlstr := '
        select to_jsonb(A) from (
            select 
                B.id,C.type_name as dataset_type, B.parent_id, B.name 
            from
                ' || quote_ident(catalog_table_name) || ' B,
                pan_dataset_type C
            where
                B.id = ' || quote_literal(id) || '
                and 
                B.dataset_type = C.id
            order by 
                B.name desc
        ) A
    ';  
    execute sqlstr into response;
    response := response || jsonb_build_object(
        'children', children
    );
    return response;
end;
$$ language 'plpgsql';


--  函数:   pan_catalog_get_dataset_tree 
--  功能:   辅助函数, 由token获取对应的catalog表
--  参数: 
--      token       用户登录获取的token
--  返回:
--      catalog表名
create or replace function pan_catalog_get_table_name_by_token(token varchar) returns varchar as 
$$
    select 'pan_catalog_' || pan_user_get_id_by_token(token);
$$ language 'sql';



--  函数: pan_catalog_get_dataset_tree
--  请求参数: 
--      param
--          {
--              "type":"CATALOG_GET_DATASET_TREE",
--              "data": {
--                  "token": "",
--                  "parent_id": '0'                    
--              }
--          }
--  返回:
--  {
--      "success": true,
--      "message": "ok"
--      "data": {
--          catalog:{
--    
--          }    
--      }
--  }
create or replace function pan_catalog_get_dataset_tree(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    
    user_id varchar;
    parent_id varchar;
begin
    user_id := pan_user_get_id_by_token(params->'data'->>'token');
    if params->'data'->'parent_id' is null then 
        parent_id := '0';
    else 
        parent_id := (params->'data'->>'parent_id');
    end if;

    response := pan_catalog_get_dataset_tree('pan_catalog_' || user_id, parent_id);
    
    return jsonb_build_object(
        'success', true,
        'message', 'ok',
        'data', jsonb_build_object(
            'catalog', response
        )
    );
end;
$$ language 'plpgsql';



--------------------------------------------------------------------------------
--  新建文件夹
--------------------------------------------------------------------------------

insert into pan_service_function(request_type, func_name) 
values
    ('CATALOG_CREATE_FOLDER','pan_catalog_create_folder');
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





