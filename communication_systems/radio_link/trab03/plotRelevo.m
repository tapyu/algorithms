function  [hf, hc]  = plotRelevo(d, h)

r = 6371;
hc = zeros(3,length(d));
hf = zeros(3,length(d));
hfmax = 0;
k = [500e3 4/3 2/3];

for m = 1:3
    for i = 1:length(d)
        hc(m, i) = d(i)*d(end-i+1)*1e3 / (2*k(m)*r);
        hf(m, i) = hc(m, i)+h(i);
    end
    
    for i = 1:length(d)
        if hf(m, i) > hfmax
            hfmax = hf(m, i);
        end
    end
end

for p = 1:3
    plot(d, hf(p,:));
    hold on;
    axis([d(1) d(end) 0 60])
end

legend ('k -> infinito', 'k = 4/3', 'k = 2/3');

end