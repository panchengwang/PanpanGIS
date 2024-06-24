set client_encoding to utf8;

-- 当前编辑sql脚本
-- 当sql脚本能正确运行后，请拷贝到相应的其他sql文件里
-- 如：
--      用户相关的sql拷贝到 user.sql
--      服务相关的sql拷贝到 server.sql


create or replace function pan_catalog_get_dataset_tree(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    code varchar;
begin
    response := '{
        "success": true,
        "message": "ok",
        "data": {
            "catalog":{
                id: ""
            }
        }
    }'::jsonb;
    
    return response;
end;
$$ language 'plpgsql';








