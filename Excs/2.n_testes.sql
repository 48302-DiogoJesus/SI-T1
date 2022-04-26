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
		-- 2.d)
		begin
			-- Success create cliente particular
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call removeTableValues();
				call insertTableValues();
				-- Action
				call insert_cliente_particular('555555555', '555555555555', 'Hneiruco Águas', 'Rua das Marmeletes nº 4', '111111111', '555555555');
				-- Validate
				if (select count(*) from cliente where nif = '555555555') is null then
					testResult = 'NOK';
				else
					testResult = 'OK';
				end if;
				raise notice 'Teste %: Inserir cliente particular corretamente: Resultado %', testCounter, testResult;
				-- Needed Clean-up
				if testResult = 'OK' then
					delete from cliente_particular where id_cliente = '555555555';
					delete from cliente where nif = '555555555';
				end if;
			exception
				when others then
					raise notice 'Teste %: Inserir cliente particular corretamente: Resultado NOK: %s', testCounter, errorMessage;
			end;
			-- Error create cliente particular
			begin
				testCounter = testCounter + 1;
				-- Reset Environment
				call removeTableValues();
				call insertTableValues();
				-- Action (invalid phone number)
				call insert_cliente_particular('555555555', '555555555555', 'Hneiruco Águas', 'Rua das Marmeletes nº 4', '999999999', '555555555');
				-- Validate
				if (select count(*) from cliente where nif = '555555555') is null then
					testResult = 'OK';
				else
					testResult = 'NOK';
				end if;
				raise notice 'Teste %: Inserir cliente particular corretamente: Resultado %', testCounter, testResult;
				-- Needed Clean-up
				delete from cliente_particular where id_cliente = '555555555';
				delete from cliente where nif = '555555555';
			exception
				when others then
					raise notice 'Teste %: Inserir cliente particular corretamente: Resultado OK', testCounter;
			end;
		end;
	end;
$$;

call runTests();


