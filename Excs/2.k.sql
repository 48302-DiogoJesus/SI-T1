/*
 * 2.k)
 * Implemente o procedimento que ser� chamado diariamente e que apaga os registos
 * inv�lidos existentes com dura��o superior a 15 dias;
 * */

drop procedure if exists remove_reg_invalidos;

create or replace procedure remove_reg_invalidos()
language plpgsql
as
$$
	declare 
		-- SLock evita a remo��o dos registo inv�lidos enquanto os estamos a tratar
		ri_cursor cursor for (select id_registo from registo_invalido for share); 
		current_ri_id_registo int;
		current_ri_time date;
	begin
		-- N�o existe qualquer prote��o contra uma T2 remover o registo a ser tratado da tabela 'registo'
		-- Os registos a remover da tabela 'registo_invalido' est�o protegidos pelo Shared Lock
		-- O n�vel de isolamento REPEATABLE READ seria suficiente para evitar este fen�meno
		
		open ri_cursor;
		
		while true loop
			-- Avan�ar o cursor uma posi��o
			fetch from ri_cursor into current_ri_id_registo;
			
			-- Fim da tabela (n�o existem mais linhas)
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
