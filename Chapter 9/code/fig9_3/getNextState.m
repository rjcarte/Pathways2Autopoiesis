function nextState = getNextState(A,B,lookup)

[I,J]=find(lookup(:,1)==A);
[K,L]=find(lookup(I,2)==B);

nextState=I(K);

end