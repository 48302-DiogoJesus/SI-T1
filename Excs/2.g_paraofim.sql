/*
 * 2.g)
 * Criar um gatilho que permita analisar o registo processado, aquando da sua criação. e que
 * gere o respetivo alarme caso esteja fora de qualquer uma das suas zonas verdes. Se não
 * existirem zonas verdes ou se o equipamento estiver em pausa de alarmes não gera alarme.
 * Para a realização do gatilho, deverá usar a função zonaVerdeValida que recebe as
 * coordenadas e o raio de uma zona verde e as coordenadas do registo em processamento e
 * retorne true se as coordenadas do registo a ser processado se encontrarem dentro da zona
 * verde e false caso contrário. Para teste implemente uma versão da função zonaVerdeValida
 * que retorna true quando a o arredondamento da coordenada da latitude do registo for par e
 * false quando for impar;
 * */