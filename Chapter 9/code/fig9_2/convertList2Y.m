% Converts a list of object types into 'Y' which is a 2-column vector
% showing the output probability distribution from each object type's
% transitions
%
% v1.1 - simplifying Y to only show the probability distribution (not the
% internal states of an object). This is because other objects only need to
% 'see' the output distribution; they don't need to 'see' the internal
% states of an object
%
% INPUTS:
% 
%   lists - the object types to be converted
%
% OUTPUT:
%
%   Y - the output probability distribution of each object type in 'lists'
%
% NOTES:
%
% The object type list uses the following code to represent each
% transition:
%
%   1 = 0|0
%   2 = 0|1
%   3 = 1|0
%   4 = 1|1
%
% The 2-columned vector with the following syntax:
%
% Y = [P(y==0) P(y==1)]

function Y = convertList2Y(lists)

Y = zeros(length(lists),2);

for i=1:length(lists)
    thisType = lists{i};
    y=zeros(1,2);
    for j=1:size(thisType,1)
        switch thisType(j,2)
            case 1
                y(1,1) = y(1,1) + 1;
            case 2
                y(1,2) = y(1,2) + 1;
            case 3
                y(1,1) = y(1,1) + 1;
            case 4
                y(1,2) = y(1,2) + 1;
        end        
    end
    y = y / sum(y);
    Y(i,:) = y;   
end

end