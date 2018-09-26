% Information emitted from the cognitive network influences environmental
% information
%
% INPUTS:
% 
% Y - output probability distribution from each node in the CN
% 
% f - current frequency distribution of each object (node) in the CN. This
% adds a weighting to each output distribution in Y
% 
% backgroundE - this is the background information of the environment. This
% is typically a constant but may also be randomly varied (dependent on
% simulation parameters)
%
% phi - the degree to which cognitive noise 'modulates' environmental noise
% (e.g. '0' no modulation; '1' environmental noise == cognitive noise).
% Ordinarily 0<phi<1
%
% mode - mode 0 selects the noise is represented as an absolute integer (e.g. '0'
% or '1') or mode 1 as a distribution (e.g. P(x=0,x=1) '0.5,0.5')
%
% E - new probability distribution of the environment at time t.
% CN_Y - the output probability distribution for the CN at time t (this
% influences E). 
%
% Ver2.0 - experimenting with a stricter definition of input (environment)
% and output (cognitive niche) information

function [modE,CN_Y] = coupleEnvironmentv2 (Y,f,currentE,phi,mode)

modE = [0 0];
CN_Y = [0 0];

% Calculate the 'noise' emitted by the cognitive niche.
% The proportion of a particular e-machine in the niche affects the
% amplitude of the 'noise' (Y) it is emitting
for i=1:length(Y)
    if sum(Y(i,:)) > 0
        CN_Y(1,1) = CN_Y(1,1) + (Y(i,1)*f(i,1));
        CN_Y(1,2) = CN_Y(1,2) + (Y(i,2)*f(i,1));
    end
end
CN_Y = CN_Y/sum(CN_Y);

if mode == 0
    % Absolute integer output from the niche
    r = rand(1);
    
    if r <= CN_Y(1,1)
        CN_Y = [1 0];
    else
        CN_Y = [0 1];
    end
end

% Determine changes to environmental noise through the 'coupling' of
% cognitive niche noise
if phi > 0
    %rback = rand(1);
    %currentE(1,1)=rback;
    %currentE(1,2)=1-rback;
    modE(1,1) = ((1-phi)*currentE(1,1)) + (phi*CN_Y(1,1));
    modE(1,2) = ((1-phi)*currentE(1,2)) + (phi*CN_Y(1,2));
    modE = modE / sum(modE);
else
    modE = currentE;
end

if mode == 0
    r = rand(1);
    if r <= modE(1,1)
        modE = [1 0];
    else
        modE = [0 1];
    end
end

end
        