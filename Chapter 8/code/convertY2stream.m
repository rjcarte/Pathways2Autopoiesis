% Converts a Y history into a single binary stream for a given automaton
% type
%
% INPUTS
%
% Y - the cell array history of output of all nodes in an information niche
% a - the index of the automaton
%
% OUTPUTS
%
% S - the bitstream that captures P(x=0) output from automaton i across a
% time series

function S = convertY2stream (Y,a,dim)

S = zeros(length(Y),dim);

for i=1:length(Y)
    thisY = Y{i};
    if dim == 1
        S(i) = thisY(a,1);
    else
        S(i,:) = thisY(a,:);
    end
end
end
    