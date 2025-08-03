timestamp = datestr(now,'yyyymmdd_HHMMSS');
logName   = fullfile('results', ['sleep_mode_power_' timestamp '.log']);
if ~exist('results','dir');  mkdir results;  end
diary(logName);          % start logging
diary on

% Simulates a point-to-point MIMO-OFDM beamforming pattern
clear; clc;

%--- Parameters ---
N = 8;                         % Number of array elements
d = 0.5;                       % Element spacing (λ)
steer_angle = 30;              % Desired steering angle (deg)
lambda = 0.1;                  % Wavelength (m)

%--- Array Factor Computation ---
angles = -90:0.1:90;
angles_rad = deg2rad(angles);
beta = 2*pi/lambda;
AF = zeros(size(angles_rad));
for k = 0:N-1
    phase_shift = beta * d * k * (sin(angles_rad) - sin(deg2rad(steer_angle)));
    AF = AF + exp(1j * phase_shift);
end
AF_mag = abs(AF) / N;
AF_dB = 20*log10(AF_mag + 1e-6);

%--- Plot ---
figure;
plot(angles, AF_dB, 'LineWidth',1.5);
xlabel('Angle (deg)'); ylabel('Normalized Gain (dB)');
title(sprintf('Beamforming Pattern: %d-element Array Steered to %d°', N, steer_angle));
grid on;

diary off