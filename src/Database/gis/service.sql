
--  请求参数:
--  {
--      "type":"CATALOG_GET_DATASET_TREE",
--      "data": {
--          "username": ""
--      }
--  }
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

insert into pan_service_function(request_type, func_name) 
values
    ('CATALOG_GET_DATASET_TREE','pan_catalog_get_dataset_tree');



