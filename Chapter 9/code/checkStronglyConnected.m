% Checks that a machine is strongly connected
% Uses MATLAB bioinformatics toolbox: digraph, conncomp
%
% Function also converts machine list format to [s,t] which is the standard
% required to construct a MATLAB generated digraph (which is required to
% use conncomp)
%
% Conncomp returns the number of strongly connected components in the
% graph. Given that we need all states to be reachable from all other
% states we are looking for a single strongly connected component. Hence,
% if there are more than one strongly connected component identified then
% we don't have a fully traversible machine and, as such, it is invalid.
%
% INPUTS:
%
% L - machine
%
% OUTPUTS:
%
% traversible - '0' not completely connected; '1' strongly connected single
% machine

function [traversible,str_bins] = checkStronglyConnected(L)

traversible = 1;

[s,t] = convertL2D(L);
G = digraph(s,t);
str_bins = conncomp(G);

check = unique(str_bins);

if length(check) > 1
    traversible = 0;
end

end