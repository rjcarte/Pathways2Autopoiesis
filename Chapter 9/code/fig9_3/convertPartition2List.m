% Converts partition (from minimisation procedure) to object list
% representation
%
% List: { start state , symbol pair, end state }

function L = convertPartition2List(P,d)

i=1; z=1;

% for each partition set in P
while i <= length(P)
    
    % Remove empty sets from P
    if isempty(P{i})
        P(i)=[];
    else
    
    thisPart = P{i};

    % for each state in this partition set
    for j=1:length(thisPart)
        
        % retrieve the transitions *to* this state
        [I,J]=find(d(:,1)==thisPart(j));

        % for each sending state to this state retrieve its partition set in P
        for k=1:length(I)
            %keyboard
            sending = d(I(k),3);
            % Find the partition set that the sending state is in
            set = findPartitionSet(P,sending);
            L(z,1) = set;
            L(z,2) = d(I(k),2);
            L(z,3) = i;
            z=z+1;
        end
    end
    i=i+1;
    end
end

L = removeDuplicates(L);

end