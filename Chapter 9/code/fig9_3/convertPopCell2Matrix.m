function pop = convertPopCell2Matrix (popDynamics)

vectorLength = length(popDynamics{end,:});

pop = zeros(size(popDynamics,1),vectorLength);

for i=1:length(popDynamics)
    
    thisPop = popDynamics{i};
    pop(i,1:length(thisPop)) = thisPop(:,1);
end

end