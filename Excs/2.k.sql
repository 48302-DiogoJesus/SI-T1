/*
 * 2.k)
 * Implemente o procedimento que será chamado diariamente e que apaga os registos
 * inválidos existentes com duração superior a 15 dias;
 * */

drop procedure if exists remove_reg_invalidos;

create or replace procedure remove_reg_invalidos()
language plpgsql
as
$$
	declare 
		ri_cursor cursor for (select id_registo from registo_invalido);
		current_ri_id_registo int;
		current_ri_time date;
	begin
		open ri_cursor;
		
		while true loop
			-- Avançar o cursor uma posição
			fetch from ri_cursor into current_ri_id_registo;
			
			-- Fim da tabela (não existem mais linhas)
			if not found then
				return;
			end if;
		
			select marca_temporal into current_ri_time::date
			from registo
			where id = current_ri_id_registo;
			
			if
				(current_date - current_ri_time) <= 15
				and
				(current_date - current_ri_time) is not null
			then
				continue;
			end if;
			
			-- Passaram mais de 15 dias OU 'marca_temporal' = NULL
				
			-- Apagar da tabela 'Registo_Invalido'
			delete from registo_invalido where current of ri_cursor;
			-- Apagar da tabela 'Registo'
			delete from registo where id = current_ri_id_registo;
		
			continue;
		end loop;
	
		close ri_cursor;
		
	end;
$$;
