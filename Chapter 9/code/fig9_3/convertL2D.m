% Convert list to digraph format for use in creating a MATLAB digraph
% object.
%
% MATLAB digraph doesn't like duplicate edges (i.e. 0|0 and 0|1 transition
% from state A to state B). This is ok as we only need to show the edges,
% not the symbols over those edges.
%
% INPUTS:
%
% L - list to convert
%
% OUTPUTS:
%
% [s,t] - digraph elements

function [s,t] = convertL2D (L)

a=1; b=2;
backL = L;

L(:,2)=0;

% Remove duplicate edges from L
while a < size(L,1)
    while b <= size(L,1)
        A = L(a,:);
        B = L(b,:);
        if A==B
            L(b,:)=[];
            a=1;
            b=2;
        else
            b=b+1;
        end
    end
    a=a+1; b=a+1;
end

for i=1:size(L,1)
    s(i) = L(i,1);
    t(i) = L(i,3);
end

end