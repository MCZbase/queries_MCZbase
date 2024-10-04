-- Queries to report on material that is in more than a single named group.

-- List of specimens that are in both of a pair of named groups.
select guid from flat
where 
collection_object_id in (
  select collection_object_id 
  from underscore_relation 
  where underscore_collection_id=1 or underscore_collection_id = 2
  group by collection_object_id
  having count(*) > 1
)
order by guid;


-- List of specimens that are in both of a pair of named groups and have not been deaccessioned..
select guid from flat
where 
collection_object_id in (
  select collection_object_id 
  from underscore_relation 
  where underscore_collection_id=1 or underscore_collection_id = 2
  group by collection_object_id
  having count(*) > 1
)
and 
collection_object_id not in (
  select derived_from_cat_item 
  from deacc_item
  join specimen_part on deacc_item.collection_object_id = specimen_part.collection_object_id
)
order by guid;


-- List of items in a named group, with the deaccessions for each item.
-- Returns multiple rows per cataloged item if parts in that cataloged item have
-- different deaccessions (including no deaccession).  Could be made more elegant
-- with aggregation of the rows.
select distinct guid, deacc_number from flat
join specimen_part on flat.collection_object_id = specimen_part.derived_from_cat_item
left join deacc_item on specimen_part.collection_object_id = deacc_item.collection_object_id
left join deaccession on deacc_item.transaction_id = deaccession.transaction_id
where 
flat.collection_object_id in (
  select collection_object_id 
  from underscore_relation 
  where 
  underscore_collection_id = 1
  group by collection_object_id
)
order by guid;
