% Seed population only
% Computation Niche model simulation
% (c) 2018 Richard J. Carter
% University of Bristol

load('seedAutomata')

% SIMULATION PARAMETERS
Z = 200;
z = 1;

% DEFINE POPULATION ENVIRONMENT
% Carrying capacity of each cell
% Previous work suggests there should be at least 1,500 per machine type
N = 100000;

% Initial population size in each cell (applies to all new CN's whether at
% the initialisation of the simulation or as a result of niche
% reproduction/interactions)
mu = N;

% Environment grid size (n)
n = 1;
nicheN = n*n;

% INITIALISE COMPUTATION NICHE POPULATION
% Declare cell arrays for population
initialTypes = CNtypes;
types=initialTypes;

% Need to ensure N divisible by no. of types. If not, round up N
indN = round(N/length(types));
N = indN * length(types);

% The membrane of each computation niche
CN = cell(1,nicheN);

% The input probability distribution of each node in a computation niche
CX = cell(1,nicheN);

% The output probability distribution of each node in a computation niche
CY = cell(1,nicheN);

% The sigma sets for each computation niche
Csigma = cell(1,nicheN);

% The normalised frequency distribution of each computation niche's
% population
Cf = cell(1,nicheN);

% The absolute count of machine types in a computation niche's population
Cfrequency = cell(1,nicheN);

% The activity pattern of nodes in the membrane of the niche
Cactive = cell(1,nicheN);

% The current proportion of the carrying capacity occupied within each
% niche
capacity = zeros(n,n);

% Index of the machine types in the computation niche
Ctypes = cell(1,nicheN);
for i=1:length(Ctypes)
    Ctypes{i} = types;
end

% The interaction network for the seed population
CG{1} = Gseed;

% Initialise the CN population
for i=1:nicheN
    % Create a new niche for each of the initial types (they are all
    % self-replicators)
    %
    % Returns:
    %
    % MEMBRANE
    % CN - the membrane network
    % CY - output distribution of each membrane automata
    % CX - input distribution of each membrane automata
    %
    % INTERNAL POPULATION
    % Cfrequency - absolute count of the internal automata population
    % Cf - normalised frequency distribution of the population in the CN
    [CN{i},Cfrequency{i},Cf{i}] = initCNv2(CG{i},mu);
    CY{i} = initialiseCY(types);
    Csigma{i} = createSigmaSet(types);
end

% Position the CN's on the n-by-n grid
% NB: |R| should equal n^2
R = randperm(length(CN));
if length(R) ~= n^2
    keyboard
end
M = zeros(n,n);
a = 1;
for i=1:n
    for j=1:n
        M(i,j) = R(a);
        a = a+1;
    end
end

% Declare time-series matrices
popDynamics = cell(Z,length(CN));
activeHistory = [];

% Housekeeping variables
noChange = 0;
previousAll = 0;
finalz = 0;
sigmaBackup = Csigma;

while z <= Z

    % UPDATE THE COMPUTATION NICHE
    % Update membrane and internal population at time t
    for i=1:length(CN)
        checks = check4errors(CN(i),CG{i},CY{i},Ctypes{i},Cfrequency{i},Cf{i});
        if length(unique(checks)) > 1
            keyboard
        end
        [Cfrequency{i},Cf{i},CY{i},CG{i},Ctypes(i),CN{i},Csigma{i},active] = updateCNv5(CN(i),CY{i},CG{i},Ctypes{i},Csigma{i},Cfrequency{i},Cf{i},N,lookup,[]);
        popDynamics{z,i} = Cf{i};
        activeHistory{z} = active;
        Yhistory{z} = CY;
        Ghistory{z} = CG;
    end
    z=z+1;
end

pop = convertPopCell2Matrix (popDynamics);
plot(pop)
figure(1)