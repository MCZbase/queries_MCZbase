--  Lookup media records related to specified butterfly families, including DataShot and Type (or other) images, but excluding spectral images
select distinct
media_uri, get_medialabel(media.media_id,'aspect') as aspect, mime_type, media_type, 
guid, family, genus, scientific_name, flat.author_text, sex, toptypestatus, 
collecting_source, collecting_method, country, collectors, began_date, ended_date, 
decode(datashotimage.filename, media.auto_filename, decode(substr(auto_path,18,5),'ent-l','http://skrifa.rc.fas.harvard.edu/imageserver/image.php?imageid=' || imageid || chr(38) || 'region=Specimen',null), null) specimenpartofimage,
'https://mczbase.mcz.harvard.edu/media/' || media.media_id as media_metadata_record 
from media 
left join MCZBASE.media_relations on media.media_id = media_relations.media_id
left join flat on media_relations.related_primary_key = flat.collection_object_id
left join bulkloader_lepidoptera_map on flat.collection_object_id = bulkloader_lepidoptera_map.collection_object_id
left join image@lepidoptera datashotimage on bulkloader_lepidoptera_map.specimenid = datashotimage.specimenid
where 
  auto_path like '%ent-lepidoptera%'
  and auto_path not like '%/spectral/%'
  and media_relationship = 'shows cataloged_item'
  and ( family='Lycaenidae' )
  and (datashotimage.filename is null or datashotimage.filename = media.auto_filename) 
union
select distinct
media_uri, get_medialabel(media.media_id,'aspect') as aspect, mime_type, media_type, 
guid, family, genus, scientific_name, flat.author_text, sex, toptypestatus, 
collecting_source, collecting_method, country, collectors, began_date, ended_date, 
null as specimenpartofimage,
'https://mczbase.mcz.harvard.edu/media/' || media.media_id as media_metadata_record 
from media 
left join MCZBASE.media_relations on media.media_id = media_relations.media_id
left join flat on media_relations.related_primary_key = flat.collection_object_id
left join bulkloader_lepidoptera_map on flat.collection_object_id = bulkloader_lepidoptera_map.collection_object_id
left join image@lepidoptera datashotimage on bulkloader_lepidoptera_map.specimenid = datashotimage.specimenid
where 
  auto_path like '%entomology%'
  and auto_path not like '%/spectral/%'
  and media_relationship = 'shows cataloged_item'
  and ( family='Lycaenidae' )
;
