--set search_path to "Bike857B";

--drop table if exists a_customer, a_bike, a_bike_parts, a_bike_repair, a_new_model, a_suppliers cascade;


--Vikas - reception "C21710971"

--Kacper - mechanic "C21471486"

--Euan - customer "C21493446"

/*
   _____           _     __  __             _____                 _       
 |  __ \         | |   /_ |/_ |           / ____|               | |      
 | |__) |_ _ _ __| |_   | | | |  ______  | |  __ _ __ __ _ _ __ | |_ ___ 
 |  ___/ _` | '__| __|  | | | | |______| | | |_ | '__/ _` | '_ \| __/ __|
 | |  | (_| | |  | |_   | |_| |          | |__| | | | (_| | | | | |_\__ \
 |_|   \__,_|_|   \__|  |_(_)_|           \_____|_|  \__,_|_| |_|\__|___/
                                                                                                                                              
 */


--usage grants

/*
grant usage on schema "Bike857B" to "C21493446";
grant usage on schema "Bike857B" to "C21471486";
grant usage on schema "Bike857B" to "C21710971";

--sequences
grant usage, select on sequence a_bike_repair_repair_id_seq to "C21471486"; --mechanic insert
grant usage, select on sequence a_bike_parts_part_id_seq to "C21710971"; --bike parts insert reception
grant usage, select on sequence a_customer_cust_id_seq to "C21710971"; --customer insert reception


--this was used to find the sequence name for the table a_bike_repair and a_bike_parts since this is where the mechanic wil insert values
select column_name, column_default
from information_schema.columns
where table_name = 'a_bike_repair' and column_name = 'repair_id';

select column_name, column_default
from information_schema.columns
where table_name = 'a_bike_parts' and column_name = 'part_id';

select column_name, column_default
from information_schema.columns
where table_name = 'a_customer' and column_name = 'cust_id';


--permissions mechanic to see repairs
grant select on table a_bike_repair to "C21471486";
grant update on table a_bike_repair to "C21471486";

--so mechanic could see the status of the bike and tell receptionist to change it
grant select on table a_bike to "C21471486";
grant update on table a_bike to "C21710971";

--mechanic needs to see new bike models
grant select on table a_new_model to "C21471486";

--reception and mechanic needs to see the available parts and update if used
grant select on table a_bike_parts to "C21471486";
grant select on table a_bike_parts to "C21710971";
grant update on table a_bike_parts to "C21710971";

--reception needs to order parts or update if they are used 
grant insert on table a_bike_parts to "C21710971";
grant select on table a_bike_parts to "C21710971";
grant update on table a_bike_parts to "C21710971";

--reception needs to add customers and change them
grant all on table a_customer to "C21710971";

--reception needs to sees the suppliers and edit them
grant all on table a_suppliers to "C21710971";

--reception acts as goods in and oversees new models
grant all on table a_new_model to "C21710971";

--small permissions for the customer to track the bike progress
grant select on table a_customer to "C21493446";

--in case customer wants to add his repair via online then he inserts into this table
grant insert on table a_customer to "C21493446";

--extra permissions in case customer wants to see new upcoming bikes and their manufacturers, might want to buy it
grant select on table a_new_model to "C21493446";
grant select on table a_suppliers to "C21493446";

*/

--in summary mechanic has a lot of permissions regarding managing bike repairs and part, but has no delete permissions

--customer has only view permissions just to see new products or to track own bike's progress

--receptionist acts as a goods in when new parts or models come in, deals with customers



/*
  _____           _     __            _______    _     _           
 |  __ \         | |   /_ |          |__   __|  | |   | |          
 | |__) |_ _ _ __| |_   | |  ______     | | __ _| |__ | | ___  ___ 
 |  ___/ _` | '__| __|  | | |______|    | |/ _` | '_ \| |/ _ \/ __|
 | |  | (_| | |  | |_   | |             | | (_| | |_) | |  __/\__ \
 |_|   \__,_|_|   \__|  |_|             |_|\__,_|_.__/|_|\___||___/
                                                                                                           
  */                         
                           


