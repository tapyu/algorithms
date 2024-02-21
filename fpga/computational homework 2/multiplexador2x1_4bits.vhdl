-- Prática 2
--
-- Entry: i0, i1 and s
-- Out: d
--
--
-- By: Edson Junior
-- Date: Feb/2018
--

ENTITY multiplexador2x1_4bits IS
	PORT( a, b : IN bit_vector(3 downto 0);
	      s : IN BIT;
	      y : OUT bit_vector(3 downto 0));	
end multiplexador2x1_4bits;


ARCHITECTURE hardware OF multiplexador2x1_4bits IS
	COMPONENT multiplexador2x1_1bit
		PORT( 		i0	:	IN BIT;
      		      i1	:	IN BIT;
	      	      s 	:	IN BIT;
	      	      d		:	OUT BIT);
	END COMPONENT;

BEGIN
	y0: multiplexador2x1_1bit PORT MAP(a(0), b(0), s, y(0));
	y1: multiplexador2x1_1bit PORT MAP(a(1), b(1), s, y(1));
  	y2: multiplexador2x1_1bit PORT MAP(a(2), b(2), s, y(2));
   y3: multiplexador2x1_1bit PORT MAP(a(3), b(3), s, y(3));

END hardware;
	
