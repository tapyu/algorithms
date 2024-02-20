-- Prática 2
--
-- Entry: i0, i1 and s
-- Out: d
--
--
-- By: Edson Junior
-- Date: Feb/2018
--

ENTITY multiplexador2x1_1bit IS
	PORT( i0	:	IN BIT;
	      i1	:	IN BIT;
	      s 	:	IN BIT;
	      d		:	OUT BIT);
end multiplexador2x1_1bit;


ARCHITECTURE hardware OF multiplexador2x1_1bit IS
	SIGNAL andI0, andI1 	:	 BIT;

BEGIN
	andI0 <= i0 AND (NOT s);
	andI1 <= i1 AND s;
	d <= andI0 OR andI1;

END hardware;
	
