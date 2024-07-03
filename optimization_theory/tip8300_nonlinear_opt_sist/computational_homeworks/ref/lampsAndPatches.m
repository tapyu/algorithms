clc;
close all;

showFig = true;
numLamps = 4;
numPatches = 5;
maxPwr = 1;
desiredillum = 0.01;

% % Comment out the line below if not using matlab
% rng('shuffle');
% % Comment out the line below if not using octave
% % rand('seed', 'reset');
% lampPos = repmat([0.5 6], numLamps, 1) + 2*rand(numLamps, 2);
% lampPos(1:end, 1) = cumsum(lampPos(:, 1));
% patchPos = repmat([0 2], numPatches+1, 1) + 2*rand(numPatches+1, 2);
% patchPos(1:end, 1) = cumsum(patchPos(:, 1));

lampPos = [2.3119 6.3554; 3.2401 6.9284; 5.5310 6.5910; 6.8457 7.8612];

patchPos = [1.3286 2.2132; 2.8402 2.4720; 3.4158 2.4140; 4.0182 3.1009; 5.1015 2.3155; 6.3036 3.4580];

lampPos = complex(lampPos(:,1), lampPos(:,2));
patchPos = complex(patchPos(:,1), patchPos(:,2));
patchCenter = (patchPos(1:end-1) + patchPos(2:end))/2;
patchNorm = patchPos(2:end) - patchPos(1:end-1);
for p = 1:length(patchNorm)
    n = null([real(patchNorm(p)) imag(patchNorm(p))]);
    patchNorm(p) = complex(n(1), n(2));
end

if showFig == true
    plot(lampPos, 'ro', 'MarkerFaceColor', 'auto');
    hold on;
    plot(patchPos, 'bo-', 'MarkerFaceColor', 'auto');
    plot(patchCenter, 'mx', 'MarkerFaceColor', 'auto');
    plot(patchNorm + patchCenter, 'kd', 'MarkerFaceColor', 'auto');
    axis auto;
end

radDist = zeros(length(patchCenter), length(lampPos));
angShift = zeros(length(patchCenter), length(lampPos));
for i = 1:length(patchCenter)
    for j = 1:length(lampPos)
        radDist(i, j) = abs(patchCenter(i) - lampPos(j));
        angShift(i, j) = angle(lampPos(j)-patchCenter(i))-angle(patchNorm(i));
    end
end

illumCoeff = radDist.^(-2).*max(cos(angShift), 0);

[illumValuesOpt, pwrValuesOpt, costValueOpt] = solveOpt(illumCoeff, desiredillum, maxPwr);
[illumValuesUniform, pwrValuesUniform, costValueUniform] = solveUniform(illumCoeff, desiredillum, maxPwr);
[illumValuesLS, pwrValuesLS, costValueLS] = solveLS(illumCoeff, desiredillum, maxPwr);
[illumValuesLP, pwrValuesLP, costValueLP, tLP] = solveLP(illumCoeff, desiredillum, maxPwr);
[illumValuesWLS, pwrValuesWLS, costValueWLS] = solveWLS(illumCoeff, desiredillum, maxPwr);
