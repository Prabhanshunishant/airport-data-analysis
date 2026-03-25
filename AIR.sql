use datairport;
select * FROM airport;

--Analyze total passenger traffic per route and over time. 

--MOST BUSIEST ROUTES

select ORIGIN_CITY_NAME, DEST_CITY_NAME, sum(PASSENGERS) as total_passengers
from airport
group by 1,2
order by total_passengers desc
limit 5

--LEAST BUSISTE ROUTES

select ORIGIN_CITY_NAME, DEST_CITY_NAME, sum(PASSENGERS) as total_passengers
from airport
where ORIGIN_CITY_NAME <> DEST_CITY_NAME
group by 1,2
having sum(PASSENGERS) > 0
order by total_passengers
limit 5 

--2. Determine average passengers per flight for various routes and airports.


--FOR ROUTES


select ORIGIN_CITY_NAME, DEST_CITY_NAME, avg(PASSENGERS) as avg_passengers
from airport
group by 1,2
order by avg_passengers desc  

--FOR AIRPORTS


with outgoing_passengers as 
(select ORIGIN_AIRPORT_ID, avg(PASSENGERS) as avg_passengers
from airport
group by 1
order by avg_passengers desc),

incoming_passengers as 
(select DEST_AIRPORT_ID, avg(PASSENGERS) as avg_passengers
from airport
group by 1
order by avg_passengers desc),

all_airports as 
(select distinct ORIGIN_AIRPORT_ID as airport_id from airport
union
select distinct DEST_AIRPORT_ID  as airport_id from airport
)

select aa.airport_id, op.avg_passengers + ip.avg_passengers as total_passenger_travelling
from all_airports as aa
left join outgoing_passengers as op on aa.airport_id = op.ORIGIN_AIRPORT_ID
left join incoming_passengers as ip on aa.airport_id = ip.DEST_AIRPORT_ID
where op.avg_passengers + ip.avg_passengers is not null 
order by total_passenger_travelling desc

--4. Compare passenger numbers across origin cities to identify top-performing airports.

select  ORIGIN_CITY_NAME, ORIGIN_AIRPORT_ID, sum(PASSENGERS) as total_passengers
from airport
group by 1,2
order by sum(PASSENGERS) DESC
LIMIT 5

--3. Assess flight frequency and identify high-traffic corridors.

SELECT ORIGIN_CITY_NAME, DEST_CITY_NAME, COUNT(AIRLINE_ID) AS TOTAL_FLIGHTS 
FROM airport
group by 1,2
order by TOTAL_FLIGHTS desc
limit 10 

--5. Evaluate available seat capacity to understand seat utilization 


with seating_capacity as 
(select AIRLINE_ID, MAX(PASSENGERS) as seat_capacity
FROM airport
group by 1 
having MAX(PASSENGERS) > 0),

seat_utilization as 
(select a.AIRLINE_ID, a.PASSENGERS*100.00 / sc.seat_capacity as seat_utilization
from airport a join seating_capacity sc on a.AIRLINE_ID = sc.AIRLINE_ID
ORDER BY seat_utilization desc)

select AIRLINE_ID, avg(seat_utilization) as avg_seat_utilization 
from seat_utilization
group by 1
order by avg_seat_utilization desc 

--6. Identify popular destination airports based on inbound passenger counts.

select * from usa_city_population 

SELECT * FROM airport

select DEST_CITY_NAME , ORIGIN_AIRPORT_ID, SUM(PASSENGERS) AS TOTAL_PASSENGERS
FROM airport
group by 1,2
ORDER BY TOTAL_PASSENGERS DESC 
LIMIT 5

--7. Examine the relationship between city population and airport passenger traffic.





