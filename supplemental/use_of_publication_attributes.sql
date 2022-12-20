--  find the distribution of publication attributes by publication type
select count(*), publication_attribute, publication_type
from publication_attributes
left join publication on publication_attributes.publication_id = publication.publication_id 
group by publication_attribute, publication_type
order by publication_type, count(*) desc
;
