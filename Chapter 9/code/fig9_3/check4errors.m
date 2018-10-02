function check = check4errors(CN,G,Y,types,frequency,f)

CN = CN{:};

CNsize = length(unique(CN(:,1)));
Gsize = size(G,1);
Ysize = size(Y,1);
typeSize = length(types);
frequencySize = length(frequency);
fSize = length(f(:,1));

check = [CNsize Gsize Ysize typeSize frequencySize fSize];

end