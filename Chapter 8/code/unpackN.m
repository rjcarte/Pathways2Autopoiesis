% Unpack N information from cell to a 2-columned vector

function N = unpackN(cellN)

a = 0;
b = 0;
N = [];

for i=1:length(cellN)
    thisN = cellN{i};
    b = a + size(thisN,1);
    N(a+1:b,:) = thisN;
    b = length(N);
    a = length(N);
end

end
    