-- 系统需要的一些杂项函数

-- 生成特定长度的随机字符串
-- 
create or replace function pan_random_string(len integer) returns varchar as 
$$
declare
    seeds char[] ;
    seeds_len integer;
    sqlstr text;
    myrec record;
    randomstr text;
begin
    seeds := array[
        'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
        '0','1','2','3','4','5','6','7','8','9'
    ];
    seeds_len := array_length(seeds,1);
    sqlstr := '
        select 
            floor(' || seeds_len || '*random())+1 
        from 
            generate_series(1,' || len || ') as idx
    '；
    randomstr := '';
    for myrec in execute sqlstr loop
        randomstr := randomstr || seeds[myrec.idx]::varchar;
    end loop;
    return randomstr;
end;
$$ language 'plpgsql';

select pan_random_string(32);