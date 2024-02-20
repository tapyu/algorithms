pt = 10;
f = 2e9;
ht = 70;
hr = 100;
c = 3e8;
gt = 1;

lampda = c/f;

cte1 = pt*gt/pi;
cte2 = 2*pi*ht*hr/lampda;

sdBfor = zeros(1,1e6-9);

for d = 10:1000e3
    sdBfor(d-9) = (cte1/d^2) * (sin(cte2/d))^2;
    sdBfor(d-9) = 10*log(sdBfor(d-9)/1e3);
end

d = 10:1000e3;

semilogx(d,sdBfor);