-- 	SQL generated report that includes business name, temperature, precipitation, and ratings.
-- See also ANNEX-dwh_queries.png

-- Given that there are actually no reviews listed for businesses in the city of Las Vegas, 
-- and because our climate data is for Las Vegas,
-- I question the validity of our query to look for a relationship between weather data and reviews.

select b.name as business_name, c.temper_max as temperature, c.precip_amt as precipitation, r.stars as rating
from fact_review as r
join dim_business as b
on r.business_id = b.business_id
join dim_climate as c
on r.clim_date = c.clim_date;