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
% Simulation demonstrates formation of Niche F
% As shown in figure 1f.
%

% Load automata information e.g. automata types ('list') and the automata
% interaction matrix ('G')
load('automata')

% Clear existing workspace (housekeeping)
clear('frequency','cumFrequency','popDynamics','M');

% SIMULATION PARAMETERS
Z = 5e6; % Number of iterations of the simulation
z = 1; % Iteration counter

% ENVIRONMENT PARAMETERS
% Set to produce niche B
n = 300; % Width of the lattice
M = zeros(n,n,'int16'); % Create the lattice
neighbourhood = 9; % Moore neighbourhood interactions
phi = 0.25; % Influx rate of randomly generated automata into population
cMix = 10; % No. of automaton mixed on each time step (diffusive mixing)
v = n; % Distance from which automaton are mixed (diffusive mixing)
phiAlt = 1; % Set to '1' to restrict influxing machines to subset (only used to generate Niche F and Niche Y)
E(1,:) = [phi cMix v 1]; % Program in the timing of environment parameters (syntax: [phi cMix v z])

% POPULATION PARAMETERS
INITTYPE = length(lists); % Initial number of automata types in the population. This is FIXED.
popDynamics=zeros(Z,length(lists),'single'); % Population dynamics history
N = INITTYPE * 6000; % Population size
MAXTYPES = 1:INITTYPE; % Population diversity

% INITIALISE THE SIMULATION

% Create a uniform probability distribution of all object types
mdist=zeros(1,INITTYPE);
mdist(1:INITTYPE) = 1/INITTYPE;
mdist = cumsum(mdist);

frequency=zeros(1,INITTYPE,'single');

% Randomly populate the matrix M by uniform selection from all object types
for i=1:n
    for j=1:n
        thisM = 0;
        thisM = uniformPick(mdist);
        M(i,j) = thisM;
        frequency(thisM) = frequency(thisM)+1;
    end
end

meanFreq = floor(mean(frequency));

N=sum(frequency);

norm_freq = (1/N)*frequency;

cumFrequency = cumsum(norm_freq);

popDynamics(1,:)=norm_freq;

% Declare cumulative distribution for selecting function to use
tdist=zeros(1,4);
tdist(1:4) = 1/4;
tdist = cumsum(tdist);
    
