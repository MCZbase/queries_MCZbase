-- Find why MCZBASE.UPDATE_FLAT fails on rows of FLAT, e.g. IS_FLAT_STALE stopping with
-- ORA-01427 single-row subquery returns more than one row.
--
-- Mark the suspect rows with stale_flag = 2 (IS_FLAT_STALE only takes stale_flag = 1), run
-- the steps below, fix the data, then set the rows back to stale_flag = 1.
--
--   UPDATE MCZBASE.flat SET stale_flag = 2 WHERE stale_flag = 1;
--
-- You can systematically split the stale rows, e.g. by collection, to isolate the problem and
-- quickly move unnafected rows through, e.g.
--
--   UPDATE MCZBASE.flat SET stale_flag = 1 WHERE stale_flag = 2 AND collection_cde = 'Mala';
--
-- Then run IS_FLAT_STALE, check if the records for that department went through, if so carry 
-- out the steps below on the remaining stale_flag = 2 rows, if not, flip the targeted collection 
-- back to stale_flag = 2 and move all others from 2 to 1, run IS_FLAT_STALE again, and 
-- then carry out the steps below.  Usuall, only a single record will be blocking.  
-- 
-- The error message may be diagnostic - a particular field in FLAT may be to small for the 
-- assembled data, or the problem may be less obvious, e.g. a join in UPDATE_FLAT's subquery 
-- returns more than one row for a record.  The steps below will find the record and the join 
-- that is the problem.
--
-- ORA-01427 with no function in the error stack below UPDATE_FLAT means one of the joins in
-- UPDATE_FLAT's subquery returns more than one row for a record.  Joins that the schema does not
-- hold to one row: accepted identification, 'A' taxon of the accepted identification, accepted
-- georeference of the locality, preferred name of the georeference determiner.

-- 1. Run UPDATE_FLAT on each stale_flag = 2 row and print the rows that fail.  Rolls back.
SET SERVEROUTPUT ON SIZE UNLIMITED
BEGIN
	FOR r IN (
		SELECT collection_object_id, guid
		FROM MCZBASE.flat
		WHERE stale_flag = 2
	) LOOP
		BEGIN
			MCZBASE.UPDATE_FLAT(r.collection_object_id);
		EXCEPTION
			WHEN OTHERS THEN
				dbms_output.put_line(r.collection_object_id || ' ' || r.guid || ': ' || SQLERRM);
		END;
	END LOOP;
	ROLLBACK;
END;
/
-- The output of step 1 shows the records that fail, and the error message may be diagnositic.
-- If not, continue with step 2 to find if a join is the problem.


-- 2. Rows UPDATE_FLAT's joins give for each stale_flag = 2 record; more than 1 is a failure.
SELECT f.collection_object_id, f.guid, count(*) AS row_count
FROM MCZBASE.flat f
	JOIN MCZBASE.cataloged_item ci ON f.collection_object_id = ci.collection_object_id
	JOIN MCZBASE.coll_object co ON ci.collection_object_id = co.collection_object_id
	JOIN MCZBASE.collection c ON ci.collection_id = c.collection_id
	JOIN MCZBASE.accn a ON ci.accn_id = a.transaction_id
	JOIN MCZBASE.trans t ON a.transaction_id = t.transaction_id
	JOIN MCZBASE.collecting_event ce ON ci.collecting_event_id = ce.collecting_event_id
	JOIN MCZBASE.locality l ON ce.locality_id = l.locality_id
	JOIN MCZBASE.geog_auth_rec g ON l.geog_auth_rec_id = g.geog_auth_rec_id
	LEFT JOIN MCZBASE.accepted_lat_long ll ON l.locality_id = ll.locality_id
	LEFT JOIN MCZBASE.preferred_agent_name lldetr ON ll.determined_by_agent_id = lldetr.agent_id
	JOIN MCZBASE.identification i ON ci.collection_object_id = i.collection_object_id AND i.accepted_id_fg = 1
	LEFT JOIN MCZBASE.formatted_publication idpub ON i.publication_id = idpub.publication_id AND idpub.format_style = 'short'
	JOIN MCZBASE.identification_taxonomy it ON i.identification_id = it.identification_id AND it.variable = 'A'
	JOIN MCZBASE.taxonomy tx ON it.taxon_name_id = tx.taxon_name_id
	LEFT JOIN MCZBASE.coll_object_remark cor ON co.collection_object_id = cor.collection_object_id
