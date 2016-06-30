select  avg(vsz)::integer vsz
      , to_char(ts,'hh24:mi:00') ts 
from (
    select  sum(vsz) as vsz
          , sum(rss) as rss
          , to_timestamp(epoch)::timestamp ts
          , epoch
    from pidstat
    where to_timestamp(epoch) between '2014-11-17 13:00' and '2014-11-17 14:00'
    group by 3,4
    -- having sum(vsz) > 100000000 or sum(rss) > 64000000 
    order by 3
)x
group by 2 order by 2
;
