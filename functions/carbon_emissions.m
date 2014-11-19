function [CO2e,em_iae,em_ic,em_ie,em_io] = ...
    carbon_emissions(capital,en_SRaggr,en_ptot,gross_out,nen_CO2e,enp,CO2c)
% 
% Inputs:
%   capital   ==> capital
%   en_SRaggr ==> SR aggregate energy
%   en_ptot   ==> total energy production
%   gross_out ==> gross output of goods and services
%   nen_CO2e  ==> non-energy CO2 emissions
%   enp       ==> energy production (a vector)
%   CO2c      ==> Carbon content per each energy production
% 
% 
% Outputs:
%   CO2e   ==> CO2 emissions from anthropogenic sources
%   em_iae ==> emissions intensity of aggregate energy
%   em_ic  ==> emissions intensity of capital stock
%   em_ie  ==> emissions intensity of energy
%   em_io  ==> emissions intensity of gross output of goods
% 



en_CO2e = enp.*CO2c;
entot_CO2e = sum(en_CO2e);

em_iae = entotCO2e/en_SRaggr;
em_ic = entotCO2e/capital;
em_ie = entotCO2e/en_ptot;
em_io = entotCO2e/gross_out;

CO2e = entot_CO2e + nen_CO2e;