/*
 * 2.j)
 * Adicione suporte de modo que a execução da instrução INSERT sobre a vista da alínea
 * anterior permita adicionar um alarme e o respectivo registo tratado;
 * */
 
-- RULE PROCEDURE --

drop rule if exists list_alarmes_and_registos on alarme;
drop function if exists add_alarm_and_registo;

create or replace function add_alarm_and_registo()
returns trigger
language plpgsql
as
$$
    declare id_registo int;
    declare id_gps int;

    begin

        select e.id_gps into id_gps from veiculo e where e.matricula = new.matricula;

        insert into registo (id_gps, longitude, latitude, marca_temporal) 
            values (id_gps ,new.longitude, new.latitude, new.marca_temporal) 
            returning id_registo;

        insert into alarme (id_registo, id_veiculo) values (id_registo, new.matricula);

        return null;
    end;
$$;

-- RULE --

create or replace rule list_alarmes_and_registos as 
on insert to list_all_alarmes 
do instead 
    execute function add_alarm_and_registo();