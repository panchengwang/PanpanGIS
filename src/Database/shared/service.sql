-- 服务api函数





-- pan_service
--  参数:   
--      params  此参数根据请求类型的不同包含不同的key-value，下面为示例：
--          {
--              "type": "请求类型，必须包含",  
--              "data": {
--                  "username": "用户名，一般情况下应该包含"
--              }
--          }
--  返回:
--      {
--          "success": true/false,
--          "message": "一些提示信息",
--          "data":{}  返回数据，根据请求类型有所差异
--      }
create or replace function pan_service(params jsonb) returns jsonb as 
$$
declare
    response jsonb;
    server_func_name varchar;
    sqlstr text;
begin
    -- 是否包含有type
    if params->'type' is null then 
        return jsonb_build_object(
            'success', false,
            'message', '必须设置请求类型type'
        );
    end if;

    -- 检查token是否过期
    if (params->>'type') <> 'USER_LOGIN'  
        and  (params->>'type') <> 'USER_REGISTER'
        and  (params->>'type') <> 'USER_RESET_PASSWORD'
        and  (params->>'type') <> 'USER_GET_VERIFY_CODE' then 
        if pan_token_is_expired(params->'data'->>'token') then 
            return jsonb_build_object(
                'success', false,
                'message', 'token已过期，请重新登录'
            );
        else
            -- 否则更新最新的操作时间 
            sqlstr := '
                update pan_user 
                set
                    token_expire_time = now() + pan_get_configuration(' || quote_literal('TOKEN_VALID_TIME') || ')::interval
                where 
                    token = ' || quote_literal(params->'data'->>'token') || ' 
            ';
            execute sqlstr;
        end if; 
    end if;

    

    sqlstr := 'select func_name from pan_service_function where request_type = ' || quote_literal(params->>'type') ;
    execute sqlstr into server_func_name;
    if server_func_name is null then 
        return jsonb_build_object(
            'success',  false,
            'message', '不支持的请求类型: ' || (params->>'type')
        );
    end if;
    sqlstr := 'select ' || server_func_name || '(' || quote_literal(params) || '::jsonb)';
    execute sqlstr into response;
    -- response := jsonb_build_object(
    --     'success', true,
    --     'message', 'ok'
    -- );
    return response;
end;
$$ language 'plpgsql';


