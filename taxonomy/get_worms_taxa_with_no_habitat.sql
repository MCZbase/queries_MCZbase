-- Obtain a list of taxonomy records that have a taxonID in WoRMS,
-- but have no habitat information in MCZbase, in a form suitable
-- for input into sci_name_qc to get lookup habitat information in WoRMS
-- Note: expected column names are case sensitive: 
-- dbpk, scientificName, authorship, kingdom, family
SELECT
  taxon_name_id as dbpk, 
  scientific_name as scientificName,
  author_text as authorship,
  kingdom,
  family
FROM taxonomy
WHERE taxonid like '%marinespecies%'
	and taxon_name_id not in (select taxon_name_id from taxon_habitat)
;
-- execute sci_name_qc with csv from above query as input
-- 
-- java -jar sci_name_qc-1.0.1-SNAPSHOT-84dc0d6-executable.jar -f queryoutput.csv -s WoRMS 
-- 
-- load resulting output.csv into a spreadsheet application
--
-- generate sql queries in spreadsheet of results with formulas in the form:
-- =IF(K2="true",CONCAT("insert into taxon_habitat (taxon_name_id, taxon_habitat) values (",A2,",'brackish');"), "")
-- using the brackish, marine, freshwater, terrestrial columns of the output.csv 
-- run resulting queries to add taxon_habitat records.

