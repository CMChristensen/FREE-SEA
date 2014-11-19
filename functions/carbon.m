function [CO2a_dot, CO2do_dot, CO2m_dot, CO2bio_dot, CO2h_dot] = ...
    carbon(CO2e,CO2do,CO2m,CO2pind,CO2bio,CO2h,CO2a)
% 
% Inputs:
%   CO2e      ==> total Carbon emissions (anthropogenic)
%   CO2do     ==> Carbon in each layer of the deep ocean (vector)
%   CO2m      ==> Carbon in the mixing layer
%   CO2pind   ==> Preindustiral CO2
%   CO2bio    ==> Biomass CO2
%   CO2a      ==> CO2 in the atmosphere
% 
% Outputs:
%   CO2a_dot   ==> time rate of change of CO2 in the atmosphere
%   CO2do_dot  ==> time rate of change of CO2 in the deep ocean (vector)
%   CO2m_dot   ==> time rate of change of CO2 in the mixing layer
%   CO2bio_dot ==> time rate of change of CO2 in biomass
%   CO2h_dot   ==> time rate of change of CO2 in humus 
%

% variables
Mixing_Time = 9.5; % yr mixing time from atmosphere to ocean
Mixed_Depth = 75; % m
Eddy_Diff_Coeff = 4000; % m^2/yr eddy diffusion coefficient
Preind_CO2_in_Mixed_Layer = 7.678e+011; % tons of Carbon preindustrial CO2 amount
Ref_Buff_CO2 = 7.6e11; % tons of CO2 in the atmosphere at normal buffer
Ref_Buffer_Factor = 10; % normal buffer factor
Buff_CO2_Coeff = 4.05; % buffer factor coefficient
Init_NPP = 6.0e10; % tons of CO2/yr initial net CO2 production
Biostim_Coeff = 0.4; % Coefficient for response of primary production to CO2 concentration
Humification_Fraction = 0.428; % fraction of Carbon to humus from biomass
Biomass_Res_Time = 10.6; %yr average resident time for biomass
Humus_Res_Time = 27.8; %yr average resident time for humus

h = [200*ones(1,5) 560*ones(1,5)]; % ocean layer thickness (set for ten layers)


% CO2 in the deep ocean
N = length(CO2do);
CO2do_dot = zeros(1,N);
CO2do_dot(1) = 2*Eddy_Diff_Coeff*(...
        ( CO2do(2)/h(2) - CO2do(1)/h(1) )/( h(2) - h(1) )...
        - ( CO2do(1)/h(1) - CO2m/Mixed_Depth )/( h(1) - Mixed_Depth ) );
CO2do_dot(N) = CO2do(N)/h(N);
for n = 2:N-1
    CO2do_dot(n) = 2*Eddy_Diff_Coeff*(...
        ( CO2do(n+1)/h(n+1) - CO2do(n)/h(n) )/( h(n+1) - h(n) )...
        - ( CO2do(n)/h(n) - CO2do(n-1)/h(n-1) )/( h(n) - h(n-1) ) );
end

% equations for mixing layer CO2
fb = Ref_Buffer_Factor + Buff_CO2_Coeff*log(CO2a/Ref_Buff_CO2); % buffer factor
CO2eq = Preind_CO2_in_Mixed_Layer * (CO2a/CO2pind).^(1./fb); % equilibrium CO2
flux_ao = (CO2eq - CO2m)/Mixing_Time; % CO2 flux from atmosphere to ocean
flux_d1 = 2*Eddy_Diff_Coeff*( CO2m/Mixed_Depth - CO2do(1)/h(1) )/( Mixed_Depth + h(1) ); % flux to ocean mix layer

CO2m_dot = flux_ao - flux_d1;

% equations for biomass CO2
flux_ab = Init_NPP * (1 + Biostim_Coeff*log(CO2a/CO2pind)); % flux from atmosphere to biomass
flux_ba = CO2bio/Biomass_Res_Time*(1.0 - Humification_Fraction); % flux from biomass to atmosphere
flux_bh = CO2bio/Biomass_Res_Time*Humification_Fraction; % flux from biomass to humus
flux_bah = CO2bio/Biomass_Res_Time; % flux_ba + flux_bh

CO2bio_dot = flux_ab - flux_bah;

% equations for humus CO2
flux_ha = CO2h/Humus_Res_Time;

CO2h_dot = flux_bh - flux_ha;

% CO2 in the atmosphere
CO2a_dot = CO2e + flux_ba + flux_ha - flux_ao - flux_ab;