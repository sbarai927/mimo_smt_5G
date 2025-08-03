% Computes return loss and antenna impedance match
clear; clc;

%--- Example 1: Return loss from power ratio ---
Pin = 100;   % Input power (W)
Pr  = 25;    % Reflected power (W)
RL1 = 10*log10(Pin/Pr);
fprintf('Return Loss (power ratio): %.2f dB\n', RL1);

%--- Example 2: Return loss from impedance ---
Z0 = 50;           % Reference impedance (Ω)
Z_ant = 150;       % Antenna impedance (Ω)
Gamma = (Z_ant - Z0) / (Z_ant + Z0);
RL2 = -20*log10(abs(Gamma));
fprintf('Antenna Z = %.1f Ω, Return Loss = %.2f dB\n', Z_ant, RL2);

%--- Example 3: Impedance for target RL ---
target_RL = 15;    % (dB)
Gamma_req = 10^(-target_RL/20);
Z_high = Z0*(1 + Gamma_req)/(1 - Gamma_req);
Z_low  = Z0*(1 - Gamma_req)/(1 + Gamma_req);
fprintf('For RL=%.1f dB, Z ≈ %.1f Ω or %.1f Ω\n', target_RL, Z_high, Z_low);

figure;
bar([RL1 RL2]); set(gca,'XTickLabel',{'P-ratio','Z-mismatch'});
ylabel('Return Loss (dB)'); title('Return Loss Examples');
exportgraphics(gcf, fullfile('..','figures','return_loss_examples.png'), 'Resolution',300);

