-- Prática 3
--
-- Entry: i0, i1, s
-- Out: d
--
--
-- By: Rubem Pacelli
-- Date: Mar/2018
-- reg


-- s1\s0\ = mantém o valor atual
-- s1\s0  = carga paralela
-- s1s0\  = deslocamento a direita
-- s1s0   = deslocamento a esquerda


ENTITY registrador IS
	PORT (i	:	IN bit_vector(3 downto 0);
			shlin, shrin, clk	:	IN BIT;
			s	:	IN bit_vector(1 downto 0);
			q	:	BUFFER bit_vector(3 downto 0));
END registrador;

ARCHITECTURE comportamento OF registrador IS

	SIGNAL aux	:	bit_vector(3 downto 0);

	COMPONENT multiplexador4x1x1bit
			PORT( i	:	IN bit_vector(3 downto 0);
			s	:	IN bit_vector(1 downto 0);
	      d		:	OUT BIT);
	END COMPONENT;
		
	COMPONENT flopxd
			PORT (d, clk, rst	:	IN	BIT;
				q			:	OUT	BIT);
	END COMPONENT;

BEGIN

	aux0: multiplexador4x1x1bit PORT MAP(i(0) => q(0), i(1) => i(0), i(2) => q(1),   i(3) => shlin, s => s, d => aux(0));
	aux1: multiplexador4x1x1bit PORT MAP(i(0) => q(1), i(1) => i(1), i(2) => q(2),   i(3) => q(0),   s => s, d => aux(1));
	aux2: multiplexador4x1x1bit PORT MAP(i(0) => q(2), i(1) => i(2), i(2) => q(3),   i(3) => q(1),   s => s, d => aux(2));
	aux3: multiplexador4x1x1bit PORT MAP(i(0) => q(3), i(1) => i(3), i(2) => shrin, i(3) => q(2),   s => s, d => aux(3));
	
	q0: flopxd PORT MAP(d => aux(0), clk => clk, rst => '0', q => q(0));
	q1: flopxd PORT MAP(d => aux(1), clk => clk, rst => '0', q => q(1));
	q2: flopxd PORT MAP(d => aux(2), clk => clk, rst => '0', q => q(2));
	q3: flopxd PORT MAP(d => aux(3), clk => clk, rst => '0', q => q(3));


END comportamento;