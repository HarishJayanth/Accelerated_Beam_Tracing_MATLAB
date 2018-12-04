function [a] = atten(Tin,Psin,hrin,dist,f)
% no spherical spreading!
%   [a] = atmAtten(T,P,RH,d,f)
%               a - attenuation of sound for input parameters in dB
%               T - temperature in deg C    = 23 deg C
%               P - static pressure in inHg = 29.92 inHg
%               RH - relative humidity in % = 35%
%               d - distance of sound propagation
%               f - frequency of sound
% https://en.wikibooks.org/wiki/Engineering_Acoustics/Outdoor_Sound_Propagation

T = Tin + 273.15; % temp input in K
To1 = 273.15; % triple point in K
To = 293.15; % ref temp in K

Ps = Psin/29.9212598; % static pressure in atm
Pso = 1; % reference static pressure

F = f./Ps; % frequency per atm


% calculate saturation pressure
Psat = 10^(10.79586*(1-(To1/T))-5.02808*log10(T/To1)+1.50474e-4*(1-10^(-8.29692*((T/To1)-1)))-4.2873e-4*(1-10^(-4.76955*((To1/T)-1)))-2.2195983);


h = hrin*Psat/Ps; % calculate the absolute humidity 

% Scaled relaxation frequency for Nitrogen
FrN = (To/T)^(1/2)*(9+280*h*exp(-4.17*((To/T)^(1/3)-1)));

% scaled relaxation frequency for Oxygen
FrO = (24+4.04e4*h*(.02+h)/(.391+h));

% attenuation coefficient in nepers/m
alpha = Ps.*F.^2.*(1.84e-11*(T/To)^(1/2) + (T/To)^(-5/2)*(1.275e-2*exp(-2239.1/T)./(FrO+F.^2/FrO) + 1.068e-1*exp(-3352/T)./(FrN+F.^2/FrN)));

a = 10*log10(exp(2*alpha))*dist;
