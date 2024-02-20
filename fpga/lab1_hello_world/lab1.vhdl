-- Teste inicial usando porta lógica
-- a -> SW9 -> PIN_D2, b -> SW8 -> PIN_E4: entry
-- y -> LEDG9 -> PIN_B1: saída
-- FUNÇÃO NAND
--
--
--02/18


-- declaração de bibliotecas e pacotes

ENTITY lab1 IS
	
	PORT (a,b	:	IN		BIT;
			y		:	OUT	BIT);

END lab1;

ARCHITECTURE hardware OF lab1 IS

-- declaração de variável, sinais, etc

BEGIN
	
	y<= a NAND b;


END hardware;