% Run algorithm
while z < Z
    
    if z == E(1,4)
        phi = E(1,1);
        cMix = E(1,2);
        v = E(1,3);
        if size(E,1) > 1
            E(1,:)=[];
        end
    end
    
    % Select object in M
    rI = randi(n);
    rJ = randi(n);
    thisAutomaton = M(rI,rJ);
    thisAutomatonCoords(1) = rI;
    thisAutomatonCoords(1,2) = rJ;
    
    rr=rand(1);
    
    if phi > rr
        % Randomly generate an object and replace it with a randomly generated
        % object
        if phiAlt == 1
            flipcoin = rand(1);
            if flipcoin < 0.16
                % T6 is the influxing machine
                randomAutomaton = 7;
            elseif flipcoin < 0.32
                % T9 is the influxing machine
                randomAutomaton = 11;
            elseif flipcoin < 0.48
                randomAutomaton = 13;
            elseif flipcoin < 0.64
                randomAutomaton = 14;
            elseif flipcoin < 0.8
                randomAutomaton = 6;
            else
                randomAutomaton = 9;
            end
        else
            % Generate an object randomly
            randomAutomaton = randi(length(lists));
        end
        
        M(thisAutomatonCoords(1),thisAutomatonCoords(2))=randomAutomaton;
        
        % Increment that object type's frequency
        incAutomaton = frequency(randomAutomaton);
        incAutomaton = incAutomaton + 1;
        frequency(randomAutomaton) = incAutomaton;
            
        % Decrement the frequency of the object type that it replaces 'Tb'      
        replace=frequency(thisAutomaton);
        replace=replace-1;
        frequency(thisAutomaton) = replace;
    else
        % Select neighbours to perform functional composition
        rTheta = rand(1);
        rP = 1/(neighbourhood*2);
    
        if rTheta < 0.25
            % Function 1
            fn=1;
            [M,frequency] = setCell (M,thisAutomatonCoords,1,frequency,G);
        
        elseif rTheta >= 0.25 && rTheta < 0.5
            fn=2;
            % Function 2
            [M,frequency] = setCell (M,thisAutomatonCoords,2,frequency,G);
        
        elseif rTheta >= 0.5 && rTheta < 0.75
            % Function 3
            fn=3;
            [M,frequency] = setCell (M,thisAutomatonCoords,3,frequency,G);
    
        elseif rTheta >= 0.75 && rTheta <= 1
            % Function 4            
            fn=4;
            [M,frequency] = setCell (M,thisAutomatonCoords,4,frequency,G);
        
        end
    
        A=0;B=0;C=0;

        Msize = size(M,1);

    if thisAutomatonCoords(1) == 1
        % Cell is on top boundary
        if thisAutomatonCoords(2) == 1
            % Cell is in the top-left corner
            switch fn
                case 1
                % A(i-1,j),B(i,j),C(i+1,j)
                A = M(Msize,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                case 2
                % A(i+1,j),B(i,j),C(i-1,j)
                A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(Msize,thisAutomatonCoords(2));
                case 3
                % A(i,j-1),B(i,j),C(i,j+1)
                A = M(thisAutomatonCoords(1),Msize);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                case 4
                % A(i,j+1),B(i,j),C(i,j-1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),Msize);     
            end
        elseif thisAutomatonCoords(2) == Msize
            % Cell is in the top-right corner
            switch fn
                case 1
                % A(i-1,j),B(i,j),C(i+1,j)
                A = M(Msize,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                case 2
                % A(i+1,j),B(i,j),C(i-1,j)
                A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(Msize,thisAutomatonCoords(2));
                case 3
                % A(i,j-1),B(i,j),C(i,j+1)
                A = M(thisAutomatonCoords(1),Msize);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),1);
                case 4
                % A(i,j+1),B(i,j),C(i,j-1)
                A = M(thisAutomatonCoords(1),1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
            end
        else
            % Cell is on the top boundary but not in a corner
            switch fn
                case 1
                % A(i-1,j),B(i,j),C(i+1,j)
                A = M(Msize,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                case 2
                % A(i+1,j),B(i,j),C(i-1,j)
                A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(Msize,thisAutomatonCoords(2));
                case 3
                % A(i,j-1),B(i,j),C(i,j+1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                case 4
                % A(i,j+1),B(i,j),C(i,j-1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
            end
        end    
    elseif thisAutomatonCoords(1) == Msize
        % Cell is on bottom boundary
        if thisAutomatonCoords(2) == 1
            % Cell is in the bottom-left corner
            switch fn
                case 1
                % A(i-1,j),B(i,j),C(i+1,j)
                A = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(1,thisAutomatonCoords(2));
                case 2
                % A(i+1,j),B(i,j),C(i-1,j)
                A = M(1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                case 3
                % A(i,j-1),B(i,j),C(i,j+1)
                A = M(thisAutomatonCoords(1),Msize);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                case 4
                % A(i,j+1),B(i,j),C(i,j-1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),Msize);     
            end
        elseif thisAutomatonCoords(2) == Msize
            % Cell is in the bottom-right corner
            switch fn
                case 1
                % A(i-1,j),B(i,j),C(i+1,j)
                A = M(Msize,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(1,thisAutomatonCoords(2));
                case 2
                % A(i+1,j),B(i,j),C(i-1,j)
                A = M(1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                case 3
                % A(i,j-1),B(i,j),C(i,j+1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(1)-1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),1);
                case 4
                % A(i,j+1),B(i,j),C(i,j-1)
                A = M(thisAutomatonCoords(1),1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
            end
        else
            % Cell is on the bottom boundary but not in a corner
            switch fn
                case 1
                % A(i-1,j),B(i,j),C(i+1,j)
                A = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(1,thisAutomatonCoords(2));
                case 2
                % A(i+1,j),B(i,j),C(i-1,j)
                A = M(1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                case 3
                % A(i,j-1),B(i,j),C(i,j+1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                case 4
                % A(i,j+1),B(i,j),C(i,j-1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
            end
        end
        elseif thisAutomatonCoords(2) == 1
            % Cell is on left boundary but not in a corner
            switch fn
                case 1
                % A(i-1,j),B(i,j),C(i+1,j)
                A = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                case 2
                % A(i+1,j),B(i,j),C(i-1,j)
                A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                case 3
                % A(i,j-1),B(i,j),C(i,j+1)
                A = M(thisAutomatonCoords(1),Msize);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                case 4
                % A(i,j+1),B(i,j),C(i,j-1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),Msize);     
            end
        elseif thisAutomatonCoords(2) == Msize
            % Cell is on the right boundary but not in a corner
            switch fn
                case 1
                % A(i-1,j),B(i,j),C(i+1,j)
                A = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                case 2
                % A(i+1,j),B(i,j),C(i-1,j)
                A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                case 3
                % A(i,j-1),B(i,j),C(i,j+1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),1);
                case 4
                % A(i,j+1),B(i,j),C(i,j-1)
                A = M(thisAutomatonCoords(1),1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
            end
        else
            % Cell is not on a boundary
            switch fn
                case 1
                % A(i-1,j),B(i,j),C(i+1,j)
                A = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                case 2
                % A(i+1,j),B(i,j),C(i-1,j)
                A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
                case 3
                % A(i,j-1),B(i,j),C(i,j+1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                case 4
                % A(i,j+1),B(i,j),C(i,j-1)
                A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
                B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
                C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
            end
    end
    
    % Check if interaction exists between the two chosen neighbours
    rr = rand(1);
    if G(A,C) > 0
        
        % Interaction exists so add this new automaton to population and
        % remove an existing automaton from M lattice position
        M(thisAutomatonCoords(1),thisAutomatonCoords(2))=G(A,C);
        
        % Increment that automaton type's frequency
        incAutomaton = frequency(G(A,C));
        incAutomaton = incAutomaton + 1;
        frequency(G(A,C)) = incAutomaton;
            
        % Decrement the frequency of the automaton type that it replaces 'Tb'
        replace=frequency(B);
        replace=replace-1;
        frequency(B) = replace;
    end
    end  
    
    % If diffusive mixing is enabled then swap c automata at a distance v
    % from each other
    if v > 0
        R1 = randperm(n);
        R2 = randperm(n);
        for a=1:cMix
            R1 = randi(n);
            R2 = randi(n);
            swapthisAutomaton(1)=R1;
            swapthisAutomaton(1,2)=R2;
            [M,swapAutomaton] = spatialMixing(M,v,swapthisAutomaton);
        end
    end

    % Store population structure at iteration z
    norm_freq = (1/sum(frequency))*frequency;   
    popDynamics(z,:)=norm_freq;
    
    z=z+1;
end

figure(1)
plot(popDynamics)