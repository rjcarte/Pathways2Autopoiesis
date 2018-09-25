function M = generateLattice ()

n = 300;
M = zeros(n,n,'uint8'); % Create the lattice
INITTYPE = 15;

% Create a uniform probability distribution of all object types
mdist=zeros(1,INITTYPE);
mdist(1:INITTYPE) = 1/INITTYPE;
mdist = cumsum(mdist);

% Randomly populate the matrix M by uniform selection from all object types
for i=1:n
    for j=1:n
        thisM = 0;
        thisM = uniformPick(mdist);
        M(i,j) = thisM;
    end
end

end