with "continent_country_cases"("Continent Name", "Country Name", "Date","ConfirmedCases") as(
	select continent.continent_name, country.country_name, cases."Date", cases."ConfirmedCases"
	from continent join country_to_continent join country join cases
	on country.three_letter_country_code=cases."CountryCode"
	on country_to_continent.three_letter_country_code=country.three_letter_country_code
	on continent.continent_code=country_to_continent.continent_code
	where '2021/05/25'<=cases."Date" and cases."Date"<='2021/06/01'
), "7_day_average_2021"("Continent Name", "Country Name", "New Cases Average") as(
	select table1."Continent Name", table1."Country Name", avg(table1."ConfirmedCases"-table2."ConfirmedCases")
	from "continent_country_cases" as table1, "continent_country_cases" as table2
	where table1."Country Name"=table2."Country Name" and table1."Date"-1=table2."Date"
	group by table1."Continent Name", table1."Country Name"
), "count_index"("Continent Name", "Country Name", "over Stringency index") as(
	select "7_day_average_2021"."Continent Name", "7_day_average_2021"."Country Name",
		case "7_day_average_2021"."New Cases Average" 
		when 0 then "2021_06_01"."StringencyIndex_Average_ForDisplay"
		else "2021_06_01"."StringencyIndex_Average_ForDisplay" / "7_day_average_2021"."New Cases Average" end
	from (
		select continent.continent_name, country.country_name, indices."StringencyIndex_Average_ForDisplay"
		from continent join country_to_continent join country join indices
		on country.three_letter_country_code=indices."CountryCode"
		on country_to_continent.three_letter_country_code=country.three_letter_country_code
		on continent.continent_code=country_to_continent.continent_code 
		where indices."Date"='2021/06/01' and indices."StringencyIndex_Average_ForDisplay">0
	) as "2021_06_01" join "7_day_average_2021"
	on "2021_06_01".country_name="7_day_average_2021"."Country Name" and "2021_06_01".continent_name="7_day_average_2021"."Continent Name"
)

select continent_index."Continent Name", country_index."Country Name", continent_index.continent_max as "over Stringency index"
from (
	select "Continent Name", max("over Stringency index") as continent_max
	from "count_index"
	group by "count_index"."Continent Name"
) as continent_index join (
	select "Continent Name", "Country Name", max("over Stringency index") as country_max
	from "count_index"
	group by "count_index"."Continent Name", "count_index"."Country Name"
) as country_index
on continent_index."Continent Name"=country_index."Continent Name" and continent_index.continent_max=country_index.country_max
order by continent_index."Continent Name" asc