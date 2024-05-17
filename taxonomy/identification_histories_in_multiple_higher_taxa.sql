-- Queries for obtaining lists of specimens where the identification histories place
-- the specimen in more than one genus or more than one higher taxon.

-- Cataloged items where the identification history contains more than one genus
-- restricting the result to current identification in a single family
select flat.guid, flat.scientific_name, listagg(taxonomy.genus, ',') within group (order by taxonomy.genus)
from flat 
join identification on flat.collection_object_id = identification.collection_object_id
join identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
join taxonomy on identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id 
where flat.collection_object_id in (
select collection_object_id
from identification 
join identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
join taxonomy on identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
group by collection_object_id
having count(distinct taxonomy.genus) > 1)
and flat.family = 'Muricidae'
group by flat.guid, flat.scientific_name;

-- Cataloged items where the identification history contains more than one family
-- restricting the results to a class in the Malacology collection
select flat.guid, flat.scientific_name, listagg(taxonomy.family, ',') within group (order by taxonomy.family)
from flat 
join identification on flat.collection_object_id = identification.collection_object_id
join identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
join taxonomy on identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id 
where flat.collection_object_id in (
select collection_object_id
from identification 
join identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
join taxonomy on identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
group by collection_object_id
having count(distinct taxonomy.family) > 1)
and flat.phylclass = 'Gastropoda'
and flat.collection_cde = 'Mala'
group by flat.guid, flat.scientific_name;
