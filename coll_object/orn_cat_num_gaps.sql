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

-- sanity checks for the above:
select count(*), nvl2(cat_num_integer,0,1)  from cataloged_item where collection_cde = 'Orn' group by nvl2(cat_num_integer,0,1);
-- returns 325716 | 0, indicating that cat_num_integer is not null for all records in the Ornithology collection.
select count(*) from cataloged_item where collection_cde = 'Orn' and (cat_num_prefix is not null or cat_num_suffix is not null);
-- returns 0, indicating that cat_num_prefix and cat_num_suffix are null for all records in the Ornithology collection.

