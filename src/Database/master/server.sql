-- 服务api函数

-- 请求 <--> 内部函数映射表
create table pan_server_func(
    id varchar default sc_uuid() not null,
    request_type varchar not null,
    func_name varchar not null
);




-- pan_server
--  参数:   
--      params  此参数根据请求类型的不同包含不同的key-value，下面为示例：
--          {
--              "type": "请求类型，必须包含",         
--              "username": "用户名，一般情况下应该包含"
--          }
--  返回:
--      {
--          "success": true/false,
--          "message": "一些提示信息",
--          "data":{}  返回数据，根据请求类型有所差异
--      }
create or replace function pan_server(params jsonb) returns jsonb as 
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

    sqlstr := 'select func_name from pan_server_func where request_type = ' || quote_literal(params->>'type') ;
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


insert into pan_server_func(request_type, func_name) 
values
    ('USER_GET_IDENTIFY_CODE','pan_user_get_identify_code');

--  请求参数:
--  {
--      "type":"USER_GET_IDENTIFY_CODE",
--      "username": "sqlcartotest@126.com"
--  }
--  返回:
--  {
--      "success": true,
--      "message": "验证码已经发送到指定的信箱"
--  }
create or replace function pan_user_get_identify_code(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    code varchar;
begin
    code := sc_generate_code(8);
    if not pan_user_exist(params->>'username') then 
        -- 如果用户名不存在，则新建一个
        insert into pan_user(username,identify_code) values( params->>'username',code);
    else 
        -- 如果已经存在，则更新它的identify_code
        update pan_user set identify_code=code where username = (params->>'username');
    end if ;
    -- 发送验证码到指定的电子邮件
    if sc_send_email(params->>'username','验证码',code) then 
        response := jsonb_build_object(
            'success', true,
            'message', '验证码已经发送到指定的信箱'
        );
    else
        response := jsonb_build_object(
            'success', true,
            'message', '验证码发送错误，请检查您的信箱地址'
        );
    end if;
    
    return response;

end;
$$ language 'plpgsql';


select pan_server(
    jsonb_build_object(
        'type','USER_GET_IDENTIFY_CODE',
        'username','sqlcartotest@126.com'
    )
);