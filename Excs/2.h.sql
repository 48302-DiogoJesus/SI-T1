drop procedure create_veiculo;

call create_veiculo(
	'AB-23-PD', '111111111', 1001, 'Activo', 'Henrique', '999999999', 0,
	'-23.3457', '-90.2354', 20
);

create or replace procedure create_veiculo(
	-- Veículo
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
	begin
	    -- Verificar cliente existe
		if
			(select count(*) from cliente where cliente.nif = i_id_cliente) is null 
		then
			raise notice 'Cliente não existente';
			return;
		end if;
	
		-- Verificar se estado gps existe
		if
			(select count(*) from estados_gps where estado = estado_gps) is null 
		then
			raise notice 'Estado de GPS inválido';
			return;
		end if;
	
		-- Verificar se gps existe
		if
			(select count(*) from gps where id = id_gps) is null 
		then
			raise notice 'GPS inexistente';
			return;
		end if;
	
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