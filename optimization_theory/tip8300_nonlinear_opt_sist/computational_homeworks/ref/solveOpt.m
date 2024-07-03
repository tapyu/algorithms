function [illumValues, pwrValues, costValue] = solveOpt(illumCoeff, desiredillum, maxPwr)
disp('*******************************');
disp('Optimum solution');
disp('*******************************');

numPwrValues = size(illumCoeff, 2);

options = optimoptions('fmincon');
options = optimoptions(options,'Algorithm','sqp','Display','iter','TolX',1e-9,'TolCon',1e-9,'MaxIter',1e4,'MaxFunEvals',1e4);
[pwrValues, fval, exitflag, output] = fmincon( ...
    @(pwrValues)costFunction(pwrValues, illumCoeff, desiredillum), ... % Cost function
    ones(numPwrValues, 1)*maxPwr/numPwrValues, ... % x0
    [], [], ... % Equality constraints
    [], [], ... % Inequality constraints
    zeros(numPwrValues, 1), ... % Lower bounds
    ones(numPwrValues, 1)*maxPwr, ... % Upper bounds
    [], ... % Nonlinear constraints
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

function [c] = costFunction(pwrValues, illumCoeff, desiredillum)
illumValues = illumCoeff*pwrValues;
c = max(max(illumValues/desiredillum, desiredillum./illumValues));

end