%
%
% INPUTS:
% G - spatial matrix
% thisObjectCoords
% fn
% M - interaction matrix
% frequency - current frequency distribution of objects

function [M,frequency] = setCell(M,thisAutomatonCoords,fn,frequency,G)

A=0;B=0;C=0;

Msize = size(M,1);

if thisAutomatonCoords(1) == 1
    % Cell is on top boundary
    if thisAutomatonCoords(2) == 1
        % Cell is in the top-left corner
        switch fn
            case 1
            % A(i-1,j),B(i,j),C(i+1,j)
            A = M(Msize,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
            case 2
            % A(i+1,j),B(i,j),C(i-1,j)
            A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(Msize,thisAutomatonCoords(2));
            case 3
            % A(i,j-1),B(i,j),C(i,j+1)
            A = M(thisAutomatonCoords(1),Msize);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
            case 4
            % A(i,j+1),B(i,j),C(i,j-1)
            A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),Msize);     
       end
    
    elseif thisAutomatonCoords(2) == Msize
        % Cell is in the top-right corner
        switch fn
            case 1
            % A(i-1,j),B(i,j),C(i+1,j)
            A = M(Msize,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
            case 2
            % A(i+1,j),B(i,j),C(i-1,j)
            A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(Msize,thisAutomatonCoords(2));
            case 3
            % A(i,j-1),B(i,j),C(i,j+1)
            A = M(thisAutomatonCoords(1),Msize);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),1);
            case 4
            % A(i,j+1),B(i,j),C(i,j-1)
            A = M(thisAutomatonCoords(1),1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
       end
    else
        % Cell is on the top boundary but not in a corner
        switch fn
            case 1
            % A(i-1,j),B(i,j),C(i+1,j)
            A = M(Msize,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
            case 2
            % A(i+1,j),B(i,j),C(i-1,j)
            A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(Msize,thisAutomatonCoords(2));
            case 3
            % A(i,j-1),B(i,j),C(i,j+1)
            A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
            case 4
            % A(i,j+1),B(i,j),C(i,j-1)
            A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
       end
    end    
elseif thisAutomatonCoords(1) == Msize
    % Cell is on bottom boundary
    if thisAutomatonCoords(2) == 1
        % Cell is in the bottom-left corner
        switch fn
            case 1
            % A(i-1,j),B(i,j),C(i+1,j)
            A = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(1,thisAutomatonCoords(2));
            case 2
            % A(i+1,j),B(i,j),C(i-1,j)
            A = M(1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
            case 3
            % A(i,j-1),B(i,j),C(i,j+1)
            A = M(thisAutomatonCoords(1),Msize);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
            case 4
            % A(i,j+1),B(i,j),C(i,j-1)
            A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),Msize);     
       end
    elseif thisAutomatonCoords(2) == Msize
        % Cell is in the bottom-right corner
        switch fn
            case 1
            % A(i-1,j),B(i,j),C(i+1,j)
            A = M(Msize,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(1,thisAutomatonCoords(2));
            case 2
            % A(i+1,j),B(i,j),C(i-1,j)
            A = M(1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
            case 3
            % A(i,j-1),B(i,j),C(i,j+1)
            A = M(thisAutomatonCoords(1),thisAutomatonCoords(1)-1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),1);
            case 4
            % A(i,j+1),B(i,j),C(i,j-1)
            A = M(thisAutomatonCoords(1),1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
       end
    else
        % Cell is on the bottom boundary but not in a corner
        switch fn
            case 1
            % A(i-1,j),B(i,j),C(i+1,j)
            A = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(1,thisAutomatonCoords(2));
            case 2
            % A(i+1,j),B(i,j),C(i-1,j)
            A = M(1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
            case 3
            % A(i,j-1),B(i,j),C(i,j+1)
            A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
            case 4
            % A(i,j+1),B(i,j),C(i,j-1)
            A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
       end
    end
elseif thisAutomatonCoords(2) == 1
    % Cell is on left boundary but not in a corner
    switch fn
            case 1
            % A(i-1,j),B(i,j),C(i+1,j)
            A = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
            case 2
            % A(i+1,j),B(i,j),C(i-1,j)
            A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
            case 3
            % A(i,j-1),B(i,j),C(i,j+1)
            A = M(thisAutomatonCoords(1),Msize);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
            case 4
            % A(i,j+1),B(i,j),C(i,j-1)
            A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),Msize);     
    end
elseif thisAutomatonCoords(2) == Msize
        % Cell is on the right boundary but not in a corner
        switch fn
            case 1
            % A(i-1,j),B(i,j),C(i+1,j)
            A = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
            case 2
            % A(i+1,j),B(i,j),C(i-1,j)
            A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
            case 3
            % A(i,j-1),B(i,j),C(i,j+1)
            A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),1);
            case 4
            % A(i,j+1),B(i,j),C(i,j-1)
            A = M(thisAutomatonCoords(1),1);
            B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
            C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
        end
else
    % Cell is not on a boundary
    switch fn
    
    case 1
        % A(i-1,j),B(i,j),C(i+1,j)
        A = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
        B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
        C = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
        
    case 2
        % A(i+1,j),B(i,j),C(i-1,j)
        A = M(thisAutomatonCoords(1)+1,thisAutomatonCoords(2));
        B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
        C = M(thisAutomatonCoords(1)-1,thisAutomatonCoords(2));
        
    case 3
        % A(i,j-1),B(i,j),C(i,j+1)
        A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);
        B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
        C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
       
    case 4
        % A(i,j+1),B(i,j),C(i,j-1)
        A = M(thisAutomatonCoords(1),thisAutomatonCoords(2)+1);
        B = M(thisAutomatonCoords(1),thisAutomatonCoords(2));
        C = M(thisAutomatonCoords(1),thisAutomatonCoords(2)-1);     
    end
end

% Check if interaction exists
    if G(A,C) > 0
        M(thisAutomatonCoords(1),thisAutomatonCoords(2))=G(A,C);
        % Increment that object type's frequency
        incObject = frequency(G(A,C));
        incObject = incObject + 1;
        frequency(G(A,C)) = incObject;

        % Decrement the frequency of the object type that it replaces 'Tb'
        replace=frequency(B);
        replace=replace-1;
        frequency(B) = replace;
    end
end
