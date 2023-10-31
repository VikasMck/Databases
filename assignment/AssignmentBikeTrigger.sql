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

