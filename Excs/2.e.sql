/*
 * 2.e)
 * Criar uma função que devolve o total de alarmes para um determinado ano e veículo
 * passados como parâmetros; caso a matrícula do veículo seja vazia deve devolver as contagens
 * de alarmes para todos os veículos nesse ano
 * */

drop function count_alarmes_returns_table;

create or replace function count_alarmes_returns_table(i_year int, i_veiculo char(8) default null)
returns table (
	veiculo char(8),
	n_of_alarmes bigint
) as 
$$
	begin
		return query select 
				v.matricula as veiculo, 
				count(*) as n_of_alarmes
			from
				alarme a, registo r, veiculo v
			where
				a.id_registo = r.id and
				a.id_veiculo = v.matricula and 
				((i_veiculo is null) or i_veiculo = v.matricula) and -- License Plate Match 
				extract (year from r.marca_temporal) = i_year -- Year match
			group by
				v.matricula, (extract (year from r.marca_temporal))::int
			order by
				count(v.matricula) desc;
	end;
$$ language plpgsql;

/*
drop function count_alarmes;

create or replace function count_alarmes(i_year int, i_veiculo char(8) default null)
returns int as 
$$
	declare
		n_of_alarmes bigint;
	begin
		select
			count(*) into n_of_alarmes
		from
			alarme a, registo r, veiculo v
		where
			a.id_registo = r.id and
			a.id_veiculo = v.matricula and
			((i_veiculo is null) or i_veiculo = v.matricula) and -- License Plate Match 
			extract (year from r.marca_temporal) = i_year; -- Year match
		
		if n_of_alarmes is null then
			return 0;
		else 
			return n_of_alarmes;
		end if;
	end;
$$ language plpgsql;
*/
/* ------------ TESTS ------------ */

/* Count Alarmes returning table */

-- From existing car with alarms
select * from count_alarmes_returns_table(2016, 'JD-23-09');

-- From existing car with no alarms
select * from count_alarmes_returns_table(2016, '03-83-AA');

-- All the cars with 'alarmes' of 'registos' from 2016
-- Note: 74-FT-18 has 1 alarm from 2016 + 1 alarm from 2022
select * from count_alarmes_returns_table(2016); 
select * from count_alarmes_returns_table(2016, null);

-- All the cars with 'alarmes' from 2017 (None)
select * from count_alarmes_returns_table(2017);

/* Count Alarmes */
-- From existing car with alarms
select * from count_alarmes(2016, 'JD-23-09');

-- From existing car with no alarms
select * from count_alarmes(2016, '03-83-AA');

-- All the cars with 'alarmes' of 'registos' from 2016
select * from count_alarmes(2016);
select * from count_alarmes(2016, null);

-- All the cars with 'alarmes' from 2017 (None)
select * from count_alarmes(2017);

