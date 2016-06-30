select p.ts
     , p.epoch
     , q.rsqname
--      , array_accum1(rol)
     , sum(p.vsz)
     , count(1) 
from (
    select to_timestamp(epoch)::timestamp ts
         , epoch
         , vsz
         , (string_to_array(command,' '))[4] as rol 
         , (string_to_array(command,' '))[7] as session 
         , (string_to_array(command,' '))[9] as cmdcount 
    from pidstat
) p 
join  pg_roles r on p.rol = r.rolname
join  pg_resqueue q on q.oid = r.rolresqueue 
where p.ts between '2014-11-17 13:00' and '2014-11-17 14:00'
and   q.rsqname in ('pg_default','high','dba')
group by 1,2,3
order by 1,2,3;
