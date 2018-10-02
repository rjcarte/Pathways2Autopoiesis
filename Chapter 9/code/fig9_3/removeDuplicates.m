function Tc = removeDuplicates(Tc)

i=1;

% Remove duplicate entries in the List
while i <= size(Tc,1)
    j=1;
    while j <= size(Tc,1)
        if isequal(Tc(i,:),Tc(j,:)) && i~=j
            Tc(j,:)=[];
            j=1;
        else
            j=j+1;
        end
    end
    i=i+1;
end

end