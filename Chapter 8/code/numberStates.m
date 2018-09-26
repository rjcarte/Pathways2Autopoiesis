function S = numberStates (lists)

for i=1:length(lists)
    thisList = lists{i};
    S(i) = length(unique(thisList(:,1)));
end

end