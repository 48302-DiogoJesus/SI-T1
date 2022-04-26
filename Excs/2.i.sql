/*
 * 2.i)
 * Criar uma vista, que liste todos os alarmes. A vista deve apresentar a matrícula do veículo, o
 * nome do condutor, as coordenadas e a data/hora do alarme;
 * */

drop view list_all_alarmes;

create or replace view list_all_alarmes as (
	select 
		v.matricula, v.nome_condutor, concat(r.latitude, ', ', r.longitude) as coordenadas,
		r.marca_temporal::date as data,
		r.marca_temporal::time as hora 
	from
		alarme as a inner join veiculo as v on a.id_veiculo = v.matricula
					inner join registo as r	on a.id_registo = r.id
);