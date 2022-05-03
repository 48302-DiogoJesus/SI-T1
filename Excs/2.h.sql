/*
 * 2.h)
 * Desenvolver um procedimento que crie um veículo com a respectiva informação do
 * equipamento associado, e que o associe a um cliente. Caso sejam passados dados para a
 * criação de uma zona verde, deve criar e associar o veículo a essa zona. Reutilize
 * procedimentos já existentes ou crie novos se necessário; Deve garantir as restrições de
 * negócio respectivas, nomeadamente a limitação do número de veículos
 * */

drop procedure if exists create_veiculo;

create or replace procedure create_veiculo(
	-- Veículo
	matricula char(8), i_id_cliente char(9), id_gps int, estado_gps varchar(20),
	nome_condutor varchar(30), telefone_condutor char(9), num_alarmes int,
	-- Zona Verde (Opcional) caso 
	longitude varchar(20) default null, latitude varchar(20) default null, raio int default null
)
language plpgsql
as
$$
	declare
		n_of_veiculos_cp bigint;
	begin
	
		raise notice '';
	    -- Tipo de cliente: particular máx 3
		if
			(select count(*) from cliente_particular as cp where cp.id_cliente = i_id_cliente) is not null
		then
			-- É cliente particular
			select count(*) into n_of_veiculos_cp 
			from veiculo
			where veiculo.id_cliente = i_id_cliente;
			
			-- Excedeu número de veículos
			if n_of_veiculos_cp >= 3 then
				raise notice 'Cliente já excedeu número de veículos';
				return;
			end if;	
		end if;
		
	    -- Criar veiculo
		insert into veiculo values(matricula, i_id_cliente, id_gps, estado_gps, nome_condutor, telefone_condutor, num_alarmes);
	
	    -- Há Zona verde ?
		if 
			longitude is null or
			latitude is null or
			raio is null
		then
			raise notice 'Zona Verde não foi passada. Veículo criado com sucesso!';
			return;
		end if;
		
	    -- Se sim, criar zona verde
		insert into zona_verde(id_veiculo, longitude, latitude, raio) 
		values(matricula, longitude, latitude, raio);
	
		raise notice 'Zona Verde criada com sucesso! Veículo criado com sucesso!';
	
	end;
$$;

-- Nota: Zona Verde apenas é criada caso os 3 parâmetros sejam passados