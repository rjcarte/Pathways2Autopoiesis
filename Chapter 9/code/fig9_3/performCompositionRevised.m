function [Tc,index] = performCompositionRevised(m1,m2,lookup,types)

Tc = [];
a=1; b=1; c=1;
m1=m1{:}; m2=m2{:};
index=0;

if isempty(m1) || isempty(m2)
    keyboard
end

% Determine dimensions of the interacting machines
m1Size = checkMachineDim (m1);
m2Size = checkMachineDim (m2);

% New object states
newMachineSize = m1Size * m2Size;

for a=1:m1Size
    for b=1:m2Size
        newStates(c,:)=[a b];
        c=c+1;
    end
end

d=1;

for i=1:m1Size
    for j=1:m2Size
        [I] = find(m1(:,1)==i);
        A = m1(I,:);
        [J] = find(m2(:,1)==j);
        B = m2(J,:);
        for k=1:size(A,1)
            for l=1:size(B,1)
                transition = checkInteraction(A(k,2),B(l,2),lookup);
                if transition > 0
                    thisState = getNextState(i,j,newStates);
                    nextState = getNextState(A(k,3),B(l,3),newStates);
                    newTransition = [thisState transition nextState];
                    if ~isempty(Tc)
                        duplicate = checkDuplicates(Tc,newTransition);
                        if duplicate == 0
                            Tc(d,:)=newTransition;
                            d=d+1;
                        end
                    else
                        Tc(d,:)=newTransition;
                        d=d+1;
                    end
                end
            end    
        end
    end
end

if ~isempty(Tc)
    % Check to see if we find a match in existing machine types
    Tc = reLabel(Tc);
    index = findList(Tc,types);
end

end