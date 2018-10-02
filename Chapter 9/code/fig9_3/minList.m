% minByPartition
%
% Minimisation of a finite state machine using Hopcroft algorithm
%
%
% Updated 11-Apr-17: now returns Tc (minimal machine)
%
% (c) 2016-17 Rich Carter
% University of Bristol

function [index,minL] = minList(L,types)

% Minimum by Partition
% Create inverse transition list for each state
d = inverseList(L);

% Create initial partition; automata states are all accepting states
% so initial partition includes all states
initP = d(:,1);
initP(end+1:size(d,1)+size(d,1)) = d(:,3);
initP = unique(initP)';
        
% Create initial waiting list by adding the first partition set
W{1}=initP;
%W{2}=[];
P{1}=W{:};
%P{2}=[];

% while there are still items in the waiting list
while ~isempty(W)

% choose and remove a set 'A' from the waiting list 'W'
    A = W(1);
    W(1) = [];
    X = [];

    % foreach c in the alphabet
    for c=1:4
        % let 'X' be the set of states for which a transition on 'c' leads
        % to a state in 'A'
        % d = { receiving state, transition symbols, sending state }
        X = [];
        x=1;
        for e=1:length(A{:})
            AA=A{1};
            AA=AA(e);
            [E] = find(d(:,1)==AA);
            if ~isempty(E)
                for g=1:length(E)
                    if d(E(g),2) == c
                        % A transition 'c' leads to a state in 'A' so add the
                        % sending state to set 'X'
                        X(x) = d(E(g),3);
                        x=x+1;
                    end
                end
            end
        end
        
        X = unique(X);
        
    % foreach set 'Y' in 'P' for which X.Y is nonempty AND Y\X is
    % nonempty
    for p=1:length(P)
        Y=P{p};
        Y1 = intersect(X,Y);
        Y2 = intersect(setxor(Y,X),Y);
           
        if ~isempty(Y1) && ~isempty(Y2) 
            % Replace 'Y' in 'P' by the two sets X.Y and Y\X
            P{end+1} = Y1;
            P{end+1} = Y2;
            P(p) = [];
            
            % Is it right to reset the loop counter?
            p=1;
            
            % if 'Y' is in 'W'
            if ~isempty(W)
                for w=1:length(W)
                    if isequal(Y,W{w})
                        W = checkWaitingList(W,Y1);
                        W = checkWaitingList(W,Y2);
                        %W{end+1} = Y1;
                        %W{end+1} = Y2;
                        W(w) = [];
                    else
                        if length(Y1) <= length(Y2)
                            % add 'Y1' to 'W'
                            W = checkWaitingList(W,Y1);
                            %W{end+1} = Y1;
                        else
                            % add 'Y2' to 'W'
                            W = checkWaitingList(W,Y2);
                            %W{end+1} = Y2;
                        end
                    end
                end
            else
                if length(Y1) <= length(Y2)
                    % add 'Y1' to 'W'
                    %W{end+1} = Y1;
                    W{1}=Y1;
                else
                    % add 'Y2' to 'W'
                    %W{end+1} = Y2;
                    W{1}=Y2;
                end
            end
        end
    end
    end
end

% We now need to map 'P' back to a finite state machine representation
minL = convertPartition2List(P,d);

index = 0;

% Check to see if we now have a valid machine
if ~isempty(minL)
    
    % Check for non-unifilarity transitions. If exist then not a valid
    % machine
    minL = checkUnifilarity(minL);
    
    if ~isempty(minL)
        % Check to see if the minimised machine already discovered
        index = findList(minL,types);
    
        % Possibly a new machine type discovered. Do checks!
        if index == 0
            % Check to see if the minimised machine is a valid e-machine
            [connected,bins] = checkStronglyConnected(minL);
            nk = nkCheck(minL);
            if connected == 1 && nk == 1
                % Assume this is a new machine type
                % It's strongly connected and it passes nk-1 rule
                index = length(types)+1;
            else
                % Not a valid e-machine
                minL = []; index = 0;
            end
        end
    end
end

end