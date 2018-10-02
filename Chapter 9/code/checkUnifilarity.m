function T = checkUnifilarity (T)

% Retrieve all transitions possible by this object
transitions = unique(T(:,2));

for i=1:length(transitions)
    [I] = find(T(:,2)==transitions(i));
    startState = T(I,1);
    [n,bin] = histc(startState, unique(startState));
    multiple = find(n>1);
    if ~isempty(multiple)
        % Invalid machine
        T = [];
        break
    end
end

end