function  []  = enlace_fresnel(d, h, f, ht, hr, k)

r = 6371;
hc = zeros(1,length(d));
hf = zeros(1,length(d));
fresnel_p = zeros(1,length(d));
fresnel_n = zeros(1,length(d));

hfmax = 0;

for i = 1:length(d)
    hc(i) = d(i)*d(end-i+1)*1e3 / (2*k*r);
    hf(i) = hc(i)+h(i);
end

l_visada = linspace(h(1)+ht, h(end)+hr, length(d));

plot(d, hf);
hold on;
plot(d, l_visada);

lambda = 3e8/f;

for i = 1:length(d)
    raio = sqrt( (lambda*d(i)*d(end-i+1)*1e3) / (d(i)+d(end-i+1)) );
    fresnel_p(i) = l_visada(i)+raio;
    fresnel_n(i) = l_visada(i)-raio;
end

plot(d, fresnel_p);
plot(d, fresnel_n);

for i = 1:length(d)
    if fresnel_p(i) > hfmax
        hfmax = fresnel_p(i);
    end
end
axis([d(1) d(end) 0 hfmax])

end