WHERE f.stale_flag = 2
GROUP BY f.collection_object_id, f.guid
HAVING count(*) > 1;

-- 3. Keys of every join for the records from step 2; the column that differs between a record's
-- rows is the join that duplicates.  cor_rowid differs if coll_object_remark has two rows.
SELECT
	ci.collection_object_id,
	c.collection_id,
	a.transaction_id AS accn_id,
	ce.collecting_event_id,
	l.locality_id,
	g.geog_auth_rec_id,
	ll.lat_long_id,
	lldetr.agent_id AS lldetr_agent_id, lldetr.agent_name AS lldetr_name,
	i.identification_id,
	idpub.publication_id,
	it.taxon_name_id,
	cor.rowid AS cor_rowid
FROM MCZBASE.flat f
	JOIN MCZBASE.cataloged_item ci ON f.collection_object_id = ci.collection_object_id
	JOIN MCZBASE.coll_object co ON ci.collection_object_id = co.collection_object_id
	JOIN MCZBASE.collection c ON ci.collection_id = c.collection_id
	JOIN MCZBASE.accn a ON ci.accn_id = a.transaction_id
	JOIN MCZBASE.trans t ON a.transaction_id = t.transaction_id
	JOIN MCZBASE.collecting_event ce ON ci.collecting_event_id = ce.collecting_event_id
	JOIN MCZBASE.locality l ON ce.locality_id = l.locality_id
	JOIN MCZBASE.geog_auth_rec g ON l.geog_auth_rec_id = g.geog_auth_rec_id
	LEFT JOIN MCZBASE.accepted_lat_long ll ON l.locality_id = ll.locality_id
	LEFT JOIN MCZBASE.preferred_agent_name lldetr ON ll.determined_by_agent_id = lldetr.agent_id
	JOIN MCZBASE.identification i ON ci.collection_object_id = i.collection_object_id AND i.accepted_id_fg = 1
	LEFT JOIN MCZBASE.formatted_publication idpub ON i.publication_id = idpub.publication_id AND idpub.format_style = 'short'
	JOIN MCZBASE.identification_taxonomy it ON i.identification_id = it.identification_id AND it.variable = 'A'
	JOIN MCZBASE.taxonomy tx ON it.taxon_name_id = tx.taxon_name_id
	LEFT JOIN MCZBASE.coll_object_remark cor ON co.collection_object_id = cor.collection_object_id
WHERE f.stale_flag = 2
	AND f.collection_object_id IN (
		SELECT ci2.collection_object_id
		FROM MCZBASE.cataloged_item ci2
			JOIN MCZBASE.collecting_event ce2 ON ci2.collecting_event_id = ce2.collecting_event_id
			LEFT JOIN MCZBASE.accepted_lat_long ll2 ON ce2.locality_id = ll2.locality_id
			LEFT JOIN MCZBASE.preferred_agent_name pan2 ON ll2.determined_by_agent_id = pan2.agent_id
			JOIN MCZBASE.identification i2 ON ci2.collection_object_id = i2.collection_object_id AND i2.accepted_id_fg = 1
			JOIN MCZBASE.identification_taxonomy it2 ON i2.identification_id = it2.identification_id AND it2.variable = 'A'
			LEFT JOIN MCZBASE.coll_object_remark cor2 ON ci2.collection_object_id = cor2.collection_object_id
		GROUP BY ci2.collection_object_id
		HAVING count(*) > 1
	)
ORDER BY ci.collection_object_id, ll.lat_long_id, i.identification_id;

-- 4. The usual causes, one query each.

-- 4a. More than one accepted identification
SELECT f.collection_object_id, f.guid, i.identification_id, i.scientific_name, i.made_date
FROM MCZBASE.flat f
	JOIN MCZBASE.identification i ON f.collection_object_id = i.collection_object_id
WHERE f.stale_flag = 2
	AND i.accepted_id_fg = 1
	AND f.collection_object_id IN (
		SELECT collection_object_id FROM MCZBASE.identification
		WHERE accepted_id_fg = 1
		GROUP BY collection_object_id HAVING count(*) > 1
	)
ORDER BY f.collection_object_id;

