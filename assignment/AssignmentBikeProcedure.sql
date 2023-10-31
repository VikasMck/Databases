/*
  _____           _     ___             _____                        _                                       
 |  __ \         | |   |__ \           |  __ \                      | |                                   
 | |__) |_ _ _ __| |_     ) |  ______  | |__) | __ ___   ___ ___  __| |_   _ _ __ ___   
 |  ___/ _` | '__| __|   / /  |______| |  ___/ '__/ _ \ / __/ _ \/ _` | | | | '__/ _ \ 
 | |  | (_| | |  | |_   / /_           | |   | | | (_) | (_|  __/ (_| | |_| | | |  __/
 |_|   \__,_|_|   \__| |____|          |_|   |_|  \___/ \___\___|\__,_|\__,_|_|  \___|
                                                                                                            
 */

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



call update_bike_status(6, 'C');