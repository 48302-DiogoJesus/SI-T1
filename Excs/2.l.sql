/*
 * 2.l)
 * Crie os mecanismos necessários para que a execução da instrução DELETE sobre a tabela de
 * cliente permita desativar o(s) Cliente(s) sem apagar os seus dados. Assuma que podem ser
 * apagados vários clientes em simultâneo
 * */

-- TRIGGER FUNCTION --

drop function if exists remove_client;

create or replace function remove_client()
returns trigger
language plpgsql
as
$$
	begin
		update cliente set apagado = true where nif = old.nif;
		/* 
		 * To avoid deletion 
		 * If we returned OLD then the delete instruction would proceed 
		 * and client could be removed. This way it does not execute it
		 * */
		return null;
	end;
$$;


-- TRIGGER --

drop trigger if exists remove_client on cliente;

create or replace trigger remove_client 
before delete on cliente
for each row
when (not old.apagado)
	execute function remove_client();
