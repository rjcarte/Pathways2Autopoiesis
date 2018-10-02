% Part of the Computation Niche library
% (c) 2018 Richard J.Carter
% University of Bristol
%
% Checks to see if an object's parents (Ta,Tb) are ACTIVE and if so, they replicate
% that object (Tc). Another object (T_d) is selected at random and replaced
% with T_c.
%
% INPUTS:
%
% active - list of activated objects in the current population
% frequency - current absolute frequency of each object type in the
% population
% norm_freq - normalised frequency distribution of objects in the
% population at t-1
% G - the interaction matrix between objects
% N - the carrying capacity of the population (i.e. max population size;
% once this level is reached then we start to get an outflux of machines to
% make way for new machines)
% types - list of all current machine types across all CNs
%
% OUTPUTS:
%
% f - normalised frequency distribution of objects in the population at t
% frequency - absolute frequency distribution

function [f,frequency,types,updatedG,rebuildFlag,newIndices] = produceMachinev5 (active,frequency,f,G,N,types,lookup)

lengthTypes = length(types);
newIndices = [];
newObjects = [];
cumFrequency = cumsum(f(:,1));
a=1;
flag=0;
updatedG = G;

rebuildFlag = 0;

% Mask G where automata are inactive
[I] = find(active == 0);
G(I,:) = 0;
G(:,I) = 0;

% For remaining active automata we need to restrict no. of automata they
% can produce based on their current frequency
F = frequency;
F(I) = 0;

for i=1:size(G,1)
    if active(i) == 1
        % This automaton is active so let's see what it interacts with
        % (limited by its own frequency)
        [II] = find(G(i,:)~=0);
    
        % Need to ensure that II is not greater than current no. of this
        % automaton in the population
        RR = randperm(length(II));
        if length(RR) > F(i)
            % Reduce RR to fit current count of i
            RR = RR(1:F(i));
        end
    
        for j=1:length(RR)
            if G(i,II(RR(j))) > 0
                newObjects(a) = G(i,II(RR(j)));
            
                if newObjects(a) > size(f,1)
                    % This is the first time we've produced this type so we need to
                    % add it to the population
                    keyboard
                    rebuildFlag = 1;
                    f(end+1,:) = [0 1];
                    frequency(end+1)=0;
                    [result,~] = composeMachinesRevised(types(i),types(j),lookup,types,0);
                    if isempty(result)
                        keyboard
                    end
                    types{end+1}=result;
                    cumFrequency = cumsum(f(:,1));
                    if newObjects(a) > size(f,1)
                        keyboard
                    end
                
                    % Add new machine to G
                    newIndex = length(frequency);
                    updatedG(newIndex,:)=-1;
                    updatedG(:,newIndex)=-1;
                    updatedG(i,II(RR(j))) = newIndex;
                    newIndices(end+1) = newIndex;
                end
                a=a+1;
            elseif G(i,II(RR(j))) < 0
                [result,~] = composeMachinesRevised(types(i),types(j),lookup,types,0);
                if ~isempty(result)
                    % Existing type?
                    existing = findList(result,types);
                    if existing == 0
                        % New type. Add it to the population.
                        updatedG(i,II(RR(j))) = length(f)+1;
                        newObjects(a) = updatedG(i,II(RR(j)));
                        %rebuildFlag = 1;
                        f(end+1,:) = [0 1];
                        frequency(end+1)=0;
                        types{end+1}=result;
                        cumFrequency = cumsum(f(:,1));
                        if newObjects(a) > size(f,1)
                            keyboard
                        end
                        newIndex = length(frequency);
                        updatedG(newIndex,:)=-1;
                        updatedG(:,newIndex)=-1;
                        updatedG(i,II(RR(j))) = newIndex;
                        newIndices(end+1) = newIndex;
                    else
                        % Existing type. Just update G and add this type to
                        % newObjects
                        updatedG(i,II(RR(j))) = existing;
                        newObjects(a) = updatedG(i,II(RR(j)));
                    end
                    a=a+1;
                else
                    updatedG(i,II(RR(j)))=0;
                end
                rebuildFlag = 1;
            end
        end
    end
end

for k=1:length(newObjects)
    % Add object   
    thisFreq = frequency(newObjects(k));
    thisFreq = thisFreq + 1;
    frequency(newObjects(k)) = thisFreq;
        
    % Remove object (randomly select)
    r = rand(1);
    b = 1; 
    
    % Retrieve all existing objects in the population
    [I] = find(frequency > 0);
    candidateAutomaton2Replace = f(I,1);
    candidateAutomaton2Replace = candidateAutomaton2Replace / sum(candidateAutomaton2Replace);
    cumFrequencyReplace = cumsum(candidateAutomaton2Replace);

    while b <= length(I)
        if r <= cumFrequencyReplace(b)
            replaceObject = I(b);
            b = length(I)+1;
        else
            b=b+1;
            if b > length(I)
                keyboard
            end
        end
    end
    
    if sum(frequency) > N
        replaceFreq = frequency(replaceObject);
        replaceFreq = replaceFreq - 1;
        frequency(replaceObject) = replaceFreq;
        f(:,1) = frequency / sum(frequency);
        cumFrequency = cumsum(f(:,1));
    end
    
    if sum(frequency) > N
        keyboard
    end
end

f(:,1) = frequency / sum(frequency);

types={types};

nullTypes = checkNullTypes(types);

if nullTypes == 1
    keyboard
end

end