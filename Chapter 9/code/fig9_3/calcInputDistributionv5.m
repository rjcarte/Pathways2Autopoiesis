% Part of the Cognitive Niche library
%
% v1.1 Updated to now include multi-state objects
% v1.2 Updated to handle simplified Y formatting (now only shows the output
% probability distribution, not the associated internal states)
%
% Calculates the input probability distribution from weighted inflow of
% information from attached nodes in the network and the environment
%
% INPUTS:
% CN - the cognitive niche network
% Y - probability distribution where P(V)=(V==0,V==1) and |V| >= 1
% f - normalised frequency distribution of objects linking to this node
% (aka. whose probabilities are in V)
% E - probability distribution where P(E)=(E==0,E==1) and |E| == 1
% phi - the 'amount' of the environment information that influences the
% total probability distribution for the node
%
% OUTPUTS:
% X - the normalised input probability distribution for each node in the network as
% P(X)=(X==0,X==1)

function X = calcInputDistributionv5 (CN,Y,f,E,phi,Emode,subset)

if isnan(f(1,1))
    keyboard
end

% Retrieve all nodes that have in-degree > 0
backupCN = CN;
CN = CN{:};
T = unique(CN(:,2));

% EXPERIMENTAL: Probabilistically determine the absolute symbol the
% environment is transmitting at time t if eMode set to 1
switch Emode
    case 0
        % Do nothing
    case 1
        r = rand(1);
        if r <= E(1)
            E = [1 0];
        else
            E = [0 1];
        end
end

for g=1:length(T)
    % Retrieve indices of all links into T
    [I]=find(CN(:,2)==T(g));
    Py = zeros(1,2);
    
    % Probability distribution of incoming edges (Y)
    for h=1:size(I,1)
        if ~isempty(subset)
            [J] = find(subset==CN(I(h)));
            Py(1) = Py(1) + (Y(J,1) * f(J,1));
            Py(2) = Py(2) + (Y(J,2) * f(J,1));
        else
            Py(1) = Py(1) + (Y(CN(I(h)),1) * f(CN(I(h)),1));
            Py(2) = Py(2) + (Y(CN(I(h)),2) * f(CN(I(h)),1));
        end
    end
    
    if sum(Py) == 0
        % No activity at this node's input. Hence, this node's input is
        % completely dominated by environmental information regardless of
        % the value of phi
        X(g,1) = E(1);
        X(g,2) = E(2);
    else
        % Input activity from other nodes in the network and so need to
        % balance this against any environmental information being received
        Py = Py / sum(Py);
        
        % Compensate for environmental information ('noise')
        thisE = E*phi;
        Py = Py * (1 - phi);
    
        % Finalise the input probability distribution for this node
        X(g,1) = Py(1) + thisE(1);
        X(g,2) = Py(2) + thisE(2);
        
        if sum(isnan(X)) > 0
            keyboard
            X = [0 0];
        end
    end
end

if size(f,1) > size(X,1)
    % This simply means that there are machines in the population (and
    % cognitive network) that are not produced by other machines. So, we
    % need to add their inputs (X) as being whatever the environment is
    a=1;
    for i=1:size(CN,1)
        [I] = find(CN(:,2)==i);
        if isempty(I)
            % Insert environmental information for that node
            finalX(i,:) = E;
        else
            finalX(i,:) = X(a,:);
            a=a+1;
        end
    end
    X = finalX;
end

end