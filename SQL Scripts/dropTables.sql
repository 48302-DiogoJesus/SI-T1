begin transaction;
	drop table if exists alarme;

	drop table if exists registo_invalido;
	drop table if exists registo_proc;
	drop table if exists registo_n_proc;
	drop table if exists registo;

	drop table if exists zona_verde;
	drop table if exists veiculo;
	drop table if exists estados_gps;

	drop table if exists cliente_institucional;
	drop table if exists cliente_particular;
	drop table if exists cliente;

	drop table if exists gps;
commit transaction;