-- 4b. More than one 'A' taxon on the accepted identification
SELECT f.collection_object_id, f.guid, i.identification_id, i.taxa_formula, it.taxon_name_id, tx.scientific_name
FROM MCZBASE.flat f
	JOIN MCZBASE.identification i ON f.collection_object_id = i.collection_object_id AND i.accepted_id_fg = 1
	JOIN MCZBASE.identification_taxonomy it ON i.identification_id = it.identification_id AND it.variable = 'A'
	JOIN MCZBASE.taxonomy tx ON it.taxon_name_id = tx.taxon_name_id
WHERE f.stale_flag = 2
	AND i.identification_id IN (
		SELECT identification_id FROM MCZBASE.identification_taxonomy
		WHERE variable = 'A'
		GROUP BY identification_id HAVING count(*) > 1
	)
ORDER BY f.collection_object_id;

-- 4c. More than one accepted georeference for the locality
-- Fix by setting accepted_lat_long_fg = 0 on the georeference not wanted; this fixes every
-- cataloged item at the locality.
SELECT f.collection_object_id, f.guid, ce.locality_id, ll.lat_long_id, ll.dec_lat, ll.dec_long,
	ll.datum, ll.determined_by_agent_id, ll.determined_date, ll.georefmethod, ll.verificationstatus
FROM MCZBASE.flat f
	JOIN MCZBASE.cataloged_item ci ON f.collection_object_id = ci.collection_object_id
	JOIN MCZBASE.collecting_event ce ON ci.collecting_event_id = ce.collecting_event_id
	JOIN MCZBASE.lat_long ll ON ce.locality_id = ll.locality_id AND ll.accepted_lat_long_fg = 1
WHERE f.stale_flag = 2
	AND ce.locality_id IN (
		SELECT locality_id FROM MCZBASE.lat_long
		WHERE accepted_lat_long_fg = 1
		GROUP BY locality_id HAVING count(*) > 1
	)
ORDER BY f.collection_object_id, ll.lat_long_id;

-- 4d. More than one preferred name for the agent who made the accepted georeference
SELECT f.collection_object_id, f.guid, ll.determined_by_agent_id, an.agent_name_id, an.agent_name
FROM MCZBASE.flat f
	JOIN MCZBASE.cataloged_item ci ON f.collection_object_id = ci.collection_object_id
	JOIN MCZBASE.collecting_event ce ON ci.collecting_event_id = ce.collecting_event_id
	JOIN MCZBASE.lat_long ll ON ce.locality_id = ll.locality_id AND ll.accepted_lat_long_fg = 1
	JOIN MCZBASE.agent_name an ON ll.determined_by_agent_id = an.agent_id AND an.agent_name_type = 'preferred'
WHERE f.stale_flag = 2
	AND ll.determined_by_agent_id IN (
		SELECT agent_id FROM MCZBASE.agent_name
		WHERE agent_name_type = 'preferred'
		GROUP BY agent_id HAVING count(*) > 1
	)
ORDER BY f.collection_object_id;

