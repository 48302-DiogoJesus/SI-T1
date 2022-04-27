/*
 * 2.e)
 * Criar uma fun��o que devolve o total de alarmes para um determinado ano e ve�culo
 * passados como par�metros; caso a matr�cula do ve�culo seja vazia deve devolver as contagens
 * de alarmes para todos os ve�culos nesse ano
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

