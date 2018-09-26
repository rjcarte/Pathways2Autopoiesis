% Find the set of objects that receive X and emits Y
% v2 Now handles multi-state objects where 'sigma' is now a |Q| by 4 cell
% array where i=1 state 1 sigma sets, i=2 state 2 sigma sets, and so on
%
% At present only works on lists containing objects with same number of
% states
%
% INPUTS:   lists - description for each object (i.e. transitions)
%
% OUTPUTS:  sigma - the set of objects that receive X and emit Y
%
% Transition Key:
%
% 1 : 0|0
% 2 : 0|1
% 3 : 1|0
% 4 : 1|1

function sigmas = createSigmaSet (lists)

% Number of states the objects in the list each have
thisObject = lists{1};
q = length(unique(thisObject(:,1)));
    
% Repeat for each state of an object. 
for l=1:q

    a=1; b=1; c=1; d=1;
    xZeroyZero=[]; xZeroyOne=[]; xOneyZero=[]; xOneyOne=[];

    for i=1:length(lists)
        thisObject = lists{i};
        [I,J]=find(thisObject(:,1)==l);
        thisObject = thisObject(I,:);
       
        for j=1:size(thisObject,1)
            if thisObject(j,2) == 1
                xZeroyZero(a) = i;
                a=a+1;
            elseif thisObject(j,2) == 2
                xZeroyOne(b) = i;
                b=b+1;
            elseif thisObject(j,2) == 3
                xOneyZero(c) = i;
                c=c+1;
            elseif thisObject(j,2) == 4
                xOneyOne(d) = i;
                d=d+1;
            end
        end    
    end

sigma{1} = xZeroyZero;
sigma{2} = xZeroyOne;
sigma{3} = xOneyZero;
sigma{4} = xOneyOne;
sigmas{l}=sigma;
end

end
