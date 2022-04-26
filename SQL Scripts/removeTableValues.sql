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
		
		-- Only 'apagado' flag is set to TRUE
		delete from cliente; 
	
		delete from gps;
	
	end;
$$;

call removeTableValues();