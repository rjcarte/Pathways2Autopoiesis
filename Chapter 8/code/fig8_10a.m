% Computation Niche model simulation
%
% (c) 2018 Richard J.Carter
%
% v1.1 Updated to handle the simplified Y format
% v1.2 Updated to use simplified X calculation
% 
% INPUTS:
%
%
% OUTPUTS:
%
% activeHistory - activity history of each node in the network
% Yhistory - emission history of each node in the network
% N - the network description

% Load constants
load('cognitiveNetworkWorkspace')
clear('popDynamics','frequency','Yhistory','Ehistory','CN_Yhistory','freqHistory','activeHistory')

Z = 1e5;
observations = Z;

% Probability of a new automaton being produced at time t (only applies if both
% parent automata are active at time t)
%
% This only really has the effect of delaying computation of the attractor
% when R gets closer to 0
% (i.e. it takes us longer to get there).
%
% Default should be 1 which ensures that at least one automaton is produced
% on each iteration
R = 1;

threshold = [];

% Update mode of the population: '0' synchronous mode; '1' asynchronous
% mode
updateMode = 0;

subset=[];

N = Nout_1state;

Y = Y_1state;

G = G_15object;

inputProbs = X_1state;

lists = onestatelist;

initF = 6000;

popDynamics = zeros(observations,length(G));

sigma = createSigmaSet(lists);

if ~isempty(subset)
    G = G(subset,subset);
    N = N_2state(subset);
    Nback=N;
    m=1;
    newN=[];
    for n=1:length(N)
        thisN = N{n};
        for j=1:length(subset)
            [I] = find(thisN(:,2)==subset(j));
            if ~isempty(I)
                newN(m,:) = thisN(I,:);
                m=m+1;
            end
        end
        N{n}=newN;
        m=1;
    end
    Y = Y_1state(subset,:);
end

% The general background environment information source
backgroundE = [];
E = [];

if ~isempty(backgroundE)
    if sum(backgroundE) ~= 1
        backgroundE = backgroundE / sum(backgroundE);
    end
    E = backgroundE;
else
    r1=rand(1);
    E(1,1) = r1;
    E(1,2) = 1-r1;
end

% Degree of coupling between niche and environment updates.
% If 1 then environment information reflects emissions from cognitive
% niche.
% If 0 then environment information is partly affected by background
% environment information and the information being emitted by the niche
couplingStrength = 0;

% The information 'aperture' between the environment into the cognitive
% niche. If 0 then no environment information transmits into the cognitive
% niche.
phiIn = 0;

% The information 'aperture' from the niche out to the environment.
phiOut = 0;

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

% Initialise the population
%frequency(1:length(G)) = 2000;
frequency(1:length(G)) = initF;

% f is a two-columned vector with the following syntax:
% f = [ current normalised frequency; current state ]
% Set current normalised frequency
f = zeros(length(G),1);
f(:,1) = frequency/sum(frequency);

% Set current state for each object type
% If initialState > 0 then randomly select which state is the initial
% state, otherwise '0' means that the initial state will be set as state 1
initialState = 0;
objectTypeStates = numberStates(lists);

if initialState == 0
    f(:,2)=1;
else
    for i=1:length(objectTypeStates)
        r=rand(1);
        probDist = 1/objectTypeStates(i);
        probDist = cumsum(probDist);
        b=1;
        while (r >= probDist(b))
            b=b+1;
        end
        f(i,2)=b;
    end
end

z=1;

activeHistory=zeros(Z,length(G));
fHistory=zeros(size(Echanges,1),size(f,1));
Ehistory=zeros(Z,2);
CN_Yhistory=zeros(Z,2);
Yhistory=cell(1,Z);
Xhistory=cell(1,Z);
freqHistory=zeros(Z,length(G));

% absMode: '0' convert distribution e.g. P(x==0)=0.5,P(x==1)=0.5 to a scalar e.g.
% P(x==0)=1 or P(x==1)=1; '1' no conversion
absMode = 1;

productionHistory = zeros(1,Z);

while z <= Z
    
    % Calculate the input probability distribution at each node
    % If using calcX then must use setActive_singleX function
    X = calcInputDistributionv2(N,Y,f,E,phiIn,Emode,subset);
    
    % Determine which nodes are activated at time t
    %[active,Y,f] = setActive_test(X,sigma,f,lists,Y,inputProbs);
    [active,Y,f] = setActive_v3(X,sigma,f,lists,Y,inputProbs,threshold);
    
    % Produce objects where both parents have been activated at time t
    [f,frequency,productionHistory(z)] = produceObjectv04 (active,frequency,f,G,subset,R,updateMode);

    % Calculate the net Y of the niche
    % We can re-use the coupleEnvironment function but we discard the 'E'
    % variable returned
    %[~,CN_Y] = coupleEnvironmentv2(Y,f,backgroundE,phiOut,absMode);
    Ehistory(z,:)=E;
    
    if ~isempty(backgroundE)
        [E,CN_Y] = coupleEnvironmentv2 (Y,f,backgroundE,phiOut,absMode);
    else
        r1=rand(1);
        E(1,1)=r1;
        E(1,2)=1-r1;
        [E,CN_Y] = coupleEnvironmentv2 (Y,f,E,phiOut,absMode);
    end
    
    freqHistory(z,:)=frequency;
    popDynamics(z,:)=f(:,1);
    CN_Yhistory(z,:)=CN_Y;
    stateHistory{z}=f(:,2);
    activeHistory(z,:)=active;
    Yhistory{z}=Y;
    z=z+1;
end

Yhistory = convertYhist2Ystream(Yhistory,1);