--table for customers
create table a_customer(
    cust_id serial primary key,
    cust_name varchar(50) not null,
    cust_email varchar(50) null,
    cust_phone_num varchar(20) not null,
    constraint unique_cust_info unique (cust_name, cust_phone_num) --this ensures that
    --2 customers will not have same number and vice versa
);

--table for bikes which references customers
create table a_bike(
    bike_id serial primary key,
    bike_model varchar(30),
    bike_status char(1) not null,
    --ensures that these are the only values allowed
    cust_id int references a_customer(cust_id)
);

--table that will be used my the mechanic to track repairs
create table a_bike_repair(
    repair_id serial primary key,
    bike_id int references a_bike(bike_id),
	bike_repair_required varchar(255) not null,
	replaced_parts varchar(255) null,
	bike_work_hours varchar(20) null
);

--not really needed but can stay
create table a_suppliers (
    supplier_id serial primary key,
    supplier_name varchar(255) null
);

--main table that has all parts
create table a_bike_parts (
    part_id serial primary key,
    part_name varchar(255) not null, 
    repair_id int references a_bike_repair(repair_id),
    --this line of code is for this "Parts can sometimes contain other parts
    --for example, the wheel will contain spokes, but a spoke can be provided separately."
    contains_part_id int references a_bike_parts(part_id)
);

--table which tracks new bike models
create table a_new_model (
    model_id serial primary key,
    model_name varchar(30) not null,
    bike_id int references a_bike(bike_id),
    supplier_id int references a_suppliers(supplier_id)
);


--randomly generated customers
insert into a_customer (cust_name, cust_email, cust_phone_num) values
  ('Susan Lee', 'SusLee@gmail.com', '+353861234567'),
  ('David Smith', 'DaSmith@hotmail.ie', '0869876543'),
  ('Linda Johnson', 'Linda321@gmail.com', '+353875557890'),
  ('James Brown', 'Brownie@yahoo.com', '0853217890'),
  ('Emily Wilson','theEmily@gmail.com', '+353864441122'),
  ('Michael Anderson', 'MilkJak@gmai.com' ,'0875558888'),
  ('Sophia Martin', null, '+353851113333'),
  ('Joseph Thompson', 'jos@tudublin.ie','0869994444'),
  ('Olivia White', 'cheeseifyouread@cheese.com', '+353872225555'),
  ('William Jones', 'Willy@gmail.com,', '0851234567'),
  ('John Doe', 'TheDoe@yahoo.com', '0857772222'),
  ('Mary Wilson', 'TheWilMary@gmail.com' , '+353868881111'),
  ('Robert Jones', 'ImRob@hotmail.com' ,'0854443333'),
  ('Laura Davis', 'Bipolar@gmail.com' ,'+353873335555'),
  ('William Smith', 'DadaSmuth@yahoo.com','0852229999'),
  ('Elizabeth Taylor', 'nametoolong@gmail.com', '+353869994444'),
  ('Daniel Clark', 'Clarkson@gmail.com','0875553333'),
  ('Sarah Anderson', 'Sar1234556788@hotmail.com', '+353854442222'),
  ('James Thompson', null, '0856667777'),
  ('Olivia Harris', null, '+353871118888');

--randomly generated bikes and their status
insert into a_bike (bike_model, bike_status, cust_id) values
  ('Mountain Bike', 'R', 5),
  ('City Bike', 'C', 6),
  ('Hybrid Bike', 'R', 7),
  ('Road Bike', 'F', 8),
  ('Electric Bike', 'C', 9),
  ('BMX Bike', 'R', 10),
  ('Cruiser Bike', 'C', 1),
  ('Mountain Bike', 'F', 5),
  ('City Bike', 'R', 6),
  ('Hybrid Bike', 'C', 7),
  ('Mountain Bike', 'C', 11),
  ('City Bike', 'R', 12),
  ('Hybrid Bike', 'C', 13),
  ('Road Bike', 'F', 14),
  ('Electric Bike', 'C', 15),
  ('BMX Bike', 'R', 16),
  ('Cruiser Bike', 'F', 17),
  ('Mountain Bike', 'C', 18),
  ('City Bike', 'R', 19),
  ('Hybrid Bike', 'C', 20);

