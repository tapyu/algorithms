clc;
clear;
close all;
more off;

% Angles
M = [];
t = -pi/3:pi/180:pi/3;
x1 = -2:0.01:2;

figure;
hold on;
for t = -pi/3:pi/180:pi/3;
  x2 = (1-cos(t)*x1)/cos(2*t);
  plot(x1, x2, 'r-');
  x2 = (-1-cos(t)*x1)/cos(2*t);
  plot(x1, x2, 'b-');
  axis([-2 2 -2 2]);
end  

figure;
M = [];
for t = -pi/3:pi/180:pi/3
  % disp(num2str(t/pi*180, '%d'));
  for x1 = -2:0.1:2
    for x2 = -2:0.1:2
      if abs(cos(t)*x1 + cos(2*t)*x2) >= 1
        M(end+1, :) = [x1 x2];
      end
    end
  end
end
plot(M(:,1), M(:,2), 'r.');
