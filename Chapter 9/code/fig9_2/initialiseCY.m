% Generates the output probability distribution of each node in a cognitive
% niche network
%
% INPUTS:
%
% types - the list of cognitive niche machine types
%
% OUTPUT:
%
% Y - the output probability distribution of each type

function Y = initialiseCY (types)

Y = zeros(length(types),2);

for i=1:length(types)
    Y(i,:) = convertList2Y(types(i));
end

end