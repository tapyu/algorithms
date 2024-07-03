function [illumValues, pwrValues, costValue] = solveUniform(illumCoeff, desiredillum, maxPwr)
disp('*******************************');
disp('Uniform approximation');
disp('*******************************');

numPwrValues = size(illumCoeff, 2);

options = optimset('fminsearch');
options = optimset(options,'Display','iter','TolX',1e-9,'MaxIter',1e4,'MaxFunEvals',1e4);
[pwrValue, fval, exitflag, output] = fminsearch( ...
    @(pwrValue)costFunction(pwrValue, illumCoeff, desiredillum, maxPwr), ... % Cost function
    0, ... % x0
    options); % Optimization options


pwrValues = ones(numPwrValues, 1)*pwrValue;
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

function [c] = costFunction(pwrValue, illumCoeff, desiredillum, maxPwr)
pwrValue = max(0, min(pwrValue, maxPwr));

numPwrValues = size(illumCoeff, 2);

pwrValues = ones(numPwrValues, 1)*pwrValue;
illumValues = illumCoeff*pwrValues;
c = max(abs(log(illumValues/desiredillum)));

end