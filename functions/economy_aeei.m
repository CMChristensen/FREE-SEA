function [aeei,aeei_em_dot] = economy_aeei(t,capital,aeei_em,rate_inv,rate_retro)
% 
% Inputs:
%   capital    ==> capital
%   aeei_em    ==> embodied AEEI
%   rate_inv   ==> investment rate
%   rate_retro ==> retrofit rate
% 
% Outputs:
%   aeei        ==> embidied AEEI (efficiency gain decreases with time)
%   aeei_em_dot ==> time rate of change of embodied AEEI
% 

% constants
Asymptotic_AEEI = 0.1; % ultimate possible energy efficiency improvement level
Frac_Auton_Energy_Eff_Improvement_Rate = 0.005; %1/yr autonomous energy efficiency rate
Capital_Lifetime = 15; % yr lifetime of goods producing capital

aeei = Asymptotic_AEEI + (1 - Asymptotic_AEEI).*exp(-Frac_Auton_Energy_Eff_Improvement_Rate.*t);

AEEI_Install_Rate = rate_inv*aeei; %$/yr
AEEI_Retrofit_Rate = capital*rate_retro*aeei-Embodied_AEEI*rate_retro; %$/yr
AEEI_Discard_Rate = aeei_em/Capital_Lifetime; % $/yr

aeei_em_dot = AEEI_Install_Rate + AEEI_Retrofit_Rate - AEEI_Discard_Rate; % initial condition? --> Auton_Energy_Eff_Index * Capital