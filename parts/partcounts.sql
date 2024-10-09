-- Queries to count the number of parts and preservation types in use


-- Parts and preservation types in a department, counting cataloged items:
SELECT count(derived_from_cat_item) as ct, part_name, preserve_method
FROM specimen_part
WHERE derived_from_cat_item IN ( select collection_object_id from cataloged_item where collection_cde = 'Mala')
GROUP BY part_name, preserve_method
ORDER BY part_name, preserve_method;

-- Parts and preservation types in a department, counting parts:
SELECT count(collection_object_id) as ct, part_name, preserve_method
FROM specimen_part
WHERE derived_from_cat_item IN ( select collection_object_id from cataloged_item where collection_cde = 'Mala')
GROUP BY part_name, preserve_method
ORDER BY part_name, preserve_method;

-- Parts types by department, counting parts:
SELECT count(specimen_part.collection_object_id) as ct, part_name, collection_cde 
FROM specimen_part
JOIN cataloged_item ON specimen_part.derived_from_cat_item = cataloged_item.collection_object_id
GROUP BY part_name, collection_cde
ORDER BY collection_cde, part_name;

