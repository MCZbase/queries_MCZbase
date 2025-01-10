-- Current counts of distibution of cryogenic material by collection 
select decode(f.collection, 'Cryogenic', a.attribute_value,f.collection) as "Collection", 
    count(distinct f.collection_object_id) as "number_of_cataloged_items", 
    count(distinct co.collection_object_id) as "number_of_tissues_vials", 
    sum(co.lot_count) as "sum_of_part_counts"
from flat f, 
    specimen_part sp, coll_obj_cont_hist ch, coll_object co, 
    (select * from attributes a where attribute_type = 'Associated MCZ Collection') a, 
    CTSPECIMEN_PART_NAME pn,
    (select
                  container.container_id,
                  container.container_type,
                  container.label,
                  container.description,
                  p.barcode,
                  container.container_remarks
            from
                  container,
                  container p
            where
                  container.parent_container_id=p.container_id (+) and
                  container.container_type='collection object'
            start with
                  container.label like 'Cryovat%' or container.label = 'Cryo_refrigerator-1'
            connect by
                  container.parent_container_id = prior container.container_id) b
where b.container_id = ch.container_id
    and ch.collection_object_id = sp.collection_object_id
    and sp.DERIVED_FROM_CAT_ITEM = f.collection_object_id
    and sp.collection_object_id = co.collection_object_id
    and sp.part_name = pn.part_name
    and f.collection_cde = pn.collection_cde
    and pn.is_tissue = 1
    and f.collection_object_id = a.collection_object_id(+)
group by decode(f.collection, 'Cryogenic', a.attribute_value,f.collection)
order by decode(f.collection, 'Cryogenic', a.attribute_value,f.collection)
;
