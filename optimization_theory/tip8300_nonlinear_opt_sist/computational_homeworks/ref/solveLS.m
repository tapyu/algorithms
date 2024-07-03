function [illumValues, pwrValues, costValue] = solveLS(illumCoeff, desiredillum, maxPwr)
disp('*******************************');
disp('Least squares solution');
disp('*******************************');

numPwrValues = size(illumCoeff, 2);
numPatches = size(illumCoeff, 1);

options = optimset('lsqlin');
options = optimset(options,'Display','iter','TolX',1e-9,'TolCon',1e-9,'MaxIter',1e4,'MaxFunEvals',1e4);
[pwrValues, fval, ~, exitflag, output] = lsqlin( ...
    illumCoeff, ... % C matrix
    ones(numPatches, 1)*desiredillum, ... % d vector
    [], [], ... % Inequality constraints
    [], [], ... % Equality constraints
    zeros(numPwrValues, 1), ... % Lower bounds
    ones(numPwrValues, 1)*maxPwr, ... % Upper bounds
    ones(numPwrValues, 1)*maxPwr/numPwrValues, ... % x0
    options); % Optimization options

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
