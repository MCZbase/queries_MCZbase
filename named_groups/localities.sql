-- various queries to obtain locality information about specimens in a named group

-- This query returns the locality_id, spec_locality, sovereign_nation, and curated_fg for each locality
-- that has specimens in the Big Bee Named Group (underscore_collection_id = 701)

select distinct
locality.locality_id, spec_locality, sovereign_nation, curated_fg 
from 
cataloged_item
join collecting_event on cataloged_item.collecting_event_id = collecting_event.collecting_event_id
join locality on collecting_event.locality_id = locality.locality_id
join underscore_relation on cataloged_item.collection_object_id = underscore_relation.collection_object_id
where underscore_relation.underscore_collection_id = 701
;


-- This query counts the number of specimens in each locality for the Big Bee Named Group
select count(cataloged_item.collection_object_id) ct,
locality.locality_id, spec_locality, sovereign_nation, curated_fg 
from 
cataloged_item
join collecting_event on cataloged_item.collecting_event_id = collecting_event.collecting_event_id
join locality on collecting_event.locality_id = locality.locality_id
join underscore_relation on cataloged_item.collection_object_id = underscore_relation.collection_object_id 
where underscore_relation.underscore_collection_id = 701
group by locality.locality_id, spec_locality, sovereign_nation, curated_fg
order by count(cataloged_item.collection_object_id) desc
;

-- This query counts the number of specimens in each locality for the Big Bee Named Group, including higher geography.

select count(cataloged_item.collection_object_id) ct,
locality.locality_id, higher_geog, spec_locality, sovereign_nation, locality.curated_fg 
from 
cataloged_item
join collecting_event on cataloged_item.collecting_event_id = collecting_event.collecting_event_id
join locality on collecting_event.locality_id = locality.locality_id
join geog_auth_rec on locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id
join underscore_relation on cataloged_item.collection_object_id = underscore_relation.collection_object_id 
where underscore_relation.underscore_collection_id = 701
group by locality.locality_id, higher_geog, spec_locality, sovereign_nation, locality.curated_fg
order by higher_geog
;

-- The same query, but selecting by the name of the named group instead of the underscore_collection_id
select count(cataloged_item.collection_object_id) ct,
locality.locality_id, higher_geog, spec_locality, sovereign_nation, locality.curated_fg 
from 
cataloged_item
join collecting_event on cataloged_item.collecting_event_id = collecting_event.collecting_event_id
join locality on collecting_event.locality_id = locality.locality_id
join geog_auth_rec on locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id
join underscore_relation on cataloged_item.collection_object_id = underscore_relation.collection_object_id 
join underscore_collection on underscore_relation.underscore_collection_id = underscore_collection.underscore_collection_id
where underscore_collection.collection_name like '%Big-Bee%'
group by locality.locality_id, higher_geog, spec_locality, sovereign_nation, locality.curated_fg
order by higher_geog
;


