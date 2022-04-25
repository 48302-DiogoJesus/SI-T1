/*
 * 2.m)
 * Crie os mecanismos necess�rios para que, de forma autom�tica, quando � criado um
 * alarme, o n�mero de alarmes do ve�culo seja actualizado;
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

-- TESTING --

-- Create the trigger after creating the tables and before inserting the default values
-- or add a new alarm and check if 'num_alarmes' incremented on the target 'veiculo'
