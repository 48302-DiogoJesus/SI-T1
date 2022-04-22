begin transaction;

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
	-- Cuidado com referencia circular referenciador (Cliente)
	delete from cliente;

	delete from gps;

commit transaction;