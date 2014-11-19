function [Ta_dot,Tdo_dot] = climate(Ta,Tdo,CO2eff)
% 
% Inputs:
%   Ta      ==> atmosphere and upper ocean temperature
%   Tdo     ==> deep ocean temperature
%   CO2eff  ==> effective CO2 concentration
% Outputs:
%   Ta_dot  ==> rate of change of atmosphere temperature
%   Tdo_dot ==> rate of change of deep ocean temperature
% 

% Climate variables
CO2_Rad_Force_Coeff = 4.1;
Preindustrial_CO2 = 5.9e+011; % tons of CO2
Climate_Sensitivity = 2.908;
A_UO_Heat_Cap = 44.248; % W / K.m^2.yr atmospheric heat capacity
Heat_Capacity_Ratio = 0.44; % W / K.m^2
Heat_Trans_Coeff = 500; % yr amount of time for temperature to equlibrate for deep ocean

Climate_Feedback_Param = CO2_Rad_Force_Coeff/Climate_Sensitivity;
DO_Heat_Cap = Heat_Capacity_Ratio * Heat_Trans_Coeff; % deep ocean heat capacity

% Atmospheric temperature

Rf = CO2_Rad_Force_Coeff * log(CO2eff/Preindustrial_CO2); % radiative forcing
% extra radiative forcing can be added to the Rf term (+R_other)
Fc = Climate_Feedback_Param * Ta; % feedback cooling
Q = (Ta - Tdo) * DO_Heat_Cap / Heat_Trans_Coeff;

Ta_dot = (Rf - Fc - Q) / A_UO_Heat_Cap; % atmospheric and upper ocean temperature
Tdo_dot = (Ta - Tdo) / DO_Heat_Cap; % deep ocean temperature