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
--                  "folder_name": 'folder',
--                  "parent_id": '0'                    
--              }
--          }
--  返回:
--  {
--      "success": true,
--      "message": "ok"
--      "data": { 
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

