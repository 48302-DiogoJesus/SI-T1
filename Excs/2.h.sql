/*
 * 2.h)
 * Desenvolver um procedimento que crie um ve�culo com a respectiva informa��o do
 * equipamento associado, e que o associe a um cliente. Caso sejam passados dados para a
 * cria��o de uma zona verde, deve criar e associar o ve�culo a essa zona. Reutilize
 * procedimentos j� existentes ou crie novos se necess�rio; Deve garantir as restri��es de
 * neg�cio respectivas, nomeadamente a limita��o do n�mero de ve�culos
 * */

drop procedure create_veiculo;

create or replace procedure create_veiculo(
	-- Ve�culo
	matricula char(8), i_id_cliente char(9), id_gps int, estado_gps varchar(20),
	nome_condutor varchar(30), telefone_condutor char(9), num_alarmes int,
	-- Zona Verde
	longitude varchar(20) default null, latitude varchar(20) default null, raio int default null
)
language plpgsql
as
$$
	declare
		n_of_veiculos_cp bigint;
		error_msg text;
		error_sqlstate text;
	begin
		raise notice ''; -- newline
	    -- Tipo de cliente: particular m�x 3
		if
			(select count(*) from cliente_particular as cp where cp.id_cliente = i_id_cliente) is not null
		then
			-- � cliente particular
			select count(*) into n_of_veiculos_cp 
			from veiculo
			where veiculo.id_cliente = i_id_cliente;
			
			-- Excedeu n�mero de ve�culos
			if n_of_veiculos_cp >= 3 then
				raise notice 'Cliente j� excedeu n�mero de ve�culos';
				return;
			end if;	
		end if;
		
	    -- Criar veiculo
		insert into veiculo values(matricula, i_id_cliente, id_gps, estado_gps, nome_condutor, telefone_condutor, num_alarmes);
	
	    -- H� Zona verde ?
		if 
			longitude is null or
			latitude is null or
			raio is null
		then
			raise notice 'Zona Verde n�o foi passada. Ve�culo criado com sucesso!';
			return;
		end if;
		
	    -- Se sim, criar zona verde
		insert into zona_verde(id_veiculo, longitude, latitude, raio) 
		values(matricula, longitude, latitude, raio);
	
		raise notice 'Zona Verde criada com sucesso! Ve�culo criado com sucesso!';
	
	exception
		when others then
			get stacked diagnostics error_msg = MESSAGE_TEXT,
									error_sqlstate = RETURNED_SQLSTATE;
								
		raise notice 'ERROR HAPPENED';
		raise notice 'Error SQLState: %', error_sqlstate;
		raise notice 'Error Message: %', error_msg;
	end;
$$;

-- Nota: Zona Verde apenas � criada caso os 3 par�metros sejam passados