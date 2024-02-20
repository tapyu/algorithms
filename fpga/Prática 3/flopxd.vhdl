-- Prática 3
--
-- Entry: d, clk, rs
-- Out: q
--
--
-- By: Rubem Pacelli
-- Date: Mar/2018
-- Flip Flop D



ENTITY flopxd IS
	PORT (d, clk, rst	:	IN	BIT;
			q			:	OUT	BIT);
END flopxd;

ARCHITECTURE comportamento OF flopxd IS
BEGIN
		
	PROCESS(clk, d)
	BEGIN
		IF (rst = '0') THEN
			IF	(clk'EVENT AND clk = '1')	THEN -- se ocorrer um evento de borda de subida
			q <= d;
			END IF;
		ELSE
		q <= '0';
		END IF;
	END PROCESS;

END comportamento;