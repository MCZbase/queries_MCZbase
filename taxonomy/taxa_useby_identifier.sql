-- Queries for obtaining counts of taxa used by an agent in identifications.
-- Counts are number of identifications, not cataloged items.

-- Identifications by family made by a particular agent.  Will return a family=null for taxonomy records where the
-- identification is above the family rank, or if the taxonomy record doesn't have a value for family.
select count(*), family 
from identification_agent
left join identification on identification_agent.identification_id = identification.identification_id
left join MCZBASE.identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
left join taxonomy on identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
where agent_id in (
   select agent_id from agent_name where agent_name = 'David G. Smith'
) 
group by family;

-- Identifications by scientific name, with the family also listed, made by a particular agent.  
-- These identifications may be at any rank.  
select count(*), family, taxonomy.scientific_name 
from identification_agent
left join identification on identification_agent.identification_id = identification.identification_id
left join MCZBASE.identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
left join taxonomy on identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
where agent_id in (
   select agent_id from agent_name where agent_name = 'David G. Smith'
) 
group by family, taxonomy.scientific_name;

-- Identifications by scientific name, with the family also listed, made by a particular agent, limited to 
-- identifications at the species rank or lower.  
select count(*), family, taxonomy.scientific_name 
from identification_agent
left join identification on identification_agent.identification_id = identification.identification_id
left join MCZBASE.identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
left join taxonomy on identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
where agent_id in (
   select agent_id from agent_name where agent_name = 'David G. Smith'
) and
taxonomy.species is not null
group by family, taxonomy.scientific_name;

-- Identifications by species, with the family also listed, made by a particular agent, limited to 
-- identifications at the species rank or lower.  This query can return duplicates with different family 
-- values for the same species if, for example, there are subspecies identifications by this agent within 
-- the same species and the value for family differs between them.
select count(*), family, taxonomy.genus, taxonomy.species
from identification_agent
left join identification on identification_agent.identification_id = identification.identification_id
left join MCZBASE.identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
left join taxonomy on identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
where agent_id in (
   select agent_id from agent_name where agent_name = 'David G. Smith'
) and
taxonomy.species is not null
group by family, taxonomy.genus, taxonomy.species;

-- Somewhat different question a count of the cataloged items identified by an agent (current id or not) 
-- by family and taxon used in the identification. 
select count(distinct flat.guid), flat.family, flat.scientific_name 
from identification_agent
join identification on identification_agent.identification_id = identification.identification_id
join coll_object on identification.collection_object_id = coll_object.collection_object_id
join flat on coll_object.collection_object_id = flat.collection_object_id
left join identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
left join taxonomy on identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
where agent_id in (
   select agent_id from agent_name where agent_name = 'David G. Smith'
) 
group by flat.family, flat.scientific_name;
