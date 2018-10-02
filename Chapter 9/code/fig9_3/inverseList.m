% Creates inverse transition lookup table
%
% Column order is: receiving state | symbol pair | sending state
%
% Rich Carter

function L = inverseList (L)

%if iscell(L)
%    L = L{:};
%end

for i=1:size(L,1)
    L1=L(i,1);
    L3=L(i,3);
    L(i,1)=L3;
    L(i,3)=L1;
end

end