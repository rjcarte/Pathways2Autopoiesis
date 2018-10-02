function set = findPartitionSet(P,state)

for i=1:length(P)
    
    I = intersect(P{i},state);
    if ~isempty(I)
        % The state is in this set, return the value i
        set = i;
        break;
    end
end

end