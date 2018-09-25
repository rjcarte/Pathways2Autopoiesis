function object = uniformPick (gdist)

% Randomly select object from uniform probability distribution

r = rand(1);

I = find(gdist >= r);

object = I(1);

end
