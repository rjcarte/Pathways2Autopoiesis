% Find the list type from the lists vector
%
% INPUT: list (object in list form)
%           lists (all object types in list form)
%
% OUTPUT: index of the matching list in Lists vector

function index = findList(list,lists)

index = 0;
mlist = mirrorList(list);

for i=1:length(lists)
        match1 = compareLists(list,lists{i});
        match2 = compareLists(mlist,lists{i});
    if match1 > 0 || match2 > 0
        index = i;
        break;
    end
end

end