
function match = compareLists(l1,l2)

match=0;

if size(l1,1) ~= size(l2,1)
    match = 0;
else
    i = 1;
    while i<=size(l1,1)
        match=0;
        l1row = l1(i,:);
        j=1;
        while j<=size(l2,1)
            l2row = l2(j,:);
            if isequal(l1row,l2row)
                l1(i,:)=[];
                l2(j,:)=[];
                i=1;
                j=size(l2,1)+1;
                match=1;
            else
                j=j+1;
            end
        end
        
        if match==0
            i=size(l1,1)+1;
        end
    end
end

end