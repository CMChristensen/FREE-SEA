function [SR_maee,SR_mpae,SR_mpe,ieor] = economy_energyinput(naer,energy_req,energy_dl,...
    SR_evs,SR_eep,...
    mpoc,ncea,roc,rcea,mceae)
% 
% Inputs:
%   naer       ==> normal aggregate energy requirement
%   energy_dl  ==> energy delivery (source vector)
%   energy_req ==> energy requirement per source (source vector)
%   SR_evs     ==> short run energy value share (source vector)
%   SR_eep     ==> short run expected energy price (source vector)
% 
%   mpoc       ==> marginal product operation capital
%   ncea       ==> normal capital energy aggregate
%   roc        ==> reference operating capital
%   rcea       ==> reference capital energy aggregate
%   mceae      ==> marginal capital energy per aggregate energy
% 
% Outputs:
%   SR_maee    ==> short run marginal aggregate energy per physical energy
%   SR_mpae    ==> short run marginal productivity of aggregate energy
%   SR_mpe     ==> short run marginal productivity of energy (source vector)
%   ieor       ==> indicated energy order rate (source vector)
% 

% nsource = length(energy_req);

SR_ese = 0.2; % CES elasticity of substitution among energy sources.
SR_esc = (SR_ese-1.0)/SR_ese; % CES coefficient of subsitution among energy sources.

SR_aei = SR_evs.*(energy_dl./energy_req).^SR_esc; % CES term for contribution of individual energy source to aggregate energy good.
SR_taei = sum(SR_aei); % Total contribution of CES terms for each energy source.

SR_maee = naer./energy_req*SR_taei.^(1./SR_esc - 1.0).*...
    (energy_dl./energy_req).^(SR_esc - 1.0).*SR_evs; % Marginal output of the aggregate energy good per unit of physical energy input

SR_e = 0.1; % this value comes from another module
SR_ec = (SR_e - 1.0)/SR_e ; % elasticity coefficient, Short run CES coefficient of substitution between fixed capital and aggregate energy good.
SR_ae = naer*SR_taei.^(1./SR_esc); % Output of the aggregate energy good.
SR_aevs = mceae*naer/ncea; % aggregate energy value share, Value share of each energy source in the short run CES aggregate energy good.
opc = (1.0 - SR_aevs) + SR_aevs*(SR_ae/naer).^SR_ec; % operating coefficient, Coefficient of energy production capacity utilization, based on energy input relative to energy requirement.



SR_mpae = mpoc*ncea/naer*SR_aevs*opc.^(1./SR_ec - 1.0)*...
    (SR_ae/naer).^(SR_ec - 1.0)*roc/rcea; % Short run marginal productivity of aggregate energy good.

SR_mpe = SR_maee.*SR_mpae; % Short run marginal productivity of energy, by source.

eoac = 0.1; % Coefficient of energy input adjustment in response to price / productivity imbalance.
ieor = energy_dl.*(SR_mpae./SR_eep).^eoac; % indicated energy order rate, current energy consumption rate and adjustment for relative price and marginal productivity.
