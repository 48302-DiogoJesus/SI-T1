/*
 * 2.g)
 * Criar um gatilho que permita analisar o registo processado, aquando da sua cria��o. e que
 * gere o respetivo alarme caso esteja fora de qualquer uma das suas zonas verdes. Se n�o
 * existirem zonas verdes ou se o equipamento estiver em pausa de alarmes n�o gera alarme.
 * Para a realiza��o do gatilho, dever� usar a fun��o zonaVerdeValida que recebe as
 * coordenadas e o raio de uma zona verde e as coordenadas do registo em processamento e
 * retorne true se as coordenadas do registo a ser processado se encontrarem dentro da zona
 * verde e false caso contr�rio. Para teste implemente uma vers�o da fun��o zonaVerdeValida
 * que retorna true quando a o arredondamento da coordenada da latitude do registo for par e
 * false quando for impar;
 * */