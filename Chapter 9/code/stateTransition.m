% Perform state transition of an object
%
% INPUTS:
%
% currentState
% transition - the transition that the object is taking from the current
% state
% T - the object
%
% OUTPUT
%
% nextState

function nextState = stateTransition (currentState,transition,T,node)

backT=T;

[I] = find(T(:,1)==currentState);
T = T(I,:);
[J] = find(T(:,2)==transition);

if isempty(J)
    keyboard
elseif length(J) > 1
    
else
    nextState = T(J,3);
end

end