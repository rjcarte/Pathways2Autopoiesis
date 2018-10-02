% Part of Cognitive Niche library
%
% v1.1 Added support for handling multi-state objects
% v1.2 Updated to handle the simplified Y format (just output probability
% distribution; state information now removed)
% v1.3 Updated to handle simplified 'X' (only a single probability
% distribution now used for all nodes; rather than individual X for each
% node)
%
% Assesses the input probability distribution to each node
% If a threshold is surpassed then the node is activated
% This is a memoryless operation (as in, it doesn't matter what its
% previous active state was)
%
% INPUTS:
%
% X - input probability distribution for each node at t
% sigmas - objects partitioned by their information processing behaviour:
%   sigma{1} - objects that have a 0|0 transition
%   sigma{2} - objects that have a 0|1 transition
%   sigma{3} - objects that have a 1|0 transition
%   sigma{4} - objects that have a 1|1 transition
%
% There is a set of these partitions for each state of an object. Hence a
% two-state object library will have two sets of 4 sigma sets (!).
%
% f - frequency distribution. Need its second column as it tells us what
% state an object is in at t-1
%
% OUTPUT:
%
% active - '0' object is not active, '1' object is active
% Y - output probability distribution conditional on input
% f - frequency distribution vector with updated 'currentState' column 

function [active,Y,f] = setActive (X,sigmas,f,types,Y,frequency)

sigmaInputIndex=[0 0 1 1];
sigmaOutputIndex=[0 1 0 1];

for i=1:size(f,1)

    if frequency(i) > 0
    
        thisObjectState = f(i,2);
        sigma = sigmas{thisObjectState};
        thisNode=[ 0 0 ];
    
        % Checks which partitons this nodes transitions are in
   
        % The first two partitions are those objects that accept a '0'
        % The last two partitions are those objects that accept a '1'
        for j=1:length(sigma)
            this = sigma{j};
            [I] = find(this==i);
            if ~isempty(I)
                if sigmaInputIndex(j) == 0
                    % Accepting a '0'
                    thisNode(1)=1;
                elseif sigmaInputIndex(j) == 1
                    % Accepting a '1'
                    thisNode(2)=1;
                end
            end
        end
    
        r=rand(1);
           
        if r < X(i,1) && thisNode(1) > 0
            % Input probability for P(x==0) has been triggered and this node
            % accepts a zero. It has been activated.
            active(i) = 1;
        
            % Retrieve output options for a transition that accepts '0'
            thisSigma1 = sigma{1};
            thisSigma2 = sigma{2};
        
            [I,J]=find(thisSigma1==i);
            [K,L]=find(thisSigma2==i);
            if isempty(I)
                % The only Y option is to emit a '1'
                y = [0 1];
                % Perform state transition
                f(i,2) = stateTransition (f(i,2),2,types{i},thisNode);
                
            elseif isempty(K)
                % Only one Y option is to emit a '0'
                y = [1 0];
                f(i,2) = stateTransition (f(i,2),1,types{i},thisNode);
            
            else
                % Both options are valid so probabilistically determine the
                % transition to take
                r=rand(1);
                if r < 0.5
                    y = [1 0];
                    f(i,2) = stateTransition(f(i,2),1,types{i},thisNode);
                else
                    y = [0 1];
                    f(i,2) = stateTransition(f(i,2),2,types{i},thisNode);
                end
            end
        elseif r < X(i,2) && thisNode(2) > 0
            % Input probability for P(x==1) has been triggered and this node
            % accepts a one. It has been activated.
            active(i) = 1;
            % Retrieve output options for a transition that accepts '1'
            thisSigma3 = sigma{3};
            thisSigma4 = sigma{4};
            [I,J]=find(thisSigma3==i);
            [K,L]=find(thisSigma4==i);
            if isempty(I)
                % Only one Y option is to emit a '1'
                y = [0 1];
                f(i,2) = stateTransition(f(i,2),4,types{i},thisNode);
            elseif isempty(K)
                % Only one Y option is to emit a '0'
                y = [1 0];
                f(i,2) = stateTransition(f(i,2),3,types{i},thisNode);
            else
                % Both options are valid so probabilistically determine the
                % transition to take
                r=rand(1);
                if r < 0.5
                    y = [1 0]; 
                    f(i,2) = stateTransition(f(i,2),3,types{i},thisNode);
                else
                    y = [0 1];
                    f(i,2) = stateTransition(f(i,2),4,types{i},thisNode);
                end
            end
        else
            % Node hasn't been activated.
            active(i) = 0;
            y = [0 0];
        end
        % Update the output probability distribution 'Y' for this object
        Y(i,:) = y;
    else
        active(i) = 0;
        Y(i,:) = [0 0];
    end
end

end