--randomly generated values
insert into a_bike_repair (bike_id, bike_repair_required, replaced_parts, bike_work_hours) values
  (5, 'Adjust Brakes', 'Brake Pads', null),
  (6, 'Tire Replacement', 'Tires', null),
  (7, 'Chain Lubrication', 'Chain', null),
  (8, 'Gear Adjustment', 'Gears', '1.5 hours'),
  (9, 'Battery Replacement', 'Battery', '3.0 hours'),
  (10, 'Frame Welding', 'Welding Materials', null),
  (11, 'Adjust Brakes', 'Brake Pads', '2.0 hours'),
  (12, 'Tire Replacement', 'Tires', null),
  (13, 'Chain Lubrication', 'Chain', '0.8 hours'),
  (14, 'Gear Adjustment', 'Gears', null),
  (15, 'Battery Replacement', 'Battery', '3.0 hours'),
  (16, 'Frame Welding', 'Welding Materials', null),
  (17, 'Adjust Brakes', 'Brake Pads', '2.0 hours'),
  (18, 'Tire Replacement', 'Tires', '1.2 hours'),
  (19, 'Chain Lubrication', 'Chain', null),
  (20, 'Gear Adjustment', 'Gears', '1.5 hours');


--randomly generated suppliers
insert into a_suppliers (supplier_name) values
  ('ABC Suppliers'),
  ('XYZ Distributors'),
  ('Superior Parts Co.'),
  ('Global Wheels Inc.'),
  ('Quality Bike Parts'),
  ('Best Cycle Supplies'),
  ('Elite Bike Components'),
  ('Fast Track Bikes'),
  ('TechCycle Solutions'),
  ('BikeMaster Enterprises');


--randomly generated bike parts
insert into a_bike_parts (part_name, repair_id, contains_part_id) values
  ('Wheel', 1, null),
  ('Handlebar', 2, null),
  ('Brake Caliper', 3, null),
  ('Saddle', 4, null),
  ('Chain', 5, null),
  ('Gears', 6, null),
  ('Frame', 7, null),
  ('Pedals', 8, null),
  ('Spokes', 9, 1),
  ('Lights', 10, null);

--randomly generated new models
insert into a_new_model (model_name, supplier_id, bike_id) values
  ('BMX Bike', 4, 10),
  ('Electric Bike', 5, 9),
  ('Road Bike', 6, 8),
  ('Cruiser Bike', 7, 1),
  ('Hybrid Bike', 3, 7),
  ('City Bike', 2, 6),
  ('Mountain Bike', 1, 5);


/*
  _____           _     ___             _____                        _                    ___                     
 |  __ \         | |   |__ \           |  __ \                      | |                  / / |                    
 | |__) |_ _ _ __| |_     ) |  ______  | |__) | __ ___   ___ ___  __| |_   _ _ __ ___   / /| |     ___   __ _ ___ 
 |  ___/ _` | '__| __|   / /  |______| |  ___/ '__/ _ \ / __/ _ \/ _` | | | | '__/ _ \ / / | |    / _ \ / _` / __|
 | |  | (_| | |  | |_   / /_           | |   | | | (_) | (_|  __/ (_| | |_| | | |  __// /  | |___| (_) | (_| \__ \
 |_|   \__,_|_|   \__| |____|          |_|   |_|  \___/ \___\___|\__,_|\__,_|_|  \___/_/   |______\___/ \__, |___/
                                                                                                         __/ |                                                                                                           |___/     
 */

