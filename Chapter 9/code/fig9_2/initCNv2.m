% Creates a cognitive niche.
% ONLY USE THIS FUNCTION FOR AN INITIAL POPULATION OF SELF-REPLICATORS
%
% INPUTS:
%
% types - the index of machine types in the cognitive niche
% G - interaction matrix for the machine types
% mu - initial population size (absolute integer)
%
% OUTPUTS:
%
% CN - the new cognitive niche
% f - the absolute frequency of the machine types in the niche
% nf - the normalised frequency of machine types in the niche

function [CN,f,nf] = initCNv2(G,mu)

f = zeros(1,length(G));
nf = zeros(length(G),2);

CN=[];
a=1;

% Build the cognitive network from G
for i=1:length(G)
    thisNode = G(i,:);
    [I] = find(thisNode>0);
    thisCN = zeros(1,2);
    
    for j=1:length(I)
        thisCN(j,1) = i;
        thisCN(j,2) = I(j);
        CN(a,:) = thisCN(j,:);
        a=a+1;
    end
end

% If no entries in G for a machine (i.e. an alien species that has fluxed
% in and cannot interact with other machines)
% Then add it to the CN but have end node as self-referencing - we will check for this
% later on

% Check dims
if ~isempty(CN)
    if length(G) > length(unique(CN(:,1)))
        for i=1:length(G)
            if sum(G(i,:)) == 0
                % Doesn't produce any machines; make it self-referencing (it
                % can't produce itself anyway!)
                thisCN(1,1)=i;
                thisCN(1,2)=i;
                CN(end+1,:) = thisCN(1,:);
            end
        end
    end
else
    for i=1:length(G)
        thisCN(1,1)=i;
        thisCN(1,2)=i;
        CN(end+1,:)=thisCN(1,:);
    end
end

for k=1:length(G)
    f(k) = round(mu / length(G));
    nf(k,1) = 1/length(G);
    nf(k,2) = 1;
end

end