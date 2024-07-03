function [illumValues, pwrValues, costValue] = solveWLS(illumCoeff, desiredIllum, maxPwr)
disp('*******************************');
disp('Weighted least squares solution');
disp('*******************************');

numPwrValues = size(illumCoeff, 2);
numPatches = size(illumCoeff, 1);
W = sqrt(diag([1 1 1 1]));

options = optimset('lsqlin');
options = optimset(options,'Algorithm', 'active-set', 'Display','iter','TolX',1e-9,'TolCon',1e-9,'MaxIter',1e4,'MaxFunEvals',1e4);
C = blkdiag(illumCoeff, W);
d = [repmat(desiredIllum, numPatches, 1); (maxPwr/2)*W*ones(numPwrValues, 1)];
Aeq = [eye(numPwrValues) -eye(numPwrValues)];
beq = zeros(numPwrValues, 1);
[pwrValues, fval, ~, exitflag, output] = lsqlin( ...
    C, ... % C matrix
    d, ... % d vector
    [], [], ... % Inequality constraints
    Aeq, beq, ... % Equality constraints
    zeros(2*numPwrValues, 1), ... % Lower bounds
    [], ... % Upper bounds
    ones(2*numPwrValues, 1)*(maxPwr/numPwrValues), ... % x0
    options); % Optimization options

pwrValues = pwrValues(1:end/2);
illumValues = illumCoeff*pwrValues;
disp('Objective function value:')
disp(fval);
disp('Exit flag:')
disp(exitflag);
disp('Output:')
disp(output)
disp('Original cost:')
costValue = max(abs(log(illumValues/desiredIllum)));
disp(costValue);
disp('*******************************');

end