-- 5. If step 1 shows failures but step 2 finds no duplicate rows, call each function UPDATE_FLAT
-- uses, one at a time, for each stale_flag = 2 record, and print those that raise.  Read-only.
-- The list follows UPDATE_FLAT; compare with the compiled source if it may have changed:
--   SELECT line, text FROM all_source WHERE owner = 'MCZBASE' AND name = 'UPDATE_FLAT' ORDER BY line;
DECLARE
	result VARCHAR2(32767);
	stmt VARCHAR2(1000);
	TYPE exprList IS TABLE OF VARCHAR2(400);
	-- :c collection_object_id, :t accn transaction_id, :l locality_id, :g country
	exprs exprList := exprList(
		'MCZBASE.GET_TRANS_RECIEVEDAGENT(:t)',
		'MCZBASE.get_individualcount(:c)',
		'MCZBASE.CONCATDISPOSITIONS(:c)',
		'MCZBASE.concatColl(:c)',
		'MCZBASE.GET_SOLE_COLLECTOR_GUID(:c)',
		'MCZBASE.concatPrep(:c)',
		'MCZBASE.concatSingleOtherId(:c, ''field number'')',
		'MCZBASE.concatOtherId(:c)',
		'MCZBASE.concatGenbank(:c)',
		'MCZBASE.concatRelations(:c)',
		'MCZBASE.concatTypeStatus(:c)',
		'MCZBASE.concatTypeStatus_Words(:c)',
		'MCZBASE.concatTypeStatus_Plain(:c)',
		'MCZBASE.concatAttributeValue(:c, ''sex'')',
		'MCZBASE.concatParts(:c)',
		'MCZBASE.concatPartsDetail(:c)',
		'MCZBASE.concatEncumbrances(:c)',
		'MCZBASE.concatidentifiers(:c)',
		'MCZBASE.GET_SOLE_DETERMINER_GUID(:c)',
		'MCZBASE.get_taxonomy(:c, ''full_taxon_name'')',
		'MCZBASE.get_taxonomy(:c, ''Genus'')',
		'MCZBASE.concatAttributeValue(:c, ''age class'')',
		'MCZBASE.concatattribute(:c)',
		'MCZBASE.concatimageurl(:c)',
		'MCZBASE.concatimageurlfiltered(:c)',
		'MCZBASE.concatSingleOtherId(:c, ''collector number'')',
		'MCZBASE.sumparts(:c)',
		'MCZBASE.concatcitedas(:c)',
		'MCZBASE.get_geol_attr_range(:l, ''Eonothem/Eon'', 1)',
		'MCZBASE.get_geol_attr_range(:l, ''Erathem/Era'', 1)',
		'MCZBASE.get_geol_attr_range(:l, ''Period/System'', 1)',
		'MCZBASE.get_geol_attr_range(:l, ''Epoch/Series'', 1)',
		'MCZBASE.get_geol_attr_range(:l, ''Age/Stage'', 1)',
		'MCZBASE.get_lithostratigraphy(:l)',
		'MCZBASE.get_lithostrat_attr(:l, ''Group'')',
		'MCZBASE.get_lithostrat_attr(:l, ''Formation'')',
		'MCZBASE.GET_ASSOC_COLLID(:c)',
		'MCZBASE.concatAttributesJSON(:c)',
		'MCZBASE.GET_GENBANK_LINKS(:c)',
		'MCZBASE.get_top_typestatus_kind(:c)',
		'MCZBASE.get_top_typestatus(:c)',
		'MCZBASE.get_countrycode(:g)',
		'MCZBASE.is_recataloged(:c)',
		'MCZBASE.get_stored_as_id(:c)',
		'MCZBASE.GET_STORAGE_ROOMS(:c)',
		'MCZBASE.GET_STORAGE_CABINETS(:c)',
		'MCZBASE.GET_STORAGE_DRAWERS(:c)'
	);
BEGIN
	FOR r IN (
		SELECT f.collection_object_id, f.guid, ci.accn_id, ce.locality_id, g.country
		FROM MCZBASE.flat f
			JOIN MCZBASE.cataloged_item ci ON f.collection_object_id = ci.collection_object_id
			JOIN MCZBASE.collecting_event ce ON ci.collecting_event_id = ce.collecting_event_id
			JOIN MCZBASE.locality l ON ce.locality_id = l.locality_id
			JOIN MCZBASE.geog_auth_rec g ON l.geog_auth_rec_id = g.geog_auth_rec_id
		WHERE f.stale_flag = 2
	) LOOP
		FOR i IN 1 .. exprs.COUNT LOOP
			stmt := 'SELECT to_char(' || exprs(i) || ') FROM dual';
			BEGIN
				IF instr(exprs(i), ':t') > 0 THEN
					EXECUTE IMMEDIATE stmt INTO result USING r.accn_id;
				ELSIF instr(exprs(i), ':l') > 0 THEN
					EXECUTE IMMEDIATE stmt INTO result USING r.locality_id;
				ELSIF instr(exprs(i), ':g') > 0 THEN
					EXECUTE IMMEDIATE stmt INTO result USING r.country;
				ELSE
					EXECUTE IMMEDIATE stmt INTO result USING r.collection_object_id;
				END IF;
			EXCEPTION
				WHEN OTHERS THEN
					dbms_output.put_line(r.collection_object_id || ' ' || r.guid || ' FAILS: ' || exprs(i));
					dbms_output.put_line(dbms_utility.format_error_stack || dbms_utility.format_error_backtrace);
			END;
		END LOOP;
	END LOOP;
	dbms_output.put_line('done');
END;
/

-- 6. Localities anywhere with more than one accepted georeference (not limited to stale rows).
SELECT locality_id, count(*) AS accepted_count
FROM MCZBASE.lat_long
WHERE accepted_lat_long_fg = 1
GROUP BY locality_id
HAVING count(*) > 1;
