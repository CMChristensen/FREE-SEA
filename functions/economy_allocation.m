function [consumption,frac_enga,frac_invga] = ...
    economy_allocation(ieccr,inv_d,gross_out,iudc,sp,dvi)
% 
% Inputs:
%   ieccr     ==> indicated energy capital completion rate (vector)
%   inv_d     ==> desired investment
%   gross_out ==> total production
%   iudc      ==> indicated unit distribution cost (vector)
%   sp        ==> scheduled production (vector)
%   dvi       ==> desired variable input (vector)
%   
% Outputs:
%   consumption ==> goods consumption
%   frac_enga   ==> fraction of energy goods available
%   frac_invga  ==> fraction of investment goods available
% 

invreq_en = sum(ieccr); % total goods required for eneryg investment
invreq_tot = inv_d + invreq_en; % total investment required for goods and energy producing sectors

iedc = iudc.*sp; %$/yr Goods required for energy distribution, by source.
iedc_tot = sum(iedc); % indicated total energy distribution cost: total goods required for energy distribution
ievc_tot = sum(dvi); % indicated total energy variable cost: Total goods required for variable costs of energy production.
itcep = iedc_tot + ievc_tot; %$/yr Total goods required for energy production and distribution.
en_netout = max(0,gross_out - itcep); %$/yr Goods production less climate damages and energy production / distribution expenses. Available for consumption and investment.

consumption = max(0,en_netout - invreq_tot);
frac_enga = min(1,gross_out/itcep); % Availability of goods for energy sector investment and production.
frac_invga = min(1,en_netout/invreg_tot); % Fraction of desired investment goods available.