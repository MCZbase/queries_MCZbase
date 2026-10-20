-- Ornithology catalog numbers should be sequential integers as found in the
-- ledgers, but there are gaps in MCZbase as specimens were entered from the
-- collection so material that had been exchanged or otherwise not in the 
-- collection was not entered. This query finds the gaps in the catalog 
-- number series for the Ornithology collection.

SELECT
        gap_start,
        gap_end,
        gap_end - gap_start + 1 AS missing_count
FROM (
        SELECT
                cat_num_integer + 1 AS gap_start,
                LEAD(cat_num_integer) OVER (ORDER BY cat_num_integer) - 1 AS gap_end
        FROM (
                SELECT DISTINCT cat_num_integer
                FROM cataloged_item
                WHERE collection_cde = 'Orn'
        )
)
WHERE gap_end >= gap_start
ORDER BY gap_start;

-- and to go and look up the ledger scans for each gap: 

WITH gaps AS (
        SELECT
                gap_start,
                gap_end,
                gap_end - gap_start + 1 AS missing_count
        FROM (
                SELECT
                        cat_num_integer + 1 AS gap_start,
                        LEAD(cat_num_integer) OVER (ORDER BY cat_num_integer) - 1 AS gap_end
                FROM (
                        SELECT DISTINCT cat_num_integer
                        FROM cataloged_item
                        WHERE collection_cde = 'Orn'
                )
        )
        WHERE gap_end >= gap_start
)
SELECT
        gaps.gap_start,
        gaps.gap_end,
        'MCZ:Orn:' || gaps.gap_start AS gapstartguid,
        'MCZ:Orn:' || gaps.gap_end AS gapendguid,
        gaps.missing_count,
        ledger.volumename,
        ledger.volumepage,
        ledger.startnum,
        ledger.endnum,
        ledger.idsurn,
        ledger.filename
FROM gaps
        LEFT JOIN mczbase.ledgerscans_master ledger
                ON ledger.department = 'Ornithology'
                AND ledger.collection = 'Birds'
                AND ledger.startnum <= gaps.gap_end
                AND ledger.endnum >= gaps.gap_start
ORDER BY gaps.gap_start, ledger.volumename, ledger.volumepage;

-- sanity checks for the above:
select count(*), nvl2(cat_num_integer,0,1)  from cataloged_item where collection_cde = 'Orn' group by nvl2(cat_num_integer,0,1);
-- returns 325716 | 0, indicating that cat_num_integer is not null for all records in the Ornithology collection.
select count(*) from cataloged_item where collection_cde = 'Orn' and (cat_num_prefix is not null or cat_num_suffix is not null);
-- returns 0, indicating that cat_num_prefix and cat_num_suffix are null for all records in the Ornithology collection.

-- To obtain the list of missing numbers (62,483): 

WITH bounds AS (
        SELECT
                MIN(cat_num_integer) AS low,
                MAX(cat_num_integer) AS high
        FROM cataloged_item
        WHERE collection_cde = 'Orn'
),
all_numbers AS (
        SELECT low + LEVEL - 1 AS cat_num_integer
        FROM bounds
        CONNECT BY LEVEL <= high - low + 1
)
SELECT cat_num_integer AS missing_cat_num
FROM all_numbers
MINUS
SELECT cat_num_integer
FROM cataloged_item
WHERE collection_cde = 'Orn'
ORDER BY missing_cat_num;
