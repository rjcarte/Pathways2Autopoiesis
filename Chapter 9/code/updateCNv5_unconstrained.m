% Part of the Computation Niche library
%
% (c) 2018 Richard J.Carter
% University of Bristol
%
% v1.1 Updated to handle the simplified Y format
% v1.2 Updated to use simplified X calculation
%
% N - the network description
% Y - the output probability distribution of each node
% sigma - the symbol partition lists
% G - the production network matrix

function [frequency,f,updatedY,updatedG,types,updatedCN,updatedSigma,active] = updateCNv5(CN,Y,G,types,sigma,frequency,f,N,lookup,numCores)

updatedCN = CN{:};
updatedG = G;
updatedY = Y;
subset=[];
backupG = G;
typeLength = length(types);
backupCN = CN;
updatedSigma = sigma;

% The general background environment information source
backgroundE = [0.5 0.5];

% Environmental changes to 'perturb' the cognitive network
Echanges=[1 0];

% If set to 1 then the cognitive network emits information into the
% environment
cognitiveFlux = 0;

% Degree of coupling between niche and environment updates.
% If 1 then environment information reflects emissions from cognitive
% niche.
% If 0 then environment information is partly affected by background
% environment information and the information being emitted by the niche
couplingStrength = 0;

% The environment that affects the cognitive niche. If cognitiveFlux == 0
% then this is just the same as the background environment
E = backgroundE;

% The information 'aperture' between the environment into the cognitive
% niche. If 0 then no environment information transmits into the cognitive
% niche.
phi = 0;

% Environmental behaviour can be represented in two ways: as a probability
% distribution e.g. 60% information is 0, 40% info will be 1, and that
% distribution (0.6 0.4) is passed to the input probability distribution
% calculation at each node; alternatively, we determine the absolute value
% that the environment transmits into the cognitive network at time t hence
% the probability distribution will be either [1 0] or [0 1] (to represent
% 0 and 1 respectively).
% Mode - 0 (probability distribution)
% Mode - 1 (absolute value)
Emode = 0;

% Calculate the input probability distribution at each node
% If using calcX then must use setActive_singleX function
X = calcInputDistributionv5(CN,Y,f,E,phi,Emode,subset);

% Determine which nodes are activated at time t
[active,Y,f] = setActive(X,sigma,f,types,Y,frequency);

% Produce objects where both parents have been activated at time t
[f,frequency,types,G,rebuildFlag,newIndices] = produceMachinev5_unconstrained(active,frequency,f,G,N,types,lookup);

% Rebuild the membrane and the output distribution (Y)
if rebuildFlag == 1
    updatedG = G;
    updatedCN = rebuildCNv5(G);
    updatedY = initialiseCY(types{:});
    updatedSigma = createSigmaSet(types{:});
end

end