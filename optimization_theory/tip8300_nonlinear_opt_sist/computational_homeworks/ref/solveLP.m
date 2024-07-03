function [illumValues, pwrValues, costValue, t] = solveLP(illumCoeff, desiredillum, maxPwr)
disp('*******************************');
disp('Linear program solution');
disp('*******************************');

numPwrValues = size(illumCoeff, 2);
numPatches = size(illumCoeff, 1);
delta = 0;

options = optimoptions('linprog');
options = optimoptions(options,'Display','iter','TolCon',1e-9,'MaxIter',1e4);
[pwrValues, fval, exitflag, output] = linprog( ...
    [zeros(numPwrValues, 1); 1], ... % Cost vector
    [[illumCoeff -ones(numPatches, 1)]; [-illumCoeff -ones(numPatches, 1)]], ... % Inequality constraints
    [repmat((1+delta)*desiredillum, numPatches, 1); repmat((-1+delta)*desiredillum, numPatches, 1)], ... % Inequality constraints
    [], [], ... % Equality constraints
    zeros(numPwrValues+1, 1), ... % Lower bounds
    [ones(numPwrValues, 1)*maxPwr; Inf], ... % Upper bounds
    [ones(numPwrValues, 1)*maxPwr/numPwrValues; 0], ... % x0
    options); % Optimization options

t = pwrValues(end);
pwrValues = pwrValues(1:end-1);
illumValues = illumCoeff*pwrValues;
disp('Objective function value:')
disp(fval);
disp('Exit flag:')
disp(exitflag);
disp('Output:')
disp(output)
disp('Original cost:')
costValue = max(abs(log(illumValues/desiredillum)));
disp(costValue);
disp('*******************************');

end
