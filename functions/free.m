% 
% Script for the FREE model
% 

% Initial conditions
Init_CO2_in_Atm = 6.576e+011; % tons of Carbon
Init_CO2_in_Biomass = 6.566e+011;
Init_CO2_in_Deep_Ocean = [2.054e+012, 2.051e+012, 2.05e+012,...
            2.049e+012, 2.048e+012, 5.734e+012, 5.733e+012, 5.733e+012,...
            5.733e+012, 5.733e+012];
Init_CO2_in_Humus = 7.259e+011;
Init_CO2_in_Mixed_Ocean = 7.712e+011;



%% Welfare section

DU = welfare(t);
