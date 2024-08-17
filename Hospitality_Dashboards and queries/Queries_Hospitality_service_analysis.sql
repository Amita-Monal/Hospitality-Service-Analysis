use hospitality_service_analysis;
show tables;
select * from fact_bookings;
select * from fact_aggregated_bookings;
select * from dim_date;

# Kpi_1 Total_Revenue
with temp as (select concat(format(sum(revenue_realized)/ 1000000, 2)," ", "M") as Total_Revenue from fact_bookings)
select Total_Revenue from temp;

# Kpi_2 Occupancy_Rate
with temp as (select concat(format(sum(successful_bookings) / sum(capacity) * 100,0), " ", "%") as Occupancy_Rate from fact_aggregated_bookings)
select Occupancy_Rate from temp;

# Kpi_3 Cancellation_Rate
# IF(condition, value_if_true, value_if_false)
with temp as (select concat(format(sum(if(booking_status= "Cancelled",1,0)) / count(booking_id) * 100, 2), " ", "%") as Total_Cancelled_Bookings from fact_bookings)
select Total_Cancelled_Bookings from temp;

# Kpi_4 Total_Booking
select concat(format(count(booking_id)/1000, 2), " ", "K") as Total_Booking from fact_bookings;

# Kpi_5 Utilize_Capacity
select concat(format(sum(if(booking_status= "Checked Out",1,0))/1000, 2), " ", "K") as Utilized_Capacity from fact_bookings;

# Kpi_6 Monthly_Trend
select check_in_date from fact_bookings;
alter table fact_bookings add column date_column DATE;
set sql_safe_updates =0;
update  fact_bookings set date_column = STR_TO_DATE(check_in_date, '%d-%m-%Y');
select date_column from fact_bookings;

select MONTHNAME(date_column) as month_name, concat(format(sum(revenue_realized) / 1000000, 2), " ", "M") as Total_Revenue
from fact_bookings group by month_name;


# Kpi_7 Weekday and Weekend Booking_status(Revenue) 
select date from dim_date;
alter table dim_date add column converted_date DATE;
update dim_date set converted_date = STR_TO_DATE(date, '%d-%b-%y');
select converted_date from dim_date;

with temp as (
	select 
		dd.day_type as Day_Type, 
		concat(format(COUNT(fb.booking_id)/1000, 2), " ", "K") as Total_Booking,
		concat(format(SUM(fb.revenue_realized)/1000000, 2), " ", "M") as Total_Revenue 
	from 
		fact_bookings fb 
	right join 
		dim_date dd 
	on 
		fb.date_column = dd.converted_date 
	group by 
		dd.day_type 
	order by 
		dd.day_type
)
select 
	Day_type,
	Total_booking,
	Total_Revenue 
from 
	temp;


# Kpi_8 Revenue by City & Hotel 
with temp as (
	select 
		dh.city as City,
		dh.property_name as Property_name,
		concat(format(sum(fb.revenue_realized)/1000000, 2), " ", "M") as Total_Revenue 
	from 
		fact_bookings fb 
	right join 
		dim_hotels dh 
	on 
		fb.property_id = dh.property_id 
	group by 
		dh.city, dh.property_name 
	order by 
		dh.city
)
select
	City,
    Property_name,
    Total_Revenue 
from 
	temp;


# Kpi_9 Class_wise Revenue
with temp as (
	select 
		dr.room_class as Room_class,
        concat(format(sum(fb.revenue_realized)/1000000, 2), " ", "M") as Total_Revenue
	from
		fact_bookings fb
	right join
		dim_rooms dr
	on
		fb.room_category = dr.room_id
	group by
		dr.room_class
	order by
		dr.room_class
)
select
	Room_class,
    Total_Revenue
from
	temp;


# Kpi_10 Booking_Count(Checked_out, Cancelled, No_Show)
with temp as (
	select 
		sum(if(booking_status= "Checked Out",1,0)) as Total_Successful_Bookings,
        sum(if(booking_status= "Cancelled",1,0)) as Total_Cancelled_Bookings,
        sum(if(booking_status= "No Show",1,0)) as Total_No_Show
	from 
		fact_bookings
)
select
	Total_Successful_Bookings,
	Total_Cancelled_Bookings,
    Total_No_Show
from 
	temp;	
		

# Kpi_11 Weekly trend Key trend (Revenue, Total booking, Occupancy)
with temp as (
	select
		dd.`week no` as Weeks,
        concat(format(sum(fb.revenue_realized)/1000000,2), " ", "M") as Revenue,
        concat(format(count(fb.booking_id)/1000,2), " ", "K") as Total_Booking,
        concat(format(sum(if(booking_status="Checked Out",1,0)) / 1000, 2), " ", "K") as Occupancy
	from
		fact_bookings fb
	right join
		dim_date dd
	on
		fb.date_column = dd.converted_date
	group by
		dd.`week no`
	order by
		dd.`week no`
)
select
	Weeks,
    Revenue, 
    Total_Booking,
    Occupancy
from
	temp;


# Kpi_12 has been achieved through three different ways
# Kpi_12 No_of_booking by Booking_Platform
select booking_platform, concat(format(count(booking_id)/1000, 2)," ", "K") as No_of_booking from fact_bookings group by booking_platform 
order by count(booking_id) desc;


# Kpi_12 has achieved the same result by using Subquery
select 
	booking_platform,
    concat(format(booking_count / 1000, 2), " ", "K") as No_of_booking
from (
	select
		booking_platform,
        count(booking_id) as booking_count
	from fact_bookings 
	group by booking_platform
) as Subquery 
order by booking_count desc;


# Kpi_12 has achieved the same result by using CTE (Common Table Expression)
with temp as (
	select
		booking_platform,
        count(booking_id) as booking_count
	from
		fact_bookings
	group by
		booking_platform
)
select
	booking_platform,
    concat(format(booking_count/1000, 2), " ", "K") as No_of_booking
from
	temp
order by
	booking_count
desc;
	




	
	
        
        
		
        