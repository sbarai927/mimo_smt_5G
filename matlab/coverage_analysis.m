% Calculates base station down-tilt angle and inner/outer cell coverage radius
clear; clc;

%--- Parameters ---
h_T = 30;          % Transmitter height (m)
h_R = 1.5;         % Receiver height (m)
D   = 200;         % Desired coverage radius on ground (m)
QBW = 10;          % Antenna 3-dB beamwidth (deg)

%--- Calculations ---n
half_bw = deg2rad(QBW/2);
ADT = atan((h_T - h_R) / D);        % Down-tilt angle in radians
ADT_deg = rad2deg(ADT);

R_outer = (h_T - h_R) / tan(ADT - half_bw);
R_inner = (h_T - h_R) / tan(ADT + half_bw);

%--- Output ---
fprintf('Down-tilt angle (ADT): %.4f°\n', ADT_deg);
fprintf('Outer coverage radius: %.2f m\n', R_outer);
fprintf('Inner coverage radius: %.2f m\n', R_inner);

theta = linspace(0,2*pi,400);
plot((R_outer/1e3).*cos(theta),(R_outer/1e3).*sin(theta),'b--');  hold on;
plot((R_inner/1e3).*cos(theta),(R_inner/1e3).*sin(theta),'r');
axis equal; grid on;
xlabel('km'); ylabel('km');
title('Coverage Footprint (outer = blue, inner = red)');
legend('Outer','Inner','Location','SouthOutside');
exportgraphics(gcf, fullfile('..','figures','coverage_annulus.png'), 'Resolution',300);