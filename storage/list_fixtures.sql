-- Queries to list containers that are at levels between a room and the collection object: 

-- Containers within a room that aren't collection objects (or pins):
SELECT container_type, label, barcode, sys_connect_by_path( label || ' (' || container_type ||')' ,' | ') parentage
FROM container
WHERE ( container_type <> 'pin' AND container_type <> 'collection object' )
START WITH barcode = 'MCZ-419'
CONNECT BY PRIOR container_id = parent_container_id
ORDER BY label
;

