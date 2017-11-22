--  List of distinct country names in the higher geography table that aren't in the country code authority file,
--  and aren't lists of countries separated by a slash (convention when current country is one of a set).
select distinct g.country 
    from geog_auth_rec g left join ctcountry_code c on g.country = c.country 
    where c.country is null and g.country not like '%/%';
