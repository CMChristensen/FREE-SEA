function DU = welfare(t,Cpc,CDE)
% 
% Inputs:
%   Cpc ==> consumption per capita
%   CDE ==> climate damage effect
% Outputs:
%   DU  ==> discounted utility
% 

% Population variables
Pop_Gr_Rt_Decline_Rt = 0.02;
Initial_Pop_Growth_Rt = 0.01;
Initial_Population = 3.041e9; % initial population

% Population function
L = Initial_Population * exp(Initial_Pop_Growth_Rt / Pop_Gr_Rt_Decline_Rt *...
    (1 - exp(Pop_Gr_Rt_Decline_Rt * t))); % population growth --> this function saturates

% Discounted utility function variables
theta = 2.5; % Rate_of_Inequal_Aversion = 2.5;
rho = 0; % rate of time preference
omega = 1; % share of consumption
c0 = 1502; % refernce rate of consumption per capita

ECI = (Cpc/c0).^omega * CDE.^(1 - omega); % equivalent consumption index
U = (ECI.^(1.0 - theta) - 1) / (1.0 - theta); % utility

DU = exp(rho*t)*L*U; % requires an integration -> measure of social welfare
