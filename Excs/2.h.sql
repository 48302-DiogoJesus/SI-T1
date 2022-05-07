/*
 * 2.h)
 * Desenvolver um procedimento que crie um ve�culo com a respectiva informa��o do
 * equipamento associado, e que o associe a um cliente. Caso sejam passados dados para a
 * cria��o de uma zona verde, deve criar e associar o ve�culo a essa zona. Reutilize
 * procedimentos j� existentes ou crie novos se necess�rio; Deve garantir as restri��es de
 * neg�cio respectivas, nomeadamente a limita��o do n�mero de ve�culos
 * */

drop procedure if exists create_veiculo;

create or replace procedure create_veiculo(
	-- Ve�culo
	matricula char(8), i_id_cliente char(9), id_gps int, estado_gps varchar(20),
	nome_condutor varchar(30), telefone_condutor char(9), num_alarmes int,
	-- Zona Verde (Opcional) caso 
	longitude varchar(20) default null, latitude varchar(20) default null, raio int default null
)
language plpgsql
as
$$
	begin
	-- Achamos que REPEATABLE READ seja o n�vel de isolamento adequado para impedir a inser��o de ve�culos (phantoms) enquanto este procedimento
	-- ocorre. Isto levaria a que um cliente particular pudesse ter mais do que 3 veiculos porque T1 veria que o CP tinha 2 veiculos mas antes de 
	-- criar o veiculo T2 verificava o mesmo e tamb�m inseria um veiculo ficando o CP assim com 4 ve�culos.
	
	-- set transaction isolation level repeatable read;
		-- ERROR: SET TRANSACTION ISOLATION LEVEL must be called before any query
	    
		-- Tipo de cliente: particular: m�x 3
		if
			exists (select * from cliente_particular as cp where cp.id_cliente = i_id_cliente)
		then
			-- � cliente particular			
			-- J� tem o m�ximo n�mero de ve�culos permitido para clientes particulares
			if
				(
					select count(*)
					from veiculo
					where veiculo.id_cliente = i_id_cliente
				) >= 3 
			then
				raise notice 'Cliente Particular j� atingiu o n�mero m�ximo de ve�culos';
				return;
			end if;	
		end if;
		
	    -- Criar veiculo
		-- SGBD j� valida se cliente existe, da� n�o termos usado locks em cima
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
	
	end;
$$;

-- Nota: Zona Verde apenas � criada caso os 3 par�metros sejam passados