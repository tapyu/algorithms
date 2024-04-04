pt = 10;
f = 1:1e3:25e9;
ht = 70;
hr = 100;
c = 3e8;
gt = 1;

lampda = c./f;

cte1 = pt*gt/pi;
cte2 = 2*pi*ht*hr./lampda;

d = 400e3;

s = (cte1/d^2) .* (sin(cte2./d)).^2;
sdB = 10.*log(s/1e3);

semilogx(f,sdB);