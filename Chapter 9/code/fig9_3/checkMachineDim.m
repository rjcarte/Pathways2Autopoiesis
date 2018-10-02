% Simply returns the number of states present in the machine (T)
%
% INPUTS
%
% T - the machine in list format
%
% OUTPUTS
%
% dim - integer value denoting number of states in T

function dim = checkMachineDim(T)

source = unique(T(:,1));
destination = unique(T(:,3));
combined = source;
combined(end+1:length(source)+length(destination)) = destination;
dim = length(unique(combined));

end