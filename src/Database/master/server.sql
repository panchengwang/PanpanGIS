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
--      "data": {
--          "username": ""
--      }
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
    if not pan_user_exist(params->'data'->>'username') then 
        -- 如果用户名不存在，则新建一个
        insert into pan_user(username) values( params->'data'->>'username');
    end if; 
    -- 如果已经存在，则更新它的identify_code
    update 
        pan_user 
    set 
        identify_code=code,
        identify_code_expire_time = now() + pan_get_configuration('IDENTIFY_CODE_VALID_TIME')::interval
    where 
        username = (params->'data'->>'username');
    
    -- 发送验证码到指定的电子邮件
    if sc_send_email(params->'data'->>'username','验证码',code) then 
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



-- ---------------------------------------------------------
--  pan_identify_code_is_valid: 验证码是否有效
--  参数：
--      username
--      identify_code
-- ---------------------------------------------------------
create or replace function pan_identify_code_is_valid(
    username varchar, identify_code varchar
) returns boolean as 
$$
    select 
        count(1) = 1  
    from 
        pan_user 
    where 
        username = $1 
        and 
        identify_code = $2;
$$ language 'sql';

-- ---------------------------------------------------------
--  pan_identify_code_is_expired: 验证码是否过期
--  参数：
--      username
--      identify_code
-- ---------------------------------------------------------
create or replace function pan_identify_code_is_expired(
    username varchar, identify_code varchar
) returns boolean as 
$$
    select 
        now() >= identify_code_expire_time 
    from 
        pan_user 
    where 
        username = $1 
        and 
        identify_code = $2;
$$ language 'sql';


-- ---------------------------------------------------------
--  创建（注册）用户：
--  请求参数:
--  {
--      "type":"USER_REGISTER",
--      "data": {
--          "username": "",
--          "nickname": "",
--          "password": "",
--          "identify_code": ""
--      }
--  }
--  返回:
--  {
--      "success": true,
--      "message": "用户注册成功"
--  }
-- ---------------------------------------------------------

insert into pan_server_func(request_type, func_name) 
values
    ('USER_REGISTER','pan_user_register');

create or replace function pan_user_register(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    code_correct boolean;
begin
    -- 检查验证码是否正确
    if pan_identify_code_is_expired(params->'data'->>'username', params->'data'->>'identify_code') then 
        return jsonb_build_object(
            'success', false,
            'message', '验证码过期'
        );
    end if;
    if not pan_identify_code_is_valid(params->'data'->>'username', params->'data'->>'identify_code') then 
        return jsonb_build_object(
            'success', false,
            'message', '验证码无效'
        );
    end if;    
    
    update 
        pan_user
    set
        nickname = params->'data'->>'nickname',
        password = md5(salt || (params->'data'->>'password')),
        status = 1,
        register_time = now()
    where 
        username = params->'data'->>'username' ;
     
    response := jsonb_build_object(
        'success',true,
        'message','用户注册（创建）成功'
    );
    return response;

end;
$$ language 'plpgsql';




-- ---------------------------------------------------------
--  创建（注册）用户：
--  请求参数:
--  {
--      "type":"USER_LOGIN",
--      "data": {
--          "username": "",
--          "password": ""
--      }
--  }
--  返回:
--  {
--      "success": true,
--      "message": "登录成功"
--  }
-- ---------------------------------------------------------
insert into pan_server_func(request_type, func_name) 
values
    ('USER_LOGIN','pan_user_register');