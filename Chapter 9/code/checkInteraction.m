function interaction = checkInteraction(A,B,lookup)

[I,J]=find(lookup(:,1)==A);
[K,L]=find(lookup(I,2)==B);

interaction=lookup(I(K),3);

end