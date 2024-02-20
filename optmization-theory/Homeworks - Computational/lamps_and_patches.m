clc;
close all;

showFig = true;
numLamps = 4;
numPatches = 5;
maxPwr = 1;
desiredillum = 0.01;

% Code for random generation
% rng(20222);
% lampPos = repmat([0.5 6], numLamps, 1) + 3*rand(numLamps, 2);
% lampPos(1:end, 1) = cumsum(lampPos(:, 1));
% patchPos = repmat([0 2], numPatches+1, 1) + 2*rand(numPatches+1, 2);
% patchPos(1:end, 1) = cumsum(patchPos(:, 1));
% lampPos(:, 1) = lampPos(:, 1) + patchPos(1, 1);

lampPos = [0.6838 7.8976; 3.1835 7.0690; 5.5327 6.6806; 6.1963 6.5203];
patchPos = [0.0762 2.8621; 1.4506 2.8733; 2.5122 2.5864; 4.2246 3.5846; 5.3512 2.1960; 6.3013 2.9838];

lampPos = complex(lampPos(:,1), lampPos(:,2));
patchPos = complex(patchPos(:,1), patchPos(:,2));
patchCenter = (patchPos(1:end-1) + patchPos(2:end))/2;
patchNorm = patchPos(2:end) - patchPos(1:end-1);
minPatchLength = min(abs(patchNorm))/2;
for p = 1:length(patchNorm)
    n = null([real(patchNorm(p)) imag(patchNorm(p))]);
    patchNorm(p) = minPatchLength*complex(n(1), n(2));
end

if showFig == true
    plot(lampPos, 'ro', 'MarkerFaceColor', 'auto');
    hold on;
    plot(patchPos, 'bo-', 'MarkerFaceColor', 'auto');
    plot(patchCenter, 'mx', 'MarkerFaceColor', 'auto');
    plot(patchNorm + patchCenter, 'kd', 'MarkerFaceColor', 'auto');
    for i=1:length(patchCenter),
        plot([patchCenter(i) patchNorm(i) + patchCenter(i)], 'k--', 'MarkerFaceColor', 'auto');
    end
    axis equal;
end
ylabel('y');
xlabel('x');

radDist = zeros(length(patchCenter), length(lampPos));
angShift = zeros(length(patchCenter), length(lampPos));
for i = 1:length(patchCenter)
    for j = 1:length(lampPos)
        radDist(i, j) = abs(patchCenter(i) - lampPos(j));
        angShift(i, j) = angle(lampPos(j)-patchCenter(i))-angle(patchNorm(i));
    end
end

% a_{k,j}
illumCoeff = radDist.^(-2).*max(cos(angShift), 0);