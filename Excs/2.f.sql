/*
 * 2.f)
 * Criar um procedimento que será chamado de forma periódica e que processa todos os
 * registos não processados até esse momento. Deve tratar todos os registos existentes na
 * tabela de registos não processados, de forma a copiar os dados para a tabela de registos
 * processados ou de registos inválidos e remover as entradas tratadas. Deve garantir que
 * processa todas as entradas não processadas até esse momento
 * */

drop procedure if exists handle_registos;

create or replace procedure handle_registos()
as
$$
	declare
		curr_registo_n_proc record;
		curr_id_gps int;
		curr_longitude varchar(20);
		curr_latitude varchar(20);
		curr_marca_temporal timestamp;
	begin
		-- Lock for share para impedir a remoção enquanto o registo está a ser tratado no loop (from 'registo_n_proc')
		for curr_registo_n_proc in (select id_registo from registo_n_proc for share) loop
			-- Gather column values
			select
				id_gps, longitude, latitude, marca_temporal
				into
				curr_id_gps, curr_longitude, curr_latitude, curr_marca_temporal
			from
				registo
			where registo.id = curr_registo_n_proc.id_registo for share; -- Para evitar remoção do registo a ser tratado (from 'registo')
		
			-- Escolher para onde transferir o 'registo'
			if
				curr_longitude is null or
				curr_latitude is null or
				curr_marca_temporal is null or
				-- SLock -> Uma vez que não ter gps faz parte da condição então convêm que não seja possível ser removido antes
				-- da inserção do registo nos registos inválidos 
				not exists (select * from gps where id = curr_id_gps for share)
			then
				insert into registo_invalido(id_registo) values(curr_registo_n_proc.id_registo);
			else
				insert into registo_proc(id_registo) values(curr_registo_n_proc.id_registo);
			end if;
		
			-- Remover o registo da tabela 'registos_n_proc'
			-- SLock -> XLock
			delete from registo_n_proc where registo_n_proc.id_registo = curr_registo_n_proc.id_registo;
			
		end loop;
	end;
$$ language plpgsql;
