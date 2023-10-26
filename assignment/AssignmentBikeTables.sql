drop table if exists a_bike_parts, 
a_bike_repair, a_bike, a_customer, a_new_model, a_suppliers;

--table for customers
create table a_customer(
    cust_id serial primary key,
    cust_name varchar(50) not null,
    cust_phone_num varchar(20) not null,
    constraint unique_cust_info unique (cust_name, cust_phone_num) --this ensures that
    --2 customers will not have same number and vice versa
);

--table for bikes which references customers
create table a_bike(
    bike_id serial primary key,
    bike_model varchar(30),
    bike_status char(1) not null check (bike_status in ('R', 'C', 'F')),
    --ensures that these are the only values allowed
    cust_id int references a_customer(cust_id)
);

--table that will be used my the mechanic to track repairs
create table a_bike_repair(
    repair_id serial primary key,
    bike_id int references a_bike(bike_id),
	bike_repair_required varchar(255),
	replaced_parts varchar(255),
	bike_work_hours varchar(20)
);

--not really needed but can stay
create table a_suppliers (
    supplier_id serial primary key,
    supplier_name varchar(255)
);

--main table that has all parts
create table a_bike_parts (
    part_id serial primary key,
    part_name varchar(255),
    repair_id int references a_bike_repair(repair_id),
    --this line of code is for this "Parts can sometimes contain other parts
    --for example, the wheel will contain spokes, but a spoke can be provided separately."
    contains_part_id int references a_bike_parts(part_id)
);

--table which tracks new bike models
create table a_new_model (
    model_id serial primary key,
    model_name varchar(30),
    bike_id int references a_bike(bike_id),
    supplier_id int references a_suppliers(supplier_id)
);


--randomly generated customers
insert into a_customer (cust_name, cust_phone_num) values
  ('Susan Lee', '+353861234567'),
  ('David Smith', '0869876543'),
  ('Linda Johnson', '+353875557890'),
  ('James Brown', '0853217890'),
  ('Emily Wilson', '+353864441122'),
  ('Michael Anderson', '0875558888'),
  ('Sophia Martin', '+353851113333'),
  ('Joseph Thompson', '0869994444'),
  ('Olivia White', '+353872225555'),
  ('William Jones', '0851234567'),
  ('John Doe', '0857772222'),
  ('Mary Wilson', '+353868881111'),
  ('Robert Jones', '0854443333'),
  ('Laura Davis', '+353873335555'),
  ('William Smith', '0852229999'),
  ('Elizabeth Taylor', '+353869994444'),
  ('Daniel Clark', '0875553333'),
  ('Sarah Anderson', '+353854442222'),
  ('James Thompson', '0856667777'),
  ('Olivia Harris', '+353871118888');

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
  (5, 'Adjust Brakes', 'Brake Pads', '2.5 hours'),
  (6, 'Tire Replacement', 'Tires', '1.2 hours'),
  (7, 'Chain Lubrication', 'Chain', '0.8 hours'),
  (8, 'Gear Adjustment', 'Gears', '1.5 hours'),
  (9, 'Battery Replacement', 'Battery', '3.0 hours'),
  (10, 'Frame Welding', 'Welding Materials', '2.0 hours'),
  (11, 'Adjust Brakes', 'Brake Pads', '2.0 hours'),
  (12, 'Tire Replacement', 'Tires', '1.2 hours'),
  (13, 'Chain Lubrication', 'Chain', '0.8 hours'),
  (14, 'Gear Adjustment', 'Gears', '1.5 hours'),
  (15, 'Battery Replacement', 'Battery', '3.0 hours'),
  (16, 'Frame Welding', 'Welding Materials', '2.0 hours'),
  (17, 'Adjust Brakes', 'Brake Pads', '2.0 hours'),
  (18, 'Tire Replacement', 'Tires', '1.2 hours'),
  (19, 'Chain Lubrication', 'Chain', '0.8 hours'),
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

 
select * from a_customer ac;
select  * from a_bike ab;
select * from a_bike_parts abp;
select * from a_bike_repair abr;
select * from a_new_model anm;
select * from a_suppliers as2;

select * from a_customer ac 
join a_bike ab using(cust_id)
join a_bike_repair abr using(bike_id)
full join a_new_model anm using(bike_id)
full join a_suppliers as2 using(supplier_id);





