function L = mirrorList(L)

% 11 -> 22
% 12 -> 21
% 21 -> 12
% 22 -> 11

for i=1:size(L,1)
    L1=L(i,1);
    L3=L(i,3);
    if L1==1 && L3==1
        L(i,1) = 2;
        L(i,3) = 2;
    elseif L1==1 && L3==2
        L(i,1) = 2;
        L(i,3) = 1;
    elseif L1==2 && L3==1
        L(i,1) = 1;
        L(i,3) = 2;
    elseif L1==2 && L3==2
        L(i,1) = 1;
        L(i,3) = 1;
    end
end

end