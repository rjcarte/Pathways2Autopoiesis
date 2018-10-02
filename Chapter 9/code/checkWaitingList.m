% Part of minimisation code module
%
% Checks if a partition (W) is already in the waiting list (W)
%
% If so then we don't add it to the waiting list
%
% INPUTS:
%
% W - waiting list
% P - partition
%
% OUTPUTS:
%
% W - waiting list which is either not been touched or has had P appended
% to it

function W = checkWaitingList (W,P)

for w=1:length(W)
    if isequal(P,W{w})
        % Partition already exists in the waiting list. No changes to W.
        w=0;
        break
    end
end

if w == length(W)
    % Partition not found in the waiting list, so let's add it
    W{end+1} = P;
end

end