function [energy_req_dot,naer] = economy_energyreq(t,energy_req,LR_eep,raep,...
    LR_mpec,mceae,rp,revs,capital,ir)
% 
% Inputs:
%   energy_req ==> energy requirement by source (source vector)
%   LR_eep        ==> long run expected energy price (source vector)
%   raep ==> reference aggregate energy requirement
%   LR_mpec ==> long run marginal productivity of effective capital
%   mceae ==> marginal capital energy per aggregate energy
%   rp ==> reference production (source vector)
%   revs ==> reference energy value share (source vector)
%   capital ==> capital
%   ir ==> investment rate
% 
% Outputs:
%   energy_req_dot ==> rate of change of energy requirement (source vector)
%   naer ==> normal aggregate energy requirement
% 

% constants
eiat = 4; % yr, Time required (for R&D, retooling, etc.) to adjust energy intensity of new capital
eac = 0.33; % Ratio of actual adjustment in energy intensity to optimal adjustment.
cese = 0.75; % Elasticity of substitution between capital and aggregate energy good in capital-energy aggregate.
ese = 2; % Long-run CES elasticity of substitution among energy sources.
capital_lt = 15; % yr, Lifetime of goods producing capital.
rr = 0; % retrofit rate

cesc = (cese - 1.0)/cese; % CES coefficient of substitution in capital-energy aggregate.
aiac = cesc*eac; % Coefficient of adjustment of aggregate energy intensity.
nee = LR_eep.*energy_req; % Expected expenditures for energy, by source, with normal capacity utilization.
tnee = sum(nee); % Total expected energy expenditures, with normal capacity utilization.

esc = (ese - 1.0)/ese; % energy substance coefficient, Long-run CES coefficient of subsitution among energy sources.
eiac = ese*eac; % Coefficient of adjustment of fuel shares.
agei = revs.*(energy_req./rp).^esc; % CES term for contribution of energy sources to aggregate energy good.
tagei = sum(agei); % Sum of CES terms for contribution of energy sources to aggregate energy good.
maee = raep./rp*tagei^(1./esc - 1.0).*energy_req./rp.^(esc - 1.0).*revs; % Marginal output of aggregate energy good per unit of physical energy input.

LR_mpae = LR_mpec*mceae; % Long-run marginal productivity of aggregate energy good in capital-energy aggregate.
LR_mpe = LR_mpae.*maee; % Long-run marginal productivity of energy, by source.
eic = energy_req./capital; % Energy intensity of capital, by source.

naer = raep*tagei^(1./esc); % Input of aggregate energy good, with normal capacity utilization.

naep = tnee/naer; % Expected price of aggregate energy good, with normal capacity utilization.
aeie = LR_mpae/naep.^aiac; % Effect of aggregate energy intensity on desired energy intensity of new capital.
adei = eic.*LR_mpe./LR_eep.^eiac; % Desired energy intensity of new capital for fuel switching.
tadei = sum(adei); % Sum of adjusted energy intensities for individual sources.
ds = adei./tadei; % Desired share of energy sources in total energy intensity of capital.
tei = sum(energy_req); % Total energy requirements embodied in capital
dei = tei.*aeie.*ds; % Desired intensity of energy use for new capital, by source.

% planned energy intensity - Energy intensity of new capital; lags desired energy intensity due to lead time needed for R&D, retooling, etc.
pei = dei.*(1.0 - exp(-t/eiat)); % this function requires SMOOTH function, going simulate with EXP instead
% SMOOTH(Desired_Energy_Intensity[source],Energy_Intensity_Adjustment_Time)

energy_req_ir = pei.*ir; % Energy requirements of installed capital.
energy_req_rr = rr*(capital*pei - energy_req); % Rate of change of embodied energy requirements due to retrofits on existing capital.
energy_req_dr = energy_req./capital_lt; % Energy requirements of discarded capital.

energy_req_dot = energy_req_ir + energy_req_rr - energy_req_dr; % Energy requirements embodied in capital stock.