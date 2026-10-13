# Generates herp_measurements_pivot.sql: one row per Herp specimen, four columns per attribute type.
context = ["sex", "age class"]
measured = """body diameter|carapace height|carapace length|carapace width|chest width|crus length|ear (tympanum) width|eye width|eye-nostril distance|eye-tympanum distance|femur length|foot length|forearm (antebrachium) length|forelimb length|hand length|head height|head length|head width|hindlimb length|humerus length|internarial distance|interocular width|plastron length|plastron width|quadratojugal height|quadratojugal length|size|snout-ear length|snout-eye length|snout-vent length|tail height|tail length|tail width|tarsus length|tibia length|total length|total size|trunk length|tympanum width|ulna length|upper eyelid width|weight""".split("|")
meristic = """dentary teeth|dorsal scale rows (DSR)|infralabials|maxillary teeth|midbody scale rows|palatine teeth|paravertebrals|postoculars|preoculars|pterygoid teeth|subcaudals|supracilliaries|supralabials|temporals|ventrals""".split("|")

def q(s): return s.replace("'", "''")
def agg(t, expr, alias, placeholder=None):
	if placeholder:
		expr = f"CASE WHEN ha.values_of_type > 1 THEN NVL({expr}, '{placeholder}') ELSE {expr} END"
	return (f"\t\tLISTAGG(CASE WHEN ha.attribute_type = '{q(t)}' THEN {expr} END, ' | ')\n"
		f"\t\t\tWITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS \"{alias}\"")

cols = []
for t in context + measured + meristic:
	cols.append(agg(t, "ha.attribute_value", t))
	if t in measured or t == "sex":
		cols.append(agg(t, "ha.attribute_units", f"{t} units", "no units"))
	cols.append(agg(t, "ha.determiner", f"{t} determiner"))
	cols.append(agg(t, "ha.determined_date_text", f"{t} determined date", "no date"))

types = ",\n".join(f"\t\t\t'{q(t)}'" for t in context + measured + meristic)
row_types = ",\n".join(f"\t\t\t\t'{q(t)}'" for t in measured + meristic)
out_cols = ",\n".join(f"\tpivoted.\"{c}\"" for c in [
	x for t in context + measured + meristic for x in
	([t] + ([f"{t} units"] if t in measured or t == "sex" else []) + [f"{t} determiner", f"{t} determined date"])])

sql = f"""WITH herp_attributes AS (
	SELECT
		attributes.attribute_id,
		attributes.collection_object_id,
		attributes.attribute_type,
		attributes.attribute_value,
		attributes.attribute_units,
		attributes.determined_date,
		TO_CHAR(attributes.determined_date, 'YYYY-MM-DD') AS determined_date_text,
		MCZBASE.get_agentnameoftype(attributes.determined_by_agent_id, 'preferred') AS determiner,
		COUNT(*) OVER (PARTITION BY attributes.collection_object_id, attributes.attribute_type) AS values_of_type
	FROM
		filtered_flat ff
		JOIN attributes ON ff.collection_object_id = attributes.collection_object_id
	WHERE
		ff.collection_cde = 'Herp'
		AND attributes.attribute_type IN (
{types}
		)
),
pivoted AS (
	SELECT
		ha.collection_object_id,
{",\n".join(cols)}
	FROM
		herp_attributes ha
	GROUP BY
		ha.collection_object_id
	HAVING
		COUNT(CASE
			WHEN ha.attribute_type = 'size'
				AND NOT REGEXP_LIKE(TRIM(ha.attribute_value), '^-?[0-9]*\\.?[0-9]+$')
				AND NOT REGEXP_LIKE(ha.attribute_value, '[^=;[:space:]][[:space:]]*=[[:space:]]*[^=;[:space:]]') THEN NULL
			WHEN ha.attribute_type IN (
{row_types}
			) THEN 1
		END) > 0
)
SELECT
	ff.guid,
	ff.scientific_name,
	ff.family,
	ff.higher_geog,
	ff.country,
	ff.state_prov,
	ff.county,
	ff.island_group,
	ff.island,
	ff.spec_locality,
	ff.dec_lat,
	ff.dec_long,
	ff.datum,
	ff.coordinateuncertaintyinmeters,
	ff.minimum_elevation,
	ff.maximum_elevation,
	ff.orig_elev_units,
	ff.began_date,
	ff.ended_date,
	ff.verbatim_date,
{out_cols}
FROM
	filtered_flat ff
	JOIN pivoted ON ff.collection_object_id = pivoted.collection_object_id
WHERE
	ff.collection_cde = 'Herp'
ORDER BY
	ff.guid
"""
open("herp_measurements_pivot.sql", "w").write(sql)
print(len(sql.splitlines()), "lines;", out_cols.count("pivoted.") + 20, "output columns")
