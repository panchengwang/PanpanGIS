set client_encoding to utf8;

-- 当前编辑sql脚本
-- 当sql脚本能正确运行后，请拷贝到相应的其他sql文件里
-- 如：
--      用户相关的sql拷贝到 user.sql
--      服务相关的sql拷贝到 server.sql





--------------------------------------------------------------------------------
--  删除catalog节点
--------------------------------------------------------------------------------

insert into pan_service_function(request_type, func_name) 
values
    ('CATALOG_REMOVE','pan_catalog_remove');
--  函数: pan_catalog_remove
--  参数: 
--      param
--          {
--              "type":"CATALOG_REMOVE",
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
begin
end;
$$ language 'plpgsql';