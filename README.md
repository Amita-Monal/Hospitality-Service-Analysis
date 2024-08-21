# Hospitality Service Analysis

## Table of contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning/Preparation](#data-cleaningpreparation)
- [Data Analysis](#data-analysis)
- [Findings](#findings)
- [Recommendations](#recommendations)
- [Power BI Dashboard](#power-bi-dashboard)
- [Excel Dashboard](#excel-dashboard)
- [Tabeau Dashboard](#tableau-dashboard)

### Project Overview

The Hospitality Service Project is designed to provide a comprehensive analysis of the hospitality industry, focusing on key aspects such as hotel bookings, room occupancy and revenue management. The project integrates various datasets to create a robust dashboard and key performance indicators (KPIs) that offer valuable insights into the operations of hotels across different regions.

### Data Sources

- dim_date: Contains date-related information including day types (weekend/weekday) and month names, crucial for time-based analysis.
- fact_aggregated_bookings: Aggregated booking data including details such as property ID, room category, successful bookings, and capacity.
- dim_hotels: Details about various hotels, including their property ID, name, category, and city.
- dim_rooms: Information about different room categories, such as Standard, Elite, Premium, and Presidential.
- fact_bookings: Comprehensive booking records including booking ID, property ID, booking and check-in dates, guest count, booking platform, ratings, booking status, revenue generated, and cancellations.

### Tools
- Excel - Data Cleaning [Download Here](https://microsoft.com)
- MySQL Workbench - Data Analysis [Download Here](https://dev.mysql.com/downloads/workbench/)
- Power BI - Creating reports [Download Here](https://www.microsoft.com/en-us/download/details.aspx?id=58494)


### Data Cleaning/Preparation
In the initial data preparation phase, we performed the following tasks:
1. Data loading and inspection.
2. Handling missing values.
3. Data cleaning and formatting.

### Data Analysis
Here are some sql queries which i have used during data analysis:

```sql
# Total_Revenue
with temp as (
 select
  concat(format(sum(revenue_realized)/ 1000000, 2)," ", "M") as Total_Revenue
 from
  fact_bookings
)
select
 Total_Revenue
from
 temp;


# Occupancy_Rate
with temp as (select concat(format(sum(successful_bookings) / sum(capacity) * 100,0), " ", "%") as Occupancy_Rate from fact_aggregated_bookings)
select Occupancy_Rate from temp;


# Cancellation_Rate
with temp as (select concat(format(sum(if(booking_status= "Cancelled",1,0)) / count(booking_id) * 100, 2), " ", "%") as Total_Cancelled_Bookings from fact_bookings)
select Total_Cancelled_Bookings from temp;


# Total_Booking
select concat(format(count(booking_id)/1000, 2), " ", "K") as Total_Booking from fact_bookings;


# Utilize_Capacity
select concat(format(sum(if(booking_status= "Checked Out",1,0))/1000, 2), " ", "K") as Utilized_Capacity from fact_bookings;


# Booking_Count(Checked_out, Cancelled, No_Show)
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


# Weekly trend Key trend (Revenue, Total booking, Occupancy)
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
```


### Findings

The analysis results are summarised as follows:
- Revenue Impact: Cancellations and no-shows significantly reduce potential revenue.
- Occupancy Variability: Room occupancy rates fluctuate, indicating uneven demand.
- Customer Preferences: Elite rooms and direct online bookings are most popular.
- Seasonal Patterns: Higher bookings during weekdays and specific months.
- City and Category Performance: Certain cities and hotel categories generate more bookings and revenue.


### Recommendations

Based on the analysis, we recommend the following actions:
- Reduce Cancellations: Implement flexible booking policies or incentives to reduce cancellations and no-shows.
- Optimize Occupancy: Adjust pricing or offer promotions during low-demand periods to increase room occupancy.
- Targeted Marketing: Focus marketing efforts on popular room categories and booking channels.
- Seasonal Campaigns: Develop promotional campaigns aligned with peak booking seasons, especially for weekdays.
- Expand in High-Performing Areas: Consider expanding services or offering premium options in cities and categories with strong performance.


### Here are screenshots of the dashboards I created during my analysis:

### Power BI Dashboard 

- Dashboard-1
![Hospitality_pbix_dashboard](https://github.com/user-attachments/assets/692f799a-a51d-4b23-8510-7157a67b78cc)


- Dashboard-2
![Hospitality2_dashboard_pbix](https://github.com/user-attachments/assets/5033f0a5-fa2b-48d1-9999-0932493d896c)


### Excel Dashboard

![Excel_hospitality_dashboard](https://github.com/user-attachments/assets/efbd65b0-b4e4-46dc-a66f-938bda1dca64)


### Tableau Dashboard

- Dashboard-1
![Tableau_hospitality_dashboard](https://github.com/user-attachments/assets/1e3015e4-4061-4be2-bf69-d8efd04fb7e0)


- Dashboard-2
![Tableau2_hospitality_dashboard](https://github.com/user-attachments/assets/58caa790-a4ca-4d5d-8390-5a6a1483be97)

  
