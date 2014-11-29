function [capital_dot] = economy_capital(capital,tcap,tcc,frac_invga,r_int,...
    LR_mpec,util,capital_ref,hogr,...
    cea_ref,LR_cs,cesc,naer,aep_ref)
% ** this function employs functions that require interpolation during run
% time, need to fix this! **
% 
% Inputs:
%   capital     ==> capital
%   tcap        ==> capital lifetime
%   tcc         ==> capital correction time
%   frac_invga  ==> fraction of investment goods available
%   r_int       ==> interest rate
%   LR_mpec     ==> LR mariginal productivity of effective capital
%   util        ==> utilization
%   capital_ref ==> reference capital
%   hogr        ==> historical output growth rate
% 
%   cea_ref ==> reference capital energy aggregate
%   LR_cs ==> LR capital share
%   cesc  ==> capital energy substance coefficient
%   naer  ==> normal aggregate energy requirement
%   aep_ref ==> referenece aggregate energy production
% 
% Outputs:
%   capital_dot ==> rate of change of capital
% 

r_dis = capital / tcap; % $/yr capital discarded rate


% Percentage of relative return to capital
fact_cap = capital/capital_ref;
mcec = cea_ref*LR_cs*fact_cap.^cesc ...
    + LR_es*(naer/aep_ref).^(1.0 - cesc)*LR_cs*fact_cap.^(cesc-1.0)/capital_ref; % Marginal output of capital-energy bundle per unit capital input.

mpc = LR_mpec * mcec * util; % $/yr/$ Marginal productivity of capital. Utilization is used.
capital_cost = r_int + 1 / tcap; % 1/yr Cost of capital for investment decision.

prrc = mpc./capital_cost; % Ratio of marginal productivity to cost of capital. A smoothing function is used here.

rtc = 1.; % Coefficient of effect of relative return on desired capital.

eor = prrc.^rtc; % effect of return
capital_d = capital*eor; % desired capital
capital_corr = (capital_d - capital)./tcc; % capital correction
%LR_eogr = TREND(gross_out,LR_Output_Trend_Time, Hist_Output_Growth_Rate); % this function requires interpolation during run
%time!!
LR_eogr = hogr; % for now, have the rate be the same as the historical rate
dcg = capital * LR_eogr; % $/yr desired capital growth

dcor = capital_corr + r_dis + dcg; % $/yr desired capital order rate

inv_d = max(0,dcor); % $/yr desired investment
% inv_d = rdis;  % switching between different capital rates
% inv_d = r_world; % world investment

r_inv = inv_d * frac_invga; % $/yr capital investment rate


capital_dot = r_inv - r_dis; % $/yr