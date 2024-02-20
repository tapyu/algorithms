-- Prática 3
--
-- Entry: i0, i1, s
-- Out: d
--
--
-- By: Rubem Pacelli
-- Date: Mar/2018
-- multiplexador4x1_1bit


ENTITY multiplexador4x1x1bit IS
	PORT( i	:	IN bit_vector(3 downto 0);
			s	:	IN bit_vector(1 downto 0);
	      d	:	OUT BIT);
end multiplexador4x1x1bit;

ARCHITECTURE hardware OF multiplexador4x1x1bit IS
BEGIN
	
	PROCESS(s, i)
	BEGIN
		CASE s IS
			WHEN "00" => d <= i(0); -- seleção da entrada 0
			WHEN "01" => d <= i(1); -- seleção da entrada 1
			WHEN "10" => d <= i(2); -- seleção da entrada 2  
			WHEN "11" => d <= i(3); -- seleção da entrada 3
		END CASE;
		
	END PROCESS;
	

END hardware;
	