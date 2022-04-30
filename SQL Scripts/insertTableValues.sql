
create or replace procedure insertTableValues()
language plpgsql
as 
$$
	begin
		
		insert into gps values(1001) on conflict do nothing;
		insert into gps values(2002) on conflict do nothing;
		insert into gps values(3003) on conflict do nothing;
		insert into gps values(4004) on conflict do nothing;
		
		set constraints referenciador_fk deferred;
		
		insert into cliente values ('111111111', null, 'Francisca Ferreira', 'Rua da Alegria', 111111111, false) on conflict do nothing;
		insert into cliente values ('222222222', '111111111', 'Eduardo Vieira', 'Praça Eduardo I', 222222222, false) on conflict do nothing;
		insert into cliente values ('333333333', '444444444', 'Manuel Pereira', 'Rua Sao Teotonio Pereira', 333333333, false) on conflict do nothing;
		insert into cliente values ('444444444', null, 'Filipe Andrade', 'Rua Rogerio II', 444444444, false) on conflict do nothing;
		
		set constraints referenciador_fk immediate;
		
		insert into cliente_particular values('111111111', '111111111111') on conflict do nothing;
		insert into cliente_particular values('444444444', '222222222222') on conflict do nothing;
		
		insert into cliente_institucional values('222222222', 'João Pedra') on conflict do nothing;
		insert into cliente_institucional values('333333333', 'Rosário Pereira') on conflict do nothing;
		
		insert into estados_gps values('Inactivo') on conflict do nothing;
		insert into estados_gps values('PausaDeAlarmes') on conflict do nothing;
		insert into estados_gps values('Activo') on conflict do nothing;
		
		insert into veiculo values ('JD-23-09', '444444444', 1001, 'Inactivo', 'Jozé Manazes', 444444444, 0) on conflict do nothing;
		insert into veiculo values ('74-FT-18', '333333333', 2002, 'Activo', 'Porsche Caipata', 333333333, 0) on conflict do nothing;
		insert into veiculo values ('03-83-AA', '222222222', 3003, 'PausaDeAlarmes', 'Juão Rinato', 222222222, 0) on conflict do nothing;
		insert into veiculo values ('RT-16-34', '111111111', 4004, 'Inactivo', 'Marcopa Ulo', 111111111, 0) on conflict do nothing;
		
		insert into zona_verde values(1, '74-FT-18', '38.8951', '-93.2394', 100) on conflict do nothing;
		insert into zona_verde values(2, 'RT-16-34', '12.4893', '38.2983', 20) on conflict do nothing;
		insert into zona_verde values(3, 'JD-23-09', '38.8951', '12.4893', 150) on conflict do nothing;
		insert into zona_verde values(4, '03-83-AA', '-77.0364', '-93.2394', 350) on conflict do nothing;
		
		alter sequence zona_verde_id_seq restart with 5;
		
		insert into registo values(1, 1001, '38.8951', '-77.0364', '2022-01-22 01:10:25-07') on conflict do nothing;
		insert into registo values(2, 2002, null, '38.3491', '2016-06-22 07:23:25-06') on conflict do nothing;
		insert into registo values(3, 3003, '29.3458', '-93.2394', '2016-06-22 10:10:50-05') on conflict do nothing;
		insert into registo values(4, 4004, '12.3493', null, null) on conflict do nothing;
		insert into registo values(5, 1001, '32.8341', '-77.0364', '2016-06-22 19:10:25-03') on conflict do nothing;
		insert into registo values(6, 2002, '-90.0364', null, '2022-04-24 17:10:15-02') on conflict do nothing;
		insert into registo values(7, 2002, null, '23.8951', '2016-06-22 14:10:20-02') on conflict do nothing;
		
		alter sequence registo_id_seq restart with 8;
		
		insert into registo_n_proc values (1) on conflict do nothing;
		insert into registo_n_proc values (2) on conflict do nothing;
		insert into registo_n_proc values (3) on conflict do nothing;
		insert into registo_n_proc values (4) on conflict do nothing;
		insert into registo_n_proc values (5) on conflict do nothing;
		insert into registo_n_proc values (6) on conflict do nothing;
		insert into registo_n_proc values (7) on conflict do nothing;
		
		alter sequence alarme_id_seq restart with 5;
		
	end;
$$;

call insertTableValues();