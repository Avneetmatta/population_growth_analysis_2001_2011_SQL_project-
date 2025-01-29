create database Projects
use projects
select * from population_growth_states

-- Analysis

-- Show the top 5 highest population growth of states in 2001-2011
select top(5) 
   category, 
   india_state_union_territory,
   decadal_population_growth_rate_2001_2011 
from 
   population_growth_states 
where 
   category = 'state'
order by 
   decadal_population_growth_rate_2001_2011 desc  

/* From the above-code it clearly shows that Manipur has the higher population growth
as compared to the other top 5 states, this is because concentration of the majority population, 
the Meitei community, in the relatively small Imphal Valley, leading to high population density 
in that region, coupled with factors like high birth rates and limited access to family planning 
services within certain tribal communities inhabiting the hilly areas of the state*/

 
-- Show the top 5 lowest population growth of states in 2001-2011
select top(5)
   category, 
   india_state_union_territory,
   decadal_population_growth_rate_2001_2011 
from 
   population_growth_states 
where 
   category = 'state'
order by 
   decadal_population_growth_rate_2001_2011 asc

/* By seeing the above-code it showes us that the Nagaland has experienced a negative population 
in their state, its population actually decreased during that time, which is attributed to the state 
government rejecting the inflated population figures from the 2001 census, leading to a lower recorded 
population in the 2011 census; this decline happened without any major events like war, famine, or 
natural disasters impacting the state.  
*/

--  Show the top 10 highest population growth of union territoties in 2001-2011 and avg of there population density

select top 10
   category,
   india_state_union_territory,
   avg(population_density_per_sq_km_2011) as 'avg population density'
from 
   population_growth_states
where
   category = 'union territory'
group by 
   category,
   india_state_union_territory
order by
   avg(population_density_per_sq_km_2011)

/* From the above code this show the average of population density of top 5 union territory
in which Andaman has the lowest and Delhi has the highest population density
*/

-- Rank the population density of states and union territory and compare them

select 
   category,
   india_state_union_territory,
   population_density_per_sq_km_2011,
   rank() over(partition by category order by  population_density_per_sq_km_2011 desc ) as 'population Density rank'
from
   population_growth_states
where
  category in ('state' , 'union territory')
group by 
   category,
   india_state_union_territory,
   population_density_per_sq_km_2011


/* From the above code this show that the  highest population density of state is BIHAR 
 and the lowest population density of state is ARUNACHAL PRADESH and for the union territories
 highest population density of state is DELHI and the lowest population density of state is ANDAMAN AND NICOBAR ISLAND
*/

-- Which states and union territories have a population density above the national average in 2011?

select 
   category,
   india_state_union_territory,
   population_density_per_sq_km_2011
from
   population_growth_states
where 
   category in ('state', 'union territory') AND
   population_density_per_sq_km_2011 > (select avg(population_density_per_sq_km_2011) from population_growth_states)
order by 
   
   population_density_per_sq_km_2011

/*
This query identifies regions with a population density exceeding 
the national average, highlighting areas of high urbanization.
*/

-- How do specific states or union territories compare in terms of population growth between 2001 and 2011?

select 
   category,
   india_state_union_territory,
   round(decadal_population_growth_rate_2001_2011, 2) as decadal_population_growth_rate_2001_2011
from
   population_growth_states
where 
   india_state_union_territory IN ('Delhi', 'Bihar', 'Chandigarh', 'Uttar Pradesh')

order by 
   decadal_population_growth_rate_2001_2011 

/*
Delhi, Bihar, Chandigarh, and Uttar Pradesh were compared for their decadal growth, showcasing regional demographic trends.
*/

-- show top 8 outliers (states or UTs with exceptionally high or low population density)?

select top 10
  category,
  india_state_union_territory,
  population_density_per_sq_km_2011,
  PERCENTILE_CONT(0.95) within group (order by  population_density_per_sq_km_2011 ) OVER () AS top_5_percentile
from  
 population_growth_states
where 
  category in ('state','union territory')
order by 
   population_density_per_sq_km_2011

/*
dentifies states and UTs with exceptionally high or low population density,
helping to pinpoint extreme cases in demographic distribution.
*/
