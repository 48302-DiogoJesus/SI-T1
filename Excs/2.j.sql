/*
 * 2.j)
 * Adicione suporte de modo que a execução da instrução INSERT sobre a vista da alínea
 * anterior permita adicionar um alarme e o respectivo registo tratado;
 * */
 
-- RULE PROCEDURE --

drop trigger if exists add_to_list_alarme_and_registo on list_all_alarmes;
drop function if exists add_alarme_and_registo;

create or replace function add_alarme_and_registo()
returns trigger
language plpgsql
as
$$
    declare 
   		registo_id int;
    	gps_id int;
    begin

	   	if 
	   	(
	   		select count(*) from veiculo where 
	   		matricula = new.matricula and
	   		nome_condutor = new.nome_condutor
	   	) = 0
   		then	
	   		raise exception 'O veiculo com a matricula % não se encontra na tabela veiculo ou o nome do condutor para o veículo não está correto!', new.matricula;
	   		return null;
	   	end if;
	   
	    select id_gps into gps_id from veiculo v where v.matricula = new.matricula;
	   
        insert into registo (id_gps, longitude, latitude, marca_temporal) 
            values (gps_id, new.longitude, new.latitude, new.marca_temporal) 
            returning id into registo_id;
           
        insert into alarme (id_registo, id_veiculo) values (registo_id, new.matricula);
       
        return null;
    end;
$$;

-- TRIGGER --

create or replace trigger add_to_list_alarme_and_registo
instead of insert on list_all_alarmes
for each row
execute function add_alarme_and_registo();