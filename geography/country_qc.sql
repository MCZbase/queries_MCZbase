--  List of distinct country names in the higher geography table that aren't in the country code authority file,
--  and aren't lists of countries separated by a slash (convention when current country is one of a set).
select distinct g.country 
    from geog_auth_rec g left join ctcountry_code c on g.country = c.country 
    where c.country is null and g.country not like '%/%';

--  List of country/continent combinations where a country occurs in more than one continent
select distinct country, continent_ocean from geog_auth_rec where country in (
select country from geog_auth_rec 
    where country is not null and continent_ocean not like '%Ocean%'
    group by country 
    having count(distinct continent_ocean) > 1
)
and continent_ocean not like '%Ocean%'
order by country
;