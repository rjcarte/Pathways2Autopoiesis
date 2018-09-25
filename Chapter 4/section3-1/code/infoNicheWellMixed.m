% Supplementary information
% "Emergence and dynamics of self-producing information niches as a step
% towards pre-evolutionary organization"
%
% (c) 2017 R.J. Carter
% School of Chemistry
% Bristol Centre for Complexity Science
% University of Bristol
%
% NOTES:
%
% Simulation demonstrates formation of Niche 2C
% As shown in figure 1b.

% Load automata information e.g. automata types ('list') and the automata
% interaction matrix ('G')
load('automata')

% SIMULATION PARAMETERS
Z = 400000; % Number of iterations of the simulation
z = 1; % Iteration counter

% POPULATION PARAMETERS
INITTYPE = 15; % Initial number of automata types in the population. This is FIXED.
popDynamics=zeros(Z,INITTYPE,'single'); % Population dynamics history
N = INITTYPE * 4000; % Population size
MAXTYPES = 1:INITTYPE; % Population diversity
frequency=zeros(1,INITTYPE,'single');
frequency(1:15) = N/INITTYPE;

norm_freq = (1/N)*frequency;

cumFrequency = cumsum(norm_freq);

popDynamics(1,:)=norm_freq;

interactionHistory = zeros(1,Z);

% Run algorithm
while z < Z
    interaction = 0;
    while interaction == 0
        % Select Ta
        r1 = rand(1);
        a=1;
        while r1 > cumFrequency(a) || frequency(a) == 0
            a = a + 1;
        end
        Ta = a;
        
        % Select Tb
        r2 = rand(1);
        b=1;
        while r2 > cumFrequency(b) || frequency(b) == 0
            b=b+1;
        end
        Tb = b;
        
        if G(Ta,Tb) > 0
            % Add Tc to population
            interaction = 1;
            frequency(G(Ta,Tb)) = frequency(G(Ta,Tb)) + 1;
            interactionHistory(z) = G(Ta,Tb);
            
            % Select Td
            r3 = rand(1);
            c=1;
            while r3 > cumFrequency(c) || frequency(c) == 0
                c=c+1;
            end
            frequency(c) = frequency(c) - 1;
        end
    end
    norm_freq = frequency / sum(frequency);
    cumFrequency = cumsum(norm_freq);
    popDynamics(z,:) = norm_freq;
    z=z+1;
end