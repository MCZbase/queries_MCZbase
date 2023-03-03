-- List all freezer boxes in cryovats, with their parentage within the vats.

SELECT container_type, label, sys_connect_by_path( label || ' (' || container_type ||')' ,' | ') parentage
FROM container
WHERE ( container_type = 'freezer box')
START WITH container_type = 'cryovat'
CONNECT BY PRIOR container_id = parent_container_id
ORDER BY label
;

-- List all cryovials in cryovats, with their parentage within the vats

SELECT container_type, label, sys_connect_by_path( label || ' (' || container_type ||')' ,' | ') parentage
FROM container
WHERE ( container_type = 'cryovial')
START WITH container_type = 'cryovat'
CONNECT BY PRIOR container_id = parent_container_id
ORDER BY label
;
