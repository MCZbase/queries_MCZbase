select count(locality_id), agent_name
from lat_long
join preferred_agent_name on determined_by_agent_id = agent_id
where to_char(determined_date,'yyyy-mm-dd') between '2021-07-1' and '2022-06-30'
and locality_id in (select locality_id from flat where collection_cde = 'Mamm')
group by agent_name
order by count(*) desc
;
