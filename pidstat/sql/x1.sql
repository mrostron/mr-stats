select  sum(vsz)
      , sum(rss)
      , to_timestamp(epoch)::timestamp ts
      , epoch
from pidstat
-- where to_timestamp(epoch) between '2014-11-17 13:00' and '2014-11-17 14:00'
where to_timestamp(epoch) between '2014-11-17 18:00' and '2014-11-17 19:00'
group by 3,4
-- having sum(vsz) > 100000000 or sum(rss) > 64000000 
order by 3
;
