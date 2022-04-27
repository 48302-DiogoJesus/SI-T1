/*
 * 2.d)
 * Criar os mecanismos que permitam:
 * - inserir cliente particular
 * - atualizar cliente particular (CC, NIF, nome, morada, cliente que o referenciou); 
 * - remover cliente particular
 * */

-- alter sequence {tablename}_{columnname}_seq restart with 1;

-- INSERT CLIENTE PARTICULAR
drop procedure if exists insert_cliente_particular;

create or replace procedure insert_cliente_particular(i_nif char(9), i_cc char(12), i_nome varchar(30), i_morada varchar(40), i_ref_client char(9), i_telefone char(9))
language plpgsql
As
$$
	declare
		error_msg text;
		error_sqlstate text;
	begin
		
	  insert into cliente(nif, referenciador, nome, morada, telefone) values(i_nif, i_ref_client, i_nome, i_morada, i_telefone);
	  insert into cliente_particular (id_cliente, cc) values(i_nif, i_cc);
	 
	exception
		when others then
			get stacked diagnostics error_msg = MESSAGE_TEXT,
									error_sqlstate = RETURNED_SQLSTATE;
								
		raise notice 'ERROR HAPPENED';
		raise notice 'Error SQLState: %', error_sqlstate;
		raise notice 'Error Message: %', error_msg;
	end;
$$;

-- UPDATE CLIENTE PARTICULAR
drop procedure if exists update_cliente_particular;

-- Desta forma obrigamos quem chama a função a passar todos os parâmetros
-- O único que pode ser passado como NULL é o "i_ref_client" uma vez que o seu domínio de valores permite
create or replace procedure update_cliente_particular(i_nif char(9), n_cc char(12), n_nome varchar(30), n_morada varchar(40), n_ref_client char(9))
language plpgsql
As
$$
begin 
  update cliente
  set referenciador = n_ref_client, nome = n_nome, morada = n_morada
  where nif = i_nif;
 
  update cliente_particular 
  set cc = n_cc
  where id_cliente = i_nif;
end;$$;


-- REMOVE CLIENTE PARTICULAR
drop procedure if exists remove_cliente_particular;

create or replace procedure remove_cliente_particular(i_nif char(9))
language plpgsql
As
$$
begin
	if (select count(*) from cliente_particular where id_cliente = i_nif) = 0 then
		raise notice 'Cliente Particular não encontrado!';
		return;
	end if;
	
    delete from cliente where nif = i_nif;
end;$$;
