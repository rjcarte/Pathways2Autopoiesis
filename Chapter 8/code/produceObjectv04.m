% Part of the Cognitive Niche library
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
%
% OUTPUTS:
%
% f - normalised frequency distribution of objects in the population at t
% frequency - absolute frequency distribution

function [f,frequency,produced] = produceObjectv04 (active,frequency,f,G,subset,R,updateMode)
produced=0;
newObjects = [];
cumFrequency = cumsum(f(:,1));
a=1;

for i=1:size(G,1)
    for j=1:size(G,2)
        if (active(i) > 0 && active(j) > 0) && G(i,j) > 0
            newObjects(a) = G(i,j);
            a=a+1;
        end
    end
end

if ~isempty(newObjects)
if updateMode == 0
    % Synchronous update
    
    for k=1:length(newObjects)
        % Add object
    
        % Randomly determine if this object gets produced
        rr = rand(1);
    
        if rr <= R
            % Automaton gets produced
            if ~isempty(subset)
                I = find(subset==newObjects(k));
                thisFreq = frequency(I);
                thisFreq = thisFreq + 1;
                frequency(I) = thisFreq;
            else
                thisFreq = frequency(newObjects(k));
                thisFreq = thisFreq + 1;
                frequency(newObjects(k)) = thisFreq;
            end
    
            % Remove object (randomly select)
            r = rand(1);
    
            b = 1; 
    
            % Retrieve all existing objects in the population
            [I] = find(frequency > 0);
            cumFrequencyReplace = cumsum(f(I,1));
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
        replaceFreq = frequency(replaceObject);
        replaceFreq = replaceFreq - 1;
        frequency(replaceObject) = replaceFreq;
        f(:,1) = frequency / sum(frequency);
        cumFrequency = cumsum(f(:,1));
        end
    f(:,1) = frequency / sum(frequency);
    end
else
    RR = randperm(length(newObjects));
    if length(newObjects) < 2
        rr = RR(1);
    else
        rr = randi(length(RR));
    end
    thisFreq = frequency(newObjects(RR(rr)));
    thisFreq = thisFreq + 1;
    frequency(newObjects(RR(rr))) = thisFreq;
    produced = newObjects(RR(rr));
    
    % Remove object (randomly select)
    r = rand(1);
    b = 1; 
    % Retrieve all existing objects in the population
    [I] = find(frequency > 0);
    cumFrequencyReplace = cumsum(f(I,1));
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
    replaceFreq = frequency(replaceObject);
    replaceFreq = replaceFreq - 1;
    frequency(replaceObject) = replaceFreq;
    f(:,1) = frequency / sum(frequency);
    cumFrequency = cumsum(f(:,1));
    f(:,1) = frequency / sum(frequency);
end
end
end    