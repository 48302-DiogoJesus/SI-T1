drop procedure handle_registos;

create or replace procedure handle_registos()
as
$$
	declare
		curr_registo_n_proc record;
		curr_id_gps int;
		curr_longitude varchar(20);
		curr_latitude varchar(20);
		curr_marca_temporal timestamp;
	begin
		for curr_registo_n_proc in (select id_registo from registo_n_proc) loop
			-- Gather column values
			select 
				id_gps, longitude, latitude, marca_temporal
				into
				curr_id_gps, curr_longitude, curr_latitude, curr_marca_temporal
			from
				registo
			where registo.id = curr_registo_n_proc.id_registo;
		
			-- Choose where to transfer the 'registo'
			if 
				curr_longitude is null or
				curr_latitude is null or
				curr_marca_temporal is null or
				(select count(*) from gps where id = curr_id_gps) is null
			then
				insert into registo_invalido(id_registo) values(curr_registo_n_proc.id_registo);
			else 
				insert into registo_proc(id_registo) values(curr_registo_n_proc.id_registo);
			end if;
		
			-- Remove from non processed 'registos'
			delete from registo_n_proc where registo_n_proc.id_registo = curr_registo_n_proc.id_registo;
			
		end loop;
	end;
$$ language plpgsql;

call handle_registos();