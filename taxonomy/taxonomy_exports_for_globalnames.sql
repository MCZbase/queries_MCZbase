select 
GET_MCZTYPESTATUSFORTAXON(taxon_name_id) as mcz_types,
GET_MCZCITATIONSFORTAXON(taxon_name_id) as citations,
SCIENTIFIC_NAME ,
AUTHOR_TEXT ,
KINGDOM,
PHYLUM ,
SUBPHYLUM ,
SUPERCLASS ,
PHYLCLASS ,
SUBCLASS ,
INFRACLASS ,
INFRAORDER ,
SUPERORDER ,
PHYLORDER ,
SUBORDER ,
SUPERFAMILY ,
FAMILY ,
SUBFAMILY ,
TRIBE ,
GENUS ,
SUBGENUS ,
SPECIES ,
SUBSPECIES ,
INFRASPECIFIC_RANK ,
NOMENCLATURAL_CODE ,
VALID_CATALOG_TERM_FG as allowed_for_dataentry,
SOURCE_AUTHORITY ,
TAXON_REMARKS ,
TAXON_STATUS ,
TAXONID_GUID_TYPE ,
TAXONID ,
SCIENTIFICNAMEID_GUID_TYPE ,
SCIENTIFICNAMEID 
from taxonomy
where genus <> 'Homo'
and nomenclatural_code <> 'ICNafp'
and species is not null
and taxon_name_id in (
select cited_taxon_name_id from citation
union
select TAXON_NAME_ID from identification_taxonomy
)
;

select 
distinct
media_uri, publication_type, published_year, type_status, 
SCIENTIFIC_NAME ,
AUTHOR_TEXT ,
KINGDOM,
PHYLUM ,
SUBPHYLUM ,
SUPERCLASS ,
PHYLCLASS ,
SUBCLASS ,
INFRACLASS ,
INFRAORDER ,
SUPERORDER ,
PHYLORDER ,
SUBORDER ,
SUPERFAMILY ,
FAMILY ,
SUBFAMILY ,
TRIBE ,
GENUS ,
SUBGENUS ,
SPECIES ,
SUBSPECIES ,
INFRASPECIFIC_RANK ,
NOMENCLATURAL_CODE ,
VALID_CATALOG_TERM_FG as allowed_for_dataentry,
SOURCE_AUTHORITY ,
TAXON_REMARKS ,
TAXON_STATUS ,
TAXONID_GUID_TYPE ,
TAXONID ,
SCIENTIFICNAMEID_GUID_TYPE ,
SCIENTIFICNAMEID 
from media 
left outer join media_relations on media.MEDIA_ID = media_relations.MEDIA_ID
left outer join publication on media_relations.related_primary_key = publication.PUBLICATION_ID
left outer join citation on publication.PUBLICATION_ID = citation.PUBLICATION_ID
left outer join taxonomy on citation.cited_taxon_name_id = taxonomy.taxon_name_id
where media_uri like '%biodiversitylibrary%'
and media_relations.MEDIA_RELATIONSHIP = 'shows publication'
and genus <> 'Homo'
and nomenclatural_code <> 'ICNafp'
and species is not null
;