% Information Niche model simulation
% Two-state automata
% Well-mixed, no influx
%
% (c) 2018 Rich Carter
% School of Chemistry
% Bristol Centre for Complexity Science
% University of Bristol

% Set simulation parameters
Z = 1e6;
phi = 1;

% Load 2-state interaction matrix
load('2stateG')

% Sampling frequency of the population
historyOffset=10; zz=1;

% Initial population size (approx. 90,000)
INITTYPE = 1873;
N = INITTYPE * 200;
MAXTYPES = 1:INITTYPE;

% Initial uniform frequency
initialFrequency = N/INITTYPE;
frequency=zeros(1, INITTYPE,'single');

for f=1:INITTYPE
    frequency(f) = initialFrequency;
end

N = sum(frequency);
norm_freq = zeros(1,INITTYPE,INITTYPE);

norm_freq = (1/N)*frequency;
cumFrequency = cumsum(norm_freq);

popDynamics=zeros(Z/historyOffset,INITTYPE,'single');
popDynamics(1,:)=norm_freq;

z = 1;

while z < Z
    interactionFound = 0;
    
    r = rand(1);
    
    if phi > r
        % New automata is randomly generated
        Tc = randi(1873);
    else
        while interactionFound == 0
            % Select automata that will interact
            r1 = rand(1); r2=rand(1);
            while r1 > cumFrequency(INITTYPE) || r2 > cumFrequency(INITTYPE)
                r1 = rand(1); r2=rand(1);
            end
            I = find(cumFrequency>=r1);
            J = find(cumFrequency>=r2);
            i=1; j=1;
            R1 = I(i);
            R2 = J(j);
        
            while frequency(R1) <= 0 || frequency(R2) <= 0
                if frequency(R1) <= 0
                    i=i+1;
                    R1 = I(i);
                end
             
                if frequency(R2) <= 0
                    j=j+1;
                    R2 = J(j);
                end
            end
        % Check if interaction exists
        if G(R1,R2) > 0
            interactionFound = 1;
            Tc = G(R1,R2);
        else
            interactionFound = 0;
        end
        end

    end
    
    incFreq = frequency(Tc);
    incFreq = incFreq + 1;
    frequency(Tc) = incFreq;
    
    r3 = rand(1); 
    while r3 > cumFrequency(INITTYPE)
        r3 = rand(1);
    end
             
    K = find(cumFrequency>=r3);    
    k=1;
    R3 = K(k);
        
    while frequency(R3) == 0
        k=k+1;
        R3 = K(k);
    end
    
    replace=frequency(R3);
    replace=replace-1;
    frequency(R3) = replace;
    
    norm_freq = (1/N)*frequency;
    cumFrequency = cumsum(norm_freq);
    
    % Store object frequency
    if mod(z,historyOffset) == 0
        popDynamics(zz,:)=norm_freq;
        zz=zz+1;
    end

    z = z + 1;
end

plot(popDynamics)
figure
    