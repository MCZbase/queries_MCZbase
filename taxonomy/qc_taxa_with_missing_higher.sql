-- query to obtain a list of taxa used in identifications or citations within a department
-- example using VP as the department.
select 
distinct
taxonomy.SCIENTIFIC_NAME ,
taxonomy.TAXON_NAME_ID , 
KINGDOM , PHYLUM , SUBPHYLUM , SUPERCLASS , PHYLCLASS , SUBCLASS , INFRACLASS ,
SUPERORDER , PHYLORDER , SUBORDER ,INFRAORDER ,
SUPERFAMILY , FAMILY , SUBFAMILY , TRIBE , SUBSECTION ,
GENUS , SUBGENUS ,
SPECIES , SUBSPECIES , INFRASPECIFIC_RANK ,
AUTHOR_TEXT , 
VALID_CATALOG_TERM_FG , SOURCE_AUTHORITY ,
FULL_TAXON_NAME ,  DISPLAY_NAME ,
TAXON_REMARKS ,
NOMENCLATURAL_CODE ,
TAXON_STATUS ,
GUID , TAXONID_GUID_TYPE ,TAXONID , SCIENTIFICNAMEID_GUID_TYPE , SCIENTIFICNAMEID  
from taxonomy
where taxon_name_id in 
( select taxon_name_id from 
identification_taxonomy 
left join identification on identification_taxonomy.IDENTIFICATION_ID = identification.identification_id
left join cataloged_item on identification.collection_object_id = cataloged_item.COLLECTION_OBJECT_ID
where cataloged_item.collection_cde = 'VP'
union
select CITED_TAXON_NAME_ID as taxon_name_id from 
CITATION left join cataloged_item on CITATION.COLLECTION_OBJECT_ID = CATALOGED_ITEM.COLLECTION_OBJECT_ID
where cataloged_item.collection_cde = 'VP'
)
and 
(
phylclass is null 
or PHYLORDER is null
or FAMILY is null
)
;
-- add/remove IS NULL criteria from this last clause as desired.
--
-- alternate form with limitation to taxa used only by the specified department and not shared with others
select 
distinct
taxonomy.SCIENTIFIC_NAME ,
taxonomy.TAXON_NAME_ID , 
KINGDOM , PHYLUM , SUBPHYLUM , SUPERCLASS , PHYLCLASS , SUBCLASS , INFRACLASS ,
SUPERORDER , PHYLORDER , SUBORDER ,INFRAORDER ,
SUPERFAMILY , FAMILY , SUBFAMILY , TRIBE , SUBSECTION ,
GENUS , SUBGENUS ,
SPECIES , SUBSPECIES , INFRASPECIFIC_RANK ,
AUTHOR_TEXT , 
VALID_CATALOG_TERM_FG , SOURCE_AUTHORITY ,
FULL_TAXON_NAME ,  DISPLAY_NAME ,
TAXON_REMARKS ,
NOMENCLATURAL_CODE ,
TAXON_STATUS ,
GUID , TAXONID_GUID_TYPE ,TAXONID , SCIENTIFICNAMEID_GUID_TYPE , SCIENTIFICNAMEID  
from taxonomy
where taxon_name_id in 
( select taxon_name_id from 
identification_taxonomy 
left join identification on identification_taxonomy.IDENTIFICATION_ID = identification.identification_id
left join cataloged_item on identification.collection_object_id = cataloged_item.COLLECTION_OBJECT_ID
where cataloged_item.collection_cde = 'VP'
union
select CITED_TAXON_NAME_ID as taxon_name_id from 
CITATION left join cataloged_item on CITATION.COLLECTION_OBJECT_ID = CATALOGED_ITEM.COLLECTION_OBJECT_ID
where cataloged_item.collection_cde = 'VP'
)
and taxon_name_id NOT in 
( select taxon_name_id from 
identification_taxonomy 
left join identification on identification_taxonomy.IDENTIFICATION_ID = identification.identification_id
left join cataloged_item on identification.collection_object_id = cataloged_item.COLLECTION_OBJECT_ID
where cataloged_item.collection_cde <> 'VP'
union
select CITED_TAXON_NAME_ID as taxon_name_id from 
CITATION left join cataloged_item on CITATION.COLLECTION_OBJECT_ID = CATALOGED_ITEM.COLLECTION_OBJECT_ID
where cataloged_item.collection_cde <> 'VP'
)
and 
(
phylclass is null 
or PHYLORDER is null
or FAMILY is null
)
;
