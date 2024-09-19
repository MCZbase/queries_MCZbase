-- Simple list of the number of cataloged items entered in a collection in each calendar year
select count(*), extract(YEAR from COLL_OBJECT_ENTERED_DATE) as year 
from cataloged_item 
join coll_object on cataloged_item.collection_object_id = coll_object.collection_object_id
where collection_cde = 'Mala'
group by extract(YEAR from COLL_OBJECT_ENTERED_DATE)
order by extract(YEAR from COLL_OBJECT_ENTERED_DATE)  desc

-- Breakdown by who did the data entry in the department in each calendar year for new cataloged item records
select count(*), extract(YEAR from COLL_OBJECT_ENTERED_DATE) as year,  MCZBASE.get_agentnameoftype(ENTERED_PERSON_ID) enteredby 
from cataloged_item 
join coll_object on cataloged_item.collection_object_id = coll_object.collection_object_id
where collection_cde = 'Mala'
group by extract(YEAR from COLL_OBJECT_ENTERED_DATE), MCZBASE.get_agentnameoftype(ENTERED_PERSON_ID)
order by extract(YEAR from COLL_OBJECT_ENTERED_DATE)  desc

-- Breakdown by who did the data entry in the department by month for the last year for new cataloged item records
select count(*), 
extract(YEAR from COLL_OBJECT_ENTERED_DATE) as year,
extract(MONTH from COLL_OBJECT_ENTERED_DATE) as month,  
MCZBASE.get_agentnameoftype(ENTERED_PERSON_ID) enteredby 
from cataloged_item 
join coll_object on cataloged_item.collection_object_id = coll_object.collection_object_id
where collection_cde = 'Mala'
and coll_object_entered_date >= trunc(sysdate,'MM') - interval '1' year
group by 
extract(YEAR from COLL_OBJECT_ENTERED_DATE),  extract(MONTH from COLL_OBJECT_ENTERED_DATE), MCZBASE.get_agentnameoftype(ENTERED_PERSON_ID)
order by extract(YEAR from COLL_OBJECT_ENTERED_DATE)  desc,  extract(MONTH from COLL_OBJECT_ENTERED_DATE) desc

-- Breakdown as above by week for last three months
select count(*), 
extract(YEAR from COLL_OBJECT_ENTERED_DATE) as year,
extract(MONTH from COLL_OBJECT_ENTERED_DATE) as month,  
to_char(coll_object_entered_date,'IW') as weekofyear,
MCZBASE.get_agentnameoftype(ENTERED_PERSON_ID) enteredby 
from cataloged_item 
join coll_object on cataloged_item.collection_object_id = coll_object.collection_object_id
where collection_cde = 'Mala'
and coll_object_entered_date >= trunc(sysdate,'MM') - interval '3' month
group by to_char(coll_object_entered_date,'IW'),
extract(YEAR from COLL_OBJECT_ENTERED_DATE),  extract(MONTH from COLL_OBJECT_ENTERED_DATE), MCZBASE.get_agentnameoftype(ENTERED_PERSON_ID)
order by extract(YEAR from COLL_OBJECT_ENTERED_DATE)  desc,  extract(MONTH from COLL_OBJECT_ENTERED_DATE) desc, to_char(coll_object_entered_date,'IW') desc