-- Create a table to log bike status changes
 
--drop table bike_status_log; 

create table bike_status_log (
    log_id serial primary key,
    bike_id int references a_bike(bike_id),
    old_status char(1) not null,
    new_status char(1) not null,
    change_date timestamp
);


--this procedure allows me, the receptionist to quickly change the status of a bike when a mechanic tells me it is done while logging it

--drop procedure update_bike_status;

--procedure for updating the status
create or replace procedure update_bike_status(
    in bike_id_to_change int,
    in new_status char(1)
    --in; inputs for the function
)as
$$
declare
	--declare local var
    old_status char(1);
begin
	--get current status into new var
	select bike_status into old_status
    from a_bike
    where bike_id = bike_id_to_change;
	
   	--check if they are not the same, if yes, allow the update
	if new_status <> old_status then
		update a_bike
    	set bike_status = new_status
    	where bike_id = bike_id_to_change;

    	--for logging purposes
		insert into bike_status_log (bike_id, old_status, new_status, change_date)
		values (bike_id_to_change, (select bike_status from a_bike where bike_id = bike_id_to_change), new_status, now());
	else
		--else raise an exception
        raise exception 'Status is unchanged.';
    end if;
exception
	when others then
        raise info 'Error Name:%', sqlerrm;

end;
$$ language plpgsql





/*
  _____           _     ____             _______   _                       
 |  __ \         | |   |___ \           |__   __| (_)                      
 | |__) |_ _ _ __| |_    __) |  ______     | |_ __ _  __ _  __ _  ___ _ __ 
 |  ___/ _` | '__| __|  |__ <  |______|    | | '__| |/ _` |/ _` |/ _ \ '__|
 | |  | (_| | |  | |_   ___) |             | | |  | | (_| | (_| |  __/ |   
 |_|   \__,_|_|   \__| |____/              |_|_|  |_|\__, |\__, |\___|_|   
                                                      __/ | __/ |          
                                                     |___/ |___/           
 */


--could be avoided with simple line in table creation: bike_status char(1) not null check (bike_status in ('R', 'C', 'F')),
--but for the assignment purposes, here's the trigger
create or replace function bike_status_trigger()
returns trigger as --return trigger type
$$
begin
    if new.bike_status not in ('R', 'C', 'F') then
        raise exception 'Invalid bike status';
    end if;
    return new; --if no issue with bike_status, allow the insert to continue
end;
$$ language plpgsql;

--trigger than uses the trigger functions
create trigger enforce_bike_status
before insert or update
on a_bike
for each row
execute function bike_status_trigger();



/*
  _____           _     _  _              _____                     _           _________        _       
 |  __ \         | |   | || |            |_   _|                   | |         / /__   __|      | |      
 | |__) |_ _ _ __| |_  | || |_   ______    | |  _ __  ___  ___ _ __| |_ ___   / /   | | ___  ___| |_ ___ 
 |  ___/ _` | '__| __| |__   _| |______|   | | | '_ \/ __|/ _ \ '__| __/ __| / /    | |/ _ \/ __| __/ __|
 | |  | (_| | |  | |_     | |             _| |_| | | \__ \  __/ |  | |_\__ \/ /     | |  __/\__ \ |_\__ \
 |_|   \__,_|_|   \__|    |_|            |_____|_| |_|___/\___|_|   \__|___/_/      |_|\___||___/\__|___/                                                                                                        
 */


select * from bike_status_log;


call update_bike_status(6, 'F');

select * from a_Bike;

select * from a_customer ac;
select * from a_bike ab;
select * from a_bike_parts abp;
select * from a_bike_repair abr;
select * from a_new_model anm;
select * from a_suppliers as2;

select * from a_customer ac 
full join a_bike ab using(cust_id)
full join a_bike_repair abr using(bike_id)
full join a_new_model anm using(bike_id)
full join a_suppliers as2 using(supplier_id);













