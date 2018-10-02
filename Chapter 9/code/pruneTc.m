% Uses the results of a strongly connected test which shows the number of
% strong connected components. We are interested in the component with the
% greatest number of elements. 
% We take the elements of the largest strongly connected component and
% 'prune' Tc to remove anything NOT in that component

function Tc = pruneTc(Ta,Tb,Tc,str_bins)

components = unique(str_bins);
index = cell(1,length(components));

for i=1:length(components)
    [I] = find(str_bins==components(i));
    count(i) = length(I);
    index{i} = I;
end

if length(str_bins) == length(index)
    % No connections at all. Empty machine.
    Tc = [];
else

% Find the largest component
[Y,K] = max(count);
[C] = find(count==Y);

a=1;
% If more than one component then need to extract each machine and examine
% to see if any are isomorphic
if length(C) > 1
    % No distinguishing strongly connected component. So not a valid
    % machine but they may be isomorphic.
    %extracted = cell(1,length(C));
    extracted=[];
    for k=1:length(C)
        bins = index{k};
        newExtract = extractMachine(Tc,bins,str_bins);
        if ~isempty(newExtract)
            extracted{a} = newExtract;
            a=a+1;
        end
        %extracted{k}  = extractMachine(Tc,bins,str_bins);
    end
    
    if ~isempty(extracted)
    % Now we've extracted machines from the components, let's see if any
    % are isomorphic
    Tc = [];
    for l=1:length(extracted)-1
        isomorphic = checkIsomorphic(extracted{l},extracted(l+1));
        if isomorphic == 1
            Tc = extracted{l};
            complete1 = checkLanguageCoverage(Ta{:},Tc);
            complete2 = checkLanguageCoverage(Tb{:},Tc);
            if complete1 == 0 && complete2 == 0
                Tc = [];
            end
            %check = checkDomainAndRange(Ta,Tb,Tc);
            %if check == 0
            %    Tc = [];
            %end
        end
    end
    if isempty(Tc)
        % None of the extracted machines are isomorphic. So, let's pick the
        % one that is the largest component (i.e. has the most
        % transitions). If there are more than one of the same size then
        % pass back the first.
        machineSizes = zeros(length(extracted));
        for m=1:length(extracted)
            machineSizes(m) = size(extracted{m},1);
        end
        [value,ind] = max(machineSizes);
        Tc = extracted{ind(1)};
        complete1 = checkLanguageCoverage(Ta{:},Tc);
        complete2 = checkLanguageCoverage(Tb{:},Tc);
        if complete1 == 0 && complete2 == 0
            Tc = [];
        end
        %check = checkDomainAndRange(Ta,Tb,Tc);
        %if check == 0
        %    Tc = [];
        %end
    end
    end
elseif length(C) == 1
    Tc = extractMachine(Tc,index{C});
    complete1 = checkLanguageCoverage(Ta{:},Tc);
    complete2 = checkLanguageCoverage(Tb{:},Tc);
    if complete1 == 0 && complete2 == 0
        % Not a valid e-machine as it does not AT LEAST cover the language of its
        % parents
        Tc = [];
    end
    
    %check = checkDomainAndRange(Ta,Tb,Tc);
    %if check == 0
    %    Tc = [];
    %end
    %[I] = find(str_bins~=Y);
    %for j=1:length(I)
    %    k=1;
    %    while k <= size(Tc,1)
    %        if Tc(k,1) == I(j)
    %            Tc(k,:) = [];
    %            k=1;
    %        else
    %            k=k+1;
    %        end
    %    end
    %end
end
end
end