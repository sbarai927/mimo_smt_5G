% Models base station power consumption with/without sleep mode
clear; clc;

P_full = 11;                  % kW at full load
peak_hours = 9:17;            % Peak traffic hours (9 AM to 5 PM)
hours = 0:23;

usage_no_sleep = P_full * ones(size(hours));
usage_with_sleep = P_full * ones(size(hours));
usage_with_sleep(~ismember(hours, peak_hours)) = 0.6 * P_full;

energy_no_sleep   = sum(usage_no_sleep);
energy_with_sleep = sum(usage_with_sleep);
saving_pct = (energy_no_sleep - energy_with_sleep) / energy_no_sleep * 100;

fprintf('Daily Energy (no sleep)   = %.1f kWh\n', energy_no_sleep);
fprintf('Daily Energy (with sleep) = %.1f kWh\n', energy_with_sleep);
fprintf('Energy Savings = %.1f%%\n', saving_pct);

figure;

bar([1 2], [energy_no_sleep  energy_with_sleep], 0.4);
set(gca,'XTickLabel',{'Active 24 h','Sleep-enabled'},'FontSize',10);
ylabel('Daily Energy (kWh)');
title(sprintf('Energy Saving with Sleep Mode = %.1f %%', saving_pct));

grid on;

% Save it automatically into the repo's figures/ folder
if ~exist(fullfile('..','figures'),'dir'); mkdir(fullfile('..','figures')); end
exportgraphics(gcf, fullfile('..','figures','sleep_mode_energy.png'), 'Resolution',300);
