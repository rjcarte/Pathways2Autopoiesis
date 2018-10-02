function Gseed = convertSeed2Unconstrained(Gseed)

[I,J] = find(Gseed == 0);

for i=1:length(I)
        Gseed(I(i),J(i))=-1;
end

end