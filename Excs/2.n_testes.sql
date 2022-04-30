/*
 * 2.n)
 * Crie um script autónomo com os testes das funcionalidades de 2d a 2m para cenários
 * normais e de erro. Este script, ao ser executado, deve listar, para cada teste, o seu nome e
 * indicação se ele correu ou não com sucesso;
 * Ex: “teste 1: Inserir Cliente com dados bem passados: Resultado OK”
 * Ou caso falhe: “teste 1: Inserir Cliente com dados bem passados: Resultado NOK
 * */

-- Drop all procedures, functions & triggers

drop procedure if exists resetTestsEnvironment;

create or replace procedure resetTestsEnvironment()
language plpgsql
as 
$$
	begin
		-- REMOVE PROCEDURE LATER
		call removeTableValues();
		call insertTableValues();
	end;
$$;

drop procedure if exists runTestes;

create or replace procedure runTests()
language plpgsql
as
$$
	declare 
		testCounter int default 0;
		testResult varchar(3); -- OK | NOK
	begin
		call resetTestsEnvironment();
		-- 2.d)
		begin
			-- Success create cliente particular
			begin
				testCounter = testCounter + 1;
				-- Action
				call insert_cliente_particular('555555555', '555555555555', 'Hneiruco Águas', 'Rua das Marmeletes nº 4', '111111111', '555555555');
				-- Validate
				if (select count(*) from cliente where nif = '555555555') is null then
					testResult = 'NOK';
				else
					testResult = 'OK';
				end if;
				raise notice 'Teste %: Inserir cliente particular corretamente: Resultado %', testCounter, testResult;
			exception
				when others then
					raise notice 'Teste %: Inserir cliente particular corretamente: Resultado NOK', testCounter;
			end;
			-- Error create cliente particular 
			begin
				testCounter = testCounter + 1;
				-- dont reset here call resetTestsEnvironment();
				call insert_cliente_particular('666666666', '555555555555', 'Hneiruco Águas', 'Rua das Marmeletes nº 4', '999999999', '555555555');
				-- Validate
				if (select count(*) from cliente where nif = '666666666') = 0 then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
				raise notice 'Teste %: Inserir cliente particular com número de telefone inválido: Resultado %', testCounter, testResult;
			exception
				when others then
					raise notice 'Teste %: Inserir cliente particular com número de telefone inválido: Resultado OK', testCounter;
			end;
			-- Update cliente particular
			begin
				testCounter = testCounter + 1;
				-- dont reset here call resetTestsEnvironment();
				-- Action
				call update_cliente_particular('555555555', '999999999999', 'Hneiroco Meneses Com S', 'Murada atualizada', null);
				-- Validate
				if (select morada from cliente where nif = '555555555') = 'Murada atualizada' then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
				raise notice 'Teste %: Atualizar cliente particular: Resultado %', testCounter, testResult;
			exception
				when others then
					raise notice 'Teste %: Atualizar cliente particular: Resultado OK', testCounter;
			end;
			-- Remove cliente particular
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				-- dont reset in this case call resetTestsEnvironment();
				-- Action
				call remove_cliente_particular('555555555');
				-- Validate
				if (select apagado from cliente where nif = '555555555') = true then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
				raise notice 'Teste %: Remover cliente particular: Resultado %', testCounter, testResult;
			exception
				when others then
					raise notice 'Teste %: Remover cliente particular: Resultado OK', testCounter;
			end;
		end;
		-- 2.e)
		begin
			-- Success count alarmes from all car with 1 alarm in 2016
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				insert into alarme(id_registo, id_veiculo) values(2, '74-FT-18');
				-- Action + Validate
				if (select count(*) from count_alarmes_returns_table(2016)) = 1 then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
				raise notice 'Teste %: Count Alarmes from car with 1 alarm: Resultado %', testCounter, testResult;
			exception
				when others then
					raise notice 'Teste %: Count Alarmes from car with 1 alarm: Resultado NOK', testCounter;
			end;
			-- Count alarmes from car with 0 alarms in 2016
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				-- Action + Validate
				if (select count(*) from count_alarmes_returns_table(2016, '03-83-AA')) = 0 then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
				raise notice 'Teste %: Count Alarmes from car with 0 alarms: Resultado %', testCounter, testResult;
				exception
					when others then
						raise notice 'Teste %: Count Alarmes from car with 0 alarms: Resultado NOK', testCounter;
			end;
		end;
		-- 2.f)
		begin
			-- Handle registos
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				-- Action + Validate
				call handle_registos();
				if
					(select count(*) from registo_n_proc) <> 0
					or
					(select count(*) from registo_proc) = 0
					or
					(select count(*) from registo_invalido) = 0
				then
					testResult = 'NOK';
				else
					testResult = 'OK';
				end if;
			
				raise notice 'Teste %: Handle Registos: Resultado %', testCounter, testResult;
				
				exception
					when others then
						raise notice 'Teste %: Handle Registos: Resultado NOK', testCounter;
			end;
		end;
		-- 2.g)
		begin
			-- Processed Registos trigger
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				-- Action
				-- Handle registos will insert into registo_n_proc triggering 2.j) trigger
				call handle_registos();
				if
					(select count(*) from alarme) = 2
				then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
			
				raise notice 'Teste %: Trigger valida registo processado %', testCounter, testResult;
				
			exception
				when others then
					raise notice 'Teste %: Trigger valida registo processado: Resultado NOK', testCounter;
			end;
		end;
		-- 2.h)
		begin
			-- Create veiculo with zona verde
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				-- Action
				call create_veiculo(
					'AB-23-AA', '111111111', 1001, 'Activo', 'Henrique', '999999999', 0,
					'-23.3457', '-90.2354', 20
				);
				if
					(
						select count(*) from veiculo where
						matricula = 'AB-23-AA' and 
						id_cliente = '111111111' and 
						nome_condutor = 'Henrique'
					) = 0
				then
					testResult = 'NOK';
				else
					testResult = 'OK';
				end if;
			
				if
					(
						select count(*) from zona_verde where
						longitude = '-23.3457' and 
						latitude = '-90.2354' and 
						raio = 20
					) = 0
				then
					testResult = 'NOK';
				else
					testResult = 'OK';
				end if;
			
				raise notice 'Teste %: Create valid veiculo + zona verde: Resultado %', testCounter, testResult;

				exception
					when others then
						raise notice 'Teste %: Create valid veiculo + zona verde: Resultado NOK', testCounter;
			end;
			-- Create veiculo withOUT zona verde
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				-- Action
				call create_veiculo(
					'AB-23-AB', '111111111', 1001, 'Activo', 'Henrique', '999999999', 0
				);
				if
					(
						select count(*) from veiculo where
						matricula = 'AB-23-AB' and 
						id_cliente = '111111111' and 
						nome_condutor = 'Henrique'
					) = 0
				then
					testResult = 'NOK';
				else
					testResult = 'OK';
				end if;
			
				raise notice 'Teste %: Create valid veiculo without zona verde: Resultado %', testCounter, testResult;

				exception
					when others then
						raise notice 'Teste %: Create valid veiculo without zona verde: Resultado NOK', testCounter;
			end;
		end;
		-- 2.i)
		begin
			-- List all alarmes view
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				-- Action
				call handle_registos();
				if
					(select count(*) from list_all_alarmes) = 2
				then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
			
				raise notice 'Teste %: List All Alarmes View: Resultado %', testCounter, testResult;
				
				exception
					when others then
						raise notice 'Teste %: List All Alarmes View: Resultado NOK', testCounter;
			end;
		end;
		--2.j
		begin
			-- INSERT into list_all_alarmes VIEW 
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				-- Action
				insert into list_all_alarmes values('03-83-AA', 'Juão Rinato', '00.2312', '00.0000', '2000-01-22 01:10:25-01');
				if
					(select count(*) from list_all_alarmes where matricula = '03-83-AA') = 1 and 
					(select count(*) from registo where longitude = '00.0000' and latitude = '00.2312' and marca_temporal = '2000-01-22 01:10:25-01') = 1 and 
					(select count(*) from alarme where id_veiculo = '03-83-AA') = 1
				then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
			
				raise notice 'Teste %: INSERT in list_all_alarmes VIEW: Resultado %', testCounter, testResult;
				
				exception
					when others then
						raise notice 'Teste %: INSERT in list_all_alarmes VIEW: Resultado NOK', testCounter;
			end;
		end;
		-- 2.k)
		begin
			-- Remove registos inválidos
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				-- Action
				call handle_registos(); 
				call remove_reg_invalidos();
				if
					(select id_registo from registo_invalido limit 1) = 6 -- único que ainda não passaram 15 dias
				then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
			
				raise notice 'Teste %: Remove registos inválidos: Resultado %', testCounter, testResult;
				
				exception
					when others then
						raise notice 'Teste %: Remove registos inválidos: Resultado NOK', testCounter;
			end;
		end;
		-- 2.l)
		begin
			-- Try delete cliente particular
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				-- Action
				delete from cliente where nif = '111111111';
				delete from cliente where nif = '222222222';
				if
					(select apagado from cliente where nif = '111111111') = true
					or
					(select apagado from cliente where nif = '222222222') = true
				then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
			
				raise notice 'Teste %: Try remove Cliente: Resultado %', testCounter, testResult;
				
				exception
					when others then
						raise notice 'Teste %: Try remove Cliente: Resultado NOK', testCounter;
			end;
		end;
		-- 2.m)
		begin
			-- Increment alarms count with trigger
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call resetTestsEnvironment();
				-- Action
				call create_veiculo(
					'AB-23-AA', '111111111', 1001, 'Activo', 'Henrique', '999999999', 0,
					'-23.3457', '-90.2354', 20
				);
				
				-- USAR 2.J) PARA CRIAR UM REGISTO COM O ID DO VEICULO E MARCÁ-LO COMO ALARME
				insert into list_all_alarmes values('AB-23-AA', 'Henrique', '-23.3233', '12.2382', '2016-06-22 19:10:25-03');	
			
				if 
					(select num_alarmes from veiculo where matricula = 'AB-23-AA') = 1
				then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
				raise notice 'Teste %: Increment alarms count with trigger: Resultado %', testCounter, testResult;
				
				exception
					when others then
						raise notice 'Teste %: Increment alarms count with trigger: Resultado NOK', testCounter;
			end;
		end;
		call resetTestsEnvironment();
	end;
$$;

call runTests();


