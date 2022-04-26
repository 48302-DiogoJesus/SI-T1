create or replace procedure dropTables()
language plpgsql
as 
$$
	begin
		drop table if exists alarme cascade;
	
		drop table if exists registo_invalido cascade;
		drop table if exists registo_proc cascade;
		drop table if exists registo_n_proc cascade;
		drop table if exists registo cascade;
	
		drop table if exists zona_verde cascade;
		drop table if exists veiculo cascade;
		drop table if exists estados_gps cascade;
	
		drop table if exists cliente_institucional cascade;
		drop table if exists cliente_particular cascade;
		drop table if exists cliente cascade;
	
		drop table if exists gps cascade;
	end;
$$;

call dropTables();