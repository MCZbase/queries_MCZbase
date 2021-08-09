--  Obtain a list of cited specimens by cited name within a department, along
--  with metadata for workflows in the CSBR project.
--  Here obtaining Primary types for Herpetology.
select 
	distinct flat.guid, flat.cat_num,
	toptypestatuskind, 
	mczbase.get_top_typestatus(flat.collection_object_id) as toptypestatus,
	taxonomy.family,
	taxonomy.genus as typegenus, 
	taxonomy.species as typespecies, 
	taxonomy.subspecies as typesubspecies, 
	decode(taxonomy.subspecies, null, taxonomy.species, taxonomy.subspecies) as typeepithet,
	typestatusplain, 
	mczbase.get_typestatusname(flat.collection_object_id, mczbase.get_top_typestatus(flat.collection_object_id),0) as typename,  
	mczbase.get_typestatusauthor(flat.collection_object_id, mczbase.get_top_typestatus(flat.collection_object_id)) as typeauthorship,  
	flat.scientific_name as currentname, flat.author_text as currentauthorship, 
	CONCATATTRIBUTEVALUE(flat.collection_object_id,'associated grant') as associatedgrant, 
	CONCATUNDERSCORECOLS(flat.collection_object_id) as namedgroups 
from 
	flat, taxonomy 
where collection_cde = 'Herp' 
	and toptypestatuskind = 'Primary' 
	and taxonomy.taxon_name_id = mczbase.GET_TYPESTATUSTAXON(flat.collection_object_id,mczbase.get_top_typestatus(flat.collection_object_id))
order by taxonomy.family, 
	taxonomy.genus, 
	decode(taxonomy.subspecies, null, taxonomy.species, taxonomy.subspecies)
;
--  Alternate where clause for spider types: 
--  where flat.phylorder = 'Araneae' 
--    and collection_cde = 'IZ'
--    and toptypestatuskind = 'Primary'
--    and taxonomy.taxon_name_id = mczbase.GET_TYPESTATUSTAXON(flat.collection_object_id,mczbase.get_top_typestatus(flat.collection_object_id))
