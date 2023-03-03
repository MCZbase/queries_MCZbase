select sys_connect_by_path( label || ' (' || container_type ||')' ,' | ') parentage,
guid, flat.scientific_name, flat.author_text, part_name
from container
left join coll_obj_cont_hist on container.container_id = coll_obj_cont_hist.container_id
left join specimen_part on coll_obj_cont_hist.collection_object_id = specimen_part.collection_object_id
left join flat on specimen_part.derived_from_cat_item = flat.collection_object_id
where container_type = 'collection object' and current_container_fg = 1
CONNECT BY PRIOR container.container_id = parent_container_id
start with label in ('VP_cabinet-1','VP_cabinet-2');
;
