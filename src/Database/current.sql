set client_encoding to utf8;

-- 当前编辑sql脚本
-- 当sql脚本能正确运行后，请拷贝到相应的其他sql文件里
-- 如：
--      用户相关的sql拷贝到 user.sql
--      服务相关的sql拷贝到 server.sql

create or replace function pan_user_register(params jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    response jsonb;
    server_available boolean;
    gis_server_conn_str varchar;
    gis_server_id integer;
    myrec record;
    user_salt varchar;
    user_id varchar;
    ret text;
    user_status integer;
begin
    -- 检查用户是否已经注册成功
    user_status := 1;
    SELECT status into user_status from pan_user where username = (params->'data'->>'username');
    if  pan_user_exist(params->'data'->>'username') and user_status > 1 then 
        return jsonb_build_object(
            'success', false,
            'message', '用户已经存在'
        );
    end if;

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
    
    --  获取资源最富余的服务数据库节点
    select 
        id ,
        'host=' || db_host || ' port=' || db_port || ' dbname=' || db_name || ' user=' || db_user || ' password=' || db_password 
        into gis_server_id, gis_server_conn_str
    from 
        pan_server
    where 
        user_count <= max_user_count
    order by user_count limit 1;

    if gis_server_id is null then 
        return jsonb_build_object(
            'success',false,
            'message','服务器资源有限，请联系管理员'
        );
    end if;
    

    --  向节点数据库中插入用户信息
    select id,salt into user_id,user_salt from pan_user where username = params->'data'->>'username';
    update 
        pan_user
    set
        nickname = params->'data'->>'nickname',
        password = md5(salt || (params->'data'->>'password')),
        status = 2,
        register_time = now(),
        server_id = gis_server_id
    where 
        id = user_id ;

    sqlstr := 'insert into pan_user(id,username,nickname,password,register_time,status, server_id) values (
            ' || quote_literal(user_id) || ',
            ' || quote_literal(params->'data'->>'username') || ',
            ' || quote_literal(params->'data'->> 'nickname') || ',
            ' || quote_literal(md5( user_salt || (params->'data'->>'password'))) || ',
            ' || quote_literal(now()) || '::timestamp,
            2, 
            ' || gis_server_id || '
        )';

    perform pan_dblink_execute_sql(gis_server_conn_str,sqlstr);

    response := jsonb_build_object(
        'success',true,
        'message','用户注册（创建）成功'
    );
    return response;
end;
$$ language 'plpgsql';




create or replace function pan_user_login(params jsonb) returns jsonb as 
$$
declare
    mytoken varchar;
    login_success boolean;
    url varchar;
begin
    -- if not pan_user_exist(params->'data'->>'username') then 
    --     return jsonb_build_object(
    --         'success', false,
    --         'message', '登录失败'
    --     );
    -- end if;

    mytoken := pan_generate_token();
    login_success := false;
    select 
        count(1) = 1  into login_success
    from 
        pan_user 
    where
        username = (params->'data'->>'username') 
        and 
        password = md5(salt || (params->'data'->>'password')) ;
    if not login_success then 
        return jsonb_build_object(
            'success', false,
            'message', '登录失败'
        );
    end if;

    update pan_user 
    set 
        token = mytoken,
        token_expire_time = now() + pan_get_configuration('TOKEN_VALID_TIME')::interval
    where 
        username = (params->'data'->>'username');
    
    select web_url into url from pan_server where 
        id = (select server_id from pan_user where username = (params->'data'->>'username') limit 1);


    return jsonb_build_object(
        'success',true,
        'message','登录成功',
        'data', jsonb_build_object(
            'token',mytoken,
            'url', url
        )
    );
end;
$$ language 'plpgsql';



