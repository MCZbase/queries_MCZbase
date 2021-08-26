-- obtain a list of records where the coordinates contain alternative characters
-- instead of the degree sign (° &#176; U+00B0)
-- º -- masculine ordinal indicator
-- ˚ -- ring above

select collecting_event_id, verbatimcoordinates, verbatimlatitude, verbatimlongitude, verbatimcoordinatesystem,
mczbase.get_collcodes_for_collevent(collecting_event_id)
from collecting_event 
where verbatimcoordinates like '%˚%'
or verbatimcoordinates like '%º%'
or verbatimlatitude like '%˚%'
or verbatimlatitude like '%º%'
or verbatimlongitude like '%˚%'
or verbatimlongitude like '%º%';
