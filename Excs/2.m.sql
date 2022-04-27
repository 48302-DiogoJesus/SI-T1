/*
 * 2.m)
 * Crie os mecanismos necessários para que, de forma automática, quando é criado um
 * alarme, o número de alarmes do veículo seja actualizado;
 * */

-- TRIGGER FUNCTION --

drop function if exists increment_alarm_count;

create or replace function increment_alarm_count()
returns trigger
language plpgsql
as
$$
	begin
		
		update veiculo 
		set num_alarmes = num_alarmes + 1 
		where matricula = new.id_veiculo;

		return null;
	end;
$$;


-- TRIGGER --

drop trigger if exists increment_alarm_count on alarme;

create or replace trigger increment_alarm_count 
after insert on alarme
for each row
execute function increment_alarm_count();
