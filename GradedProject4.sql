-- Create database for the travel company TavelOnTheGo 
drop database if exists travelonthego_dbms;
create database travelonthego_dbms;
use travelonthego_dbms;


/*

	Create the tables 'Passengers', 'Prices', 'Routes'
    
    
	In Prices table, 'isSleeper' is using TINYINT type. 
    If it is '1', then it is sleeper type. If it is '0' then it is sitting type. 
    
    In Passengers table, 'isAC' is using TINYINT type. 
	If it is '1', then it is AC category. If it is '0' then it is Non-AC category. 
    
    
*/
    
    
drop table if exists routes;
create table routes(
	routeID int primary key auto_increment,
    Boarding varchar(20),
    Destination varchar(20)
    );
    

drop table if exists prices;
create table prices(
	ID int primary key auto_increment,
    isSleeper tinyint,
    Distance int,
    Price int    
);


drop table if exists passengers;
create table passengers(
	PassengerId int primary key auto_increment,
	Name varchar(20),
    Gender varchar(1),
    isAC tinyint,
    routeID int,
    ID int,
    foreign key(ID) references prices(ID),
    foreign key(routeID) references routes(routeID)
);


/* Inserting the given cities data into the routes table*/
insert into routes(Boarding, Destination) values ('Bengaluru', 'Chennai');
insert into routes(Boarding, Destination) values ('Mumbai', 'Hyderabad');
insert into routes(Boarding, Destination) values ('Panaji', 'Bengaluru');
insert into routes(Boarding, Destination) values ('Chennai', 'Mumbai');
insert into routes(Boarding, Destination) values ('Trivandrum', 'Panaji');
insert into routes(Boarding, Destination) values ('Nagpur', 'Hyderabad');
insert into routes(Boarding, Destination) values ('Panaji', 'Mumbai');
insert into routes(Boarding, Destination) values ('Hyderabad', 'Bengaluru');
insert into routes(Boarding, Destination) values ('Pune', 'Nagpur');
 

/* Inserting the given prices data into the prices table*/
insert into prices(isSleeper, Distance, Price) values (1, 350, 770);
insert into prices(isSleeper, Distance, Price) values (1, 500, 1100);
insert into prices(isSleeper, Distance, Price) values (1, 600, 1320);
insert into prices(isSleeper, Distance, Price) values (1, 700, 1540);
insert into prices(isSleeper, Distance, Price) values (1, 1000, 2200);
insert into prices(isSleeper, Distance, Price) values (1, 1200, 2640);
insert into prices(isSleeper, Distance, Price) values (1, 1500, 2700);
insert into prices(isSleeper, Distance, Price) values (0, 500, 620);
insert into prices(isSleeper, Distance, Price) values (0, 600, 744);
insert into prices(isSleeper, Distance, Price) values (0, 700, 868);
insert into prices(isSleeper, Distance, Price) values (0, 1000, 1240);
insert into prices(isSleeper, Distance, Price) values (0, 1200, 1488);
insert into prices(isSleeper, Distance, Price) values (0, 1500, 1860);



/* Inserting the given passengers data into the passengers table*/
insert into passengers(Name, Gender, isAC, routeID, ID) 
	values ('Sejal','F',1, 1, 1);
insert into passengers(Name, Gender, isAC, routeID, ID) 
	values ('Anmol','M',1, 2, 10);
insert into passengers(Name, Gender, isAC, routeID, ID) 
	values ('Pallavi','F',1, 3, 3);
insert into passengers(Name, Gender, isAC, routeID, ID) 
	values ('Khusboo','F',1, 4, 7);
insert into passengers(Name, Gender, isAC, routeID, ID) 
	values ('Udit','M',1, 5, 5);
insert into passengers(Name, Gender, isAC, routeID, ID) 
	values ('Ankur','M',1, 6, 8);
insert into passengers(Name, Gender, isAC, routeID, ID) 
	values ('Hemant','M',1, 7, 4);
insert into passengers(Name, Gender, isAC, routeID, ID) 
	values ('Manish','M',1, 8, 8);
insert into passengers(Name, Gender, isAC, routeID, ID) 
	values ('Piyush','M',1, 9, 10);
    
    
    
    
    
    
-- Q3) How many females and how many male passengers travelled for a minimum distance of 600 KMs?

select gender as Gender, count(gender) as 'Number of Passengers'
	from passengers as pa
    join prices as pr
		on pa.ID = pr.ID
	where distance >=600
    group by gender;
    
    


-- Q4) Find the minimum ticket price for Sleeper Bus
select min(price) as 'Min Price (sleeper)'
	from prices
    where isSleeper = 1;
    
    
    
-- Q5) Select passenger names whose names start with character 'S' 
select Name from passengers where name like 's%'; 


-- Q6) Calculate price charged for each passenger displaying Passenger name, Boarding City, Destination City, Bus_Type, Price in the output
select Name, Boarding, Destination, if(isSleeper, 'Sleeper', 'Sitting') as 'Bus Type', Price
	from passengers as pa
    join routes as r
		on pa.routeID = r.routeID
	join prices as pr
		on pr.ID = pa.ID;
        

-- Q7) What are the passenger name/s and his/her ticket price who travelled in the Sitting bus for a distance of 1000 KMs
    select Name, Price 
		from passengers as pa
        join prices as pr
			on pr.ID = pa.ID
		where pr.Distance = 1000 and isSleeper = 0;
        
-- Q8) What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to Panaji?
select Price, if(isSleeper, 'Sleeper', 'Sitting') as 'Bus-Type' 
from Prices 
where distance = (select distance 
	from passengers as pa 
	join prices as pr 
    on pa.ID = pr.ID
	where name = 'pallavi')
    order by Price;
    
    
    
-- Q9)   List the distances from the "Passenger" table which are unique (non-repeated distances) in descending order

select distinct(distance) from prices order by distance desc;


/* Q10)  Display the passenger name and percentage of distance travelled by that passenger 
         from the total distance travelled by all passengers without using user variables */
         
         
select Name, Distance, Distance*100/ t.Sum as '% of Total Distance Travelled'
	from passengers as pa
    join prices as pr
		on pa.ID = pr.ID
    cross join (
		select sum(Distance) as Sum from prices
    ) as t;
         

        
        
/*
	Display the distance, price in three categories in table Price
		a) Expensive if the cost is more than 1000
		b) Average Cost if the cost is less than 1000 and greater than 500
		c) Cheap otherwise
*/

select Distance, Price,
	case 	
    when Price >= 1000 then 'Expensive' 
    when Price > 500 then 'Average Cost'
    when Price <= 500 then 'Cheap'
    
    End as Category
  
from prices ;



 