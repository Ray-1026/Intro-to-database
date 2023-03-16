with "06_01"("Continent Name", "Country Name", "Date", "StringencyIndex_Average_ForDisplay") 
as(
	select continent.continent_name, country.country_name, indices."Date", indices."StringencyIndex_Average_ForDisplay"
	from continent left join country_to_continent left join country left join indices
	on country.three_letter_country_code=indices."CountryCode"
	on country_to_continent.three_letter_country_code=country.three_letter_country_code
	on continent.continent_code=country_to_continent.continent_code 
	where indices."Date"='2022/06/01' or indices."Date"='2021/06/01' or indices."Date"='2020/06/01'
)
select "06_01"."Continent Name", "06_01"."Country Name", "06_01"."Date", "06_01"."StringencyIndex_Average_ForDisplay" as "Highest Stringency Index"
from (
	select "Continent Name", "Date", max("StringencyIndex_Average_ForDisplay") as "StringencyIndex_Average_ForDisplay"
	from "06_01"
	group by "Continent Name", "Date"
) as "max_in_06_01" left join "06_01"
on "max_in_06_01"."Continent Name"="06_01"."Continent Name" 
and "max_in_06_01"."Date"="06_01"."Date"
and "max_in_06_01"."StringencyIndex_Average_ForDisplay"="06_01"."StringencyIndex_Average_ForDisplay"
order by "06_01"."Continent Name", "06_01"."Date" asc