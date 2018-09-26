function [G,swapObject] = spatialMixing(G,v,thisObjectCoords)

thisX = thisObjectCoords(1);
thisY = thisObjectCoords(1,2);

n = size(G,2);
x = -(n/2):1:(n/2)-1;

% Define parameters
mu = 0;

% Generate distribution
norm = normpdf(x,mu,v);

sumNorm = sum(norm);

norm = norm/sumNorm;

cumNorm=cumsum(norm);

% Select item from cumulative distribution
range = 0;
while range == 0
    r1 = rand(1);
    if r1 >= cumNorm(end)
        range = 0;
    else
        range = 1;
    end
end

% Find the object to replace
J = find(cumNorm>=r1);

% Select distance of object to swap location with
p = J(1);

% Distance of this object from the mean
d = abs(p - ceil(n/2));

% Select object from one of four possible positions
r2 = rand(1);

if r2 < 0.25
    % Upward location
    swapTx = thisX;
    swapTy = thisY + d;
    if swapTy > n
        swapTy = swapTy-n;
    end
elseif r2 >= 0.25 && r2 < 0.5
    % Downward location
    swapTx = thisX;
    swapTy = thisY - d;
    if swapTy < 1
        swapTy = swapTy + n;
    end
elseif r2 >= 0.5 && r2 < 0.75
    % Left location
    swapTy = thisY;
    swapTx = thisX - d;
    if swapTx < 1
        swapTx = swapTx + n;
    end
else
    % Right location
    swapTy = thisY;
    swapTx = thisX + d;
    if swapTx > n
        swapTx = swapTx-n;
    end
end

if swapTx <= 0 || swapTy <= 0 || swapTx > n || swapTy > n
    keyboard
end

thisObject = G(thisX,thisY);
swapObject = G(swapTx,swapTy);

G(thisX,thisY) = swapObject;
G(swapTx,swapTy) = thisObject;

end