-- Queries for representing coordinate uncertanties as spatial objects

-- Potential Malacology Eastern Seaboard localitiy points
-- with coordinateUncertaintyInMeters as a polygon.
select locality_id, dec_lat, dec_long,
SDO_UTIL.TO_WKTGEOMETRY(sdo_util.circle_polygon(dec_long, dec_lat, to_meters(max_error_distance, max_error_units), to_meters(max_error_distance, max_error_units)/50)) error_polygon
from lat_long 
where accepted_lat_long_fg = 1 
and locality_id in (
  select locality_id from flat where collection_cde = 'Mala'
)
and dec_lat >= 23.25 and dec_lat <= 45.5
and dec_long <= -65 and dec_long >=-98
and max_error_distance is not null
and max_error_distance > 0
and max_error_units is not null
and dec_long is not null and dec_lat is not null;

-- coordinates with uncertainty polygon for all localities with unknown soverign nation, a coordinate, and an uncertainty.
select locality.locality_id, higher_geog, spec_locality, dec_lat, dec_long,
SDO_UTIL.TO_WKTGEOMETRY(sdo_util.circle_polygon(dec_long, dec_lat, to_meters(max_error_distance, max_error_units), to_meters(max_error_distance, max_error_units)/50)) error_polygon
from lat_long 
left join locality on lat_long.locality_id = locality.locality_id
left join geog_auth_rec on locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id
where accepted_lat_long_fg = 1 
and locality.locality_id in (
  select locality_id from flat where sovereign_nation = '[unknown]'
)
and max_error_distance is not null
and max_error_distance > 0
and max_error_units is not null
and dec_long is not null and dec_lat is not null;

-- coordinates with uncertainty polygon for all localities with unknown soverign nation, a coordinate, but no uncertainty.
select locality.locality_id, higher_geog, spec_locality, dec_lat, dec_long,
to_clob('') as error_polygon
from lat_long 
left join locality on lat_long.locality_id = locality.locality_id
left join geog_auth_rec on locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id
where accepted_lat_long_fg = 1 
and locality.locality_id in (
  select locality_id from flat where sovereign_nation = '[unknown]'
)
and (max_error_distance is null or max_error_distance = 0 or max_error_units is null)
and dec_long is not null and dec_lat is not null;


-- UTM coordinate conversion for points in zone 18N
select dec_lat, dec_long, 
SDO_UTIL.TO_WKTGEOMETRY(sdo_geometry(2001, 8307, sdo_point_type(dec_long, dec_lat, NULL), NULL, NULL)),
SDO_UTIL.TO_WKTGEOMETRY(sdo_cs.transform(sdo_geometry(2001, 8307, sdo_point_type(dec_long, dec_lat, 0), NULL, NULL),32618))
from lat_long where dec_lat is not null
and dec_lat > 0 and dec_long < -72 and dec_long > -78;


