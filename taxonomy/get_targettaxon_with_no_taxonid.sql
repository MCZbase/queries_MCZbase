-- Obtain a list of taxonomy records that have no taxonID 
-- within some target higher taxon, in a form suitable
-- for input into sci_name_qc to get lookup guids and habitat information in WoRMS
-- Note: expected column names are case sensitive: 
-- dbpk, scientificName, authorship, kingdom, family
SELECT
  taxon_name_id as dbpk,
  scientific_name as scientificName,
  author_text as authorship,
  kingdom,
  family
FROM taxonomy
WHERE taxonid is null
and phylum = 'Bryozoa'
and taxon_name_id in (
   select identification_taxonomy.taxon_name_id 
   from identification_taxonomy
      join identification on identification_taxonomy.identification_id = identification.identification_id
      join cataloged_item on identification.collection_object_id = cataloged_item.collection_object_id
      where cataloged_item.collection_cde = 'IZ'
)
;
-- execute sci_name_qc with csv from above query as input
-- 
-- java -jar sci_name_qc-1.0.1-SNAPSHOT-84dc0d6-executable.jar -f queryoutput.csv -s WoRMS 
-- 
-- load resulting output.csv into a spreadsheet application
--
-- generate sql queries in spreadsheet of results with formulas in the forms below:
--
-- to set taxonid values: 
-- =CONCAT("update taxonomy set taxonid ='",D2,"', taxonid_guid_type='WoRMS LSID' where taxon_name_id = ",A2," and taxonid is null;")
-- For matches where updates to the authorship are desired ** Be selective in match type **: 
-- =CONCAT("update taxonomy set author_text = '",C2,"' where taxon_name_id = ",A2,";")
-- to add habitat information
-- =IF(K2="true",CONCAT("insert into taxon_habitat (taxon_name_id, taxon_habitat) values (",A2,",'brackish');"), "")
-- using the brackish, marine, freshwater, terrestrial columns of the output.csv 
-- run resulting queries to add taxonid, update authorship, or taxon_habitat records.
