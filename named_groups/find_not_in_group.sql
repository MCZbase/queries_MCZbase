-- Check for guids that you expect to be in a named group, but aren't.
-- takes a quoted, comma separated list of GUID values, and a string that
-- identifies the named group in the associated grant attribute (using 
-- CSBR as shorthand here.  
-- Returns non-matching values, with null for guid if the record does
-- not exist in flat, or a value in guid if the record is not in the
-- specified named group, records in the named group will not be shown.
select column_value, guid, attributes
from
   table(sys.odcivarchar2list('MCZ:Herp:A-100','MCZ:Herp:A-65901','MCZ:Herp:A-0000000'))
   left join flat on column_value = guid
where attributes is null or attributes not like '%CSBR%'
;
