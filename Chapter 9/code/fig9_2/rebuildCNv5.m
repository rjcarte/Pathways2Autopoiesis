% Creates a cognitive niche
%
% INPUTS:
%
% G - interaction matrix for the machine types
%
% OUTPUTS:
%
% CN - the new cognitive niche
% f - the absolute frequency of the machine types in the niche
% nf - the normalised frequency of machine types in the niche

function CN = rebuildCNv5(G)

CN=[];
a=1;

for i=1:length(G)
    thisNode = G(i,:);
    [I] = find(thisNode>0);
    thisCN = zeros(1,2);
    if ~isempty(I)
        for j=1:length(I)
            thisCN(j,1) = i;
            thisCN(j,2) = I(j);
            CN(a,:) = thisCN(j,:);
            a=a+1;
        end
    else
        CN(a,:) = [i -1];
        a=a+1;
    end
end

end