-- Prática 1
--
-- Entry: p, c and h
-- Out: f
--
--
-- By: Rubem Pacelli
-- Date: Feb/2018
--

ENTITY pratica1 IS
	PORT( p	:	IN BIT;
			c	:	IN BIT;
			h	:	IN BIT;
			f	:	OUT BIT);
end pratica1;


ARCHITECTURE hardware OF pratica1 IS
	SIGNAL s1, s2	: BIT;

BEGIN
	s1 <= NOT c;
	s2 <= p OR h;
	f <= s1 AND s2;
END hardware;
	