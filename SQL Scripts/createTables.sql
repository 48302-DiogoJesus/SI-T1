-- FALTAM RESTRIÇÕES NO DOMINO DOS VALORES DOS ATRIBUTOS
create or replace procedure createTables()
language plpgsql
as
$$
	begin
		create table if not exists gps(
			-- PK
			id int,
			
			primary key(id)
		);
	
		create table if not exists cliente(
			-- PK
			nif char(9) check(nif similar to '[0-9]{9}'),
			-- FK
			referenciador char(9),
			-- ATTRS
			nome varchar(30) 	not null check(length(nome) > 10),
			morada varchar(40) 	not null check(length(morada) > 10),
			telefone char(9) 	not null check(telefone similar to '[0-9]{9}'),
			apagado bool 		default false not null,
			
			primary key(nif),
			constraint referenciador_fk foreign key (referenciador) references cliente(nif) on delete set null deferrable
		);
		
		create table if not exists cliente_particular(
			-- PK
			id_cliente char(9) not null,
			-- ATTRS
			cc char(12) not null,
			
			primary key(id_cliente),
			foreign key(id_cliente) references cliente(nif) on delete cascade
		);
	
		create table if not exists cliente_institucional(
			-- PK
			id_cliente char(9) not null,
			-- ATTRS
			nome_de_contacto varchar(30) not null check(length(nome_de_contacto) >= 8),
			
			primary key (id_cliente),
			foreign key (id_cliente) references cliente(nif) on delete cascade
		);
	
		-- Table containing all possible GPS states
		create table if not exists estados_gps(
			estado varchar(20) primary key
		);
	
		create table if not exists veiculo(
			-- PK
			-- Later create trigger to convert to uppercase
			matricula char(8) check (matricula like '__-__-__') ,
			-- FK
			id_cliente char(9) not null,
			id_gps int not null,
			estado_gps varchar(20),
			-- ATTRS
			nome_condutor varchar(30) not null check(length(nome_condutor) > 5),
			telefone_condutor char(9) check(telefone_condutor similar to '[0-9]{9}'),
			num_alarmes int not null default 0,
			
			primary key (matricula),
			foreign key (estado_gps) references estados_gps(estado),
			foreign key (id_cliente) references cliente(nif) on delete cascade,
			foreign key (id_gps) references gps(id)
		);
	
		create table if not exists zona_verde(
			-- PK
			id serial,
			-- FK
			id_veiculo char(8) not null,
			-- ATTRS
			longitude varchar(20) not null, -- store long/lat as string for now
			latitude varchar(20) not null,
			raio int not null check (raio > 0),
			
			primary key(id),
			foreign key (id_veiculo) references veiculo(matricula) on delete cascade
		);
	
		create table if not exists registo(
			-- PK
			id serial,
			-- FK
			id_gps int not null,
			-- ATTRS
			longitude varchar(20),
			latitude varchar(20),
			marca_temporal timestamp,
			
			primary key(id),
			foreign key (id_gps) references gps(id)
		);
	
		create table if not exists registo_n_proc(
			-- PK
			id_registo int,
			
			primary key(id_registo),
			foreign key(id_registo) references registo(id) on delete cascade
		);
	
	
		create table if not exists registo_proc(
			-- PK
			id_registo int,
			
			primary key(id_registo),
			foreign key(id_registo) references registo(id) on delete cascade
		);
	
		create table if not exists registo_invalido(
			-- PK
			id_registo int,
			
			primary key(id_registo),
			foreign key(id_registo) references registo(id) on delete cascade
		);
	
		create table if not exists alarme(
			-- PK
			id serial,
			-- FK
			id_registo int not null,
			id_veiculo char(8) not null,
			
			primary key(id),
			
			foreign key (id_registo) references registo(id) on delete cascade,
			foreign key (id_veiculo) references veiculo(matricula) on delete cascade
		);
	end;
$$;

call createTables();