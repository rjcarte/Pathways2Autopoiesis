function pop = convertPopCell2Matrix (popDynamics)

vectorLength = length(popDynamics{1,:});

pop = zeros(size(popDynamics,1),vectorLength);

for i=1:length(popDynamics)
    thisPop = popDynamics{i};
    pop(i,:) = thisPop(:,1);
end

end