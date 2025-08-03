% Compares MIMO vs. SISO antenna gain and efficiency
clear; clc;

P_in = 8000;           % Input power (W)
G_MIMO = 10.85;        % Gain (MIMO, dBi)
G_SISO = 9.25;         % Gain (SISO, dBi)
eff_MIMO = 0.9375;    % Efficiency (MIMO)
eff_SISO = 0.75;      % Efficiency (SISO)

P_rad_MIMO = eff_MIMO * P_in;
P_rad_SISO = eff_SISO * P_in;

fprintf('MIMO: Gain=%.2f dBi, Eff=%.2f%%, Radiated=%.1f W\n', G_MIMO, eff_MIMO*100, P_rad_MIMO);
fprintf('SISO: Gain=%.2f dBi, Eff=%.2f%%, Radiated=%.1f W\n', G_SISO, eff_SISO*100, P_rad_SISO);

figure;
yyaxis left;  bar([1 2]-0.15,[G_MIMO G_SISO]); ylabel('Gain (dBi)');
yyaxis right; bar([1 2]+0.15,[eff_MIMO eff_SISO]*100); ylabel('Efficiency (%)');
set(gca,'XTick',[1 2],'XTickLabel',{'MIMO','SISO'});
title('Massive-MIMO vs SISO: Gain & Efficiency');
legend({'Gain','Efficiency'},'Location','best');
exportgraphics(gcf, fullfile('..','figures','gain_efficiency.png'), 'Resolution',300);
