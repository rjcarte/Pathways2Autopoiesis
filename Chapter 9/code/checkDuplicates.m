% Sometimes the composition generates (even after minimisation) transitions
% with duplicate symbols off it.
function duplicate = checkDuplicates(L,candidate)

duplicate = 0;
a=1;

for i=1:size(L,1)
    if L(i,1) == candidate(1,1) && L(i,2) == candidate(1,2)
        duplicate = 1;
    end
end

end