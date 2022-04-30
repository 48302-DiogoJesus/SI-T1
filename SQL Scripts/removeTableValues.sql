create or replace procedure removeTableValues()
language plpgsql
as 
$$
	begin
	
		delete from alarme;
	
		delete from registo_invalido;
		delete from registo_proc;
		delete from registo_n_proc;
		delete from registo;
	
		delete from zona_verde;
		delete from veiculo;
		delete from estados_gps;
	
		delete from cliente_institucional;
		delete from cliente_particular;
		
		-- Reseting to default. Users are never deleted. For that we would have to drop the trigger and then re-enable it
		-- Double delete to remove the row
			-- 1st sets apagado to true
			-- 2nd if apagado = true then perform delete operation without calling the trigger function
		delete from cliente;
		delete from cliente;
	
		delete from gps;
	
	end;
$$;

call removeTableValues();