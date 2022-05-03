/*
 * 2.g)
 * Criar um gatilho que permita analisar o registo processado, aquando da sua criação. e que
 * gere o respetivo alarme caso esteja fora de qualquer uma das suas zonas verdes. Se não
 * existirem zonas verdes ou se o equipamento estiver em pausa de alarmes não gera alarme.
 * Para a realização do gatilho, deverá usar a função zonaVerdeValida que recebe as
 * coordenadas e o raio de uma zona verde e as coordenadas do registo em processamento e
 * retorne true se as coordenadas do registo a ser processado se encontrarem dentro da zona
 * verde e false caso contrário. Para teste implemente uma versão da função zonaVerdeValida
 * que retorna true quando a o arredondamento da coordenada da latitude do registo for par e
 * false quando for impar;
 * */

drop function if exists analise_registo cascade;

/*
* Retorna TRUE caso o arredondamento da latitude seja um número par, FALSE se for ímpar
*/
create or replace function zonaVerdeValida(id_registo int)
returns boolean
language plpgsql
as
$$
    begin
	    if
	    	mod((select latitude::decimal::int from registo where id = id_registo), 2) = 0
	    then 
	        return true;
	    end if;
	   
        return false;
    end;
$$; 

create or replace function analise_registo()
returns trigger
language plpgsql
as
$$
    declare 
        veiculo_id char(8);
    begin
        
        select matricula from veiculo where veiculo.id_gps = (
       		select id_gps from registo where new.id_registo = registo.id
        ) into veiculo_id;
        if
          	-- Existem zonas verdes para o veiculo
	        (select count(id) from zona_verde where zona_verde.id_veiculo = veiculo_id) <> 0 and 
            -- Equipamento não está em PausaDeAlarmes
            (select estado_gps from veiculo where veiculo.matricula = veiculo_id) <> 'PausaDeAlarmes' and 
        	-- Veiculo fora da zona verde
            not zonaVerdeValida(new.id_registo) 
        then 
            insert into alarme(id_registo, id_veiculo) values(new.id_registo, veiculo_id);
        end if;
        
        return new;
    end;
$$;


-- TRIGGER --

drop trigger if exists analise_registo on registo_proc;

create or replace trigger analise_registo 
after insert on registo_proc
for each row
execute function analise_registo();
