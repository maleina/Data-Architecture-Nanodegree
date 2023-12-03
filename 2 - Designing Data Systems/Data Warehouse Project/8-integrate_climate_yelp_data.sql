-- Join of the Yelp review table to the climate data
-- See also ANNEX-integrate_climate_yelp_data.png


-- Note: because I split the original review json datetime value
-- into two separate fields (one for the date, one for the time)
-- when I created the ODS review table, I do not need to do any
-- special manipulation here to join the tables on the respective
-- date field.
select *
from REVIEW as r
join PRECIPITATION as p
on r.review_date = p.precip_date
join TEMPERATURE as t
on r.review_date = t.temper_date;