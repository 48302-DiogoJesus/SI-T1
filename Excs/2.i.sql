/*
 * 2.i)
 * Criar uma vista, que liste todos os alarmes. A vista deve apresentar a matrícula do veículo, o
 * nome do condutor, as coordenadas e a data/hora do alarme;
 * */

drop view if exists list_all_alarmes;

create or replace view list_all_alarmes as (
    select 
        v.matricula, v.nome_condutor, r.latitude, r.longitude,
        r.marca_temporal
    from
        alarme as a inner join veiculo as v on a.id_veiculo = v.matricula
                    inner join registo as r    on a.id_registo = r.id
);
