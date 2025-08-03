timestamp = datestr(now,'yyyymmdd_HHMMSS');
logName   = fullfile('results', ['sleep_mode_power_' timestamp '.log']);
if ~exist('results','dir');  mkdir results;  end
diary(logName);          % start logging
diary on

% Simplified hybrid PV-biomass-grid power allocation for 5G base station
clear; clc;

hours = 0:23;
load_profile = [4 4 4 5 5 6 8 10 11 11 11 10 9 8 7 6 5 5 5 5 5 4 4 4];
solar_profile = [0 0 0 0 0 1 3 5 6 6 5 4 3 2 1 0 0 0 0 0 0 0 0 0];

biomass_max = 5;
remain = max(load_profile - solar_profile, 0);
biomass_profile = min(remain, biomass_max);
grid_profile = max(load_profile - solar_profile - biomass_profile, 0);

energy_load    = sum(load_profile);
energy_solar   = sum(solar_profile);
energy_biomass = sum(biomass_profile);
energy_grid    = sum(grid_profile);

fprintf('Daily Load = %.1f kWh\n', energy_load);
fprintf('Solar   = %.1f kWh\n', energy_solar);
fprintf('Biomass = %.1f kWh\n', energy_biomass);
fprintf('Grid    = %.1f kWh\n', energy_grid);

%--- Plot ---
figure;
area(hours, [solar_profile; biomass_profile; grid_profile]');
hold on; plot(hours, load_profile, 'k-', 'LineWidth',1.5);
xlabel('Hour of Day'); ylabel('Power (kW)');
title('Hybrid Power Supply Allocation vs Load');
legend({'Solar','Biomass','Grid','Load'}, 'Location','NorthWest');

diary off