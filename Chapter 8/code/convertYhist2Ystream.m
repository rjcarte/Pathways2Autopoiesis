% Converts all Y histories into a |T| x |Z| binary matrix
% Only the first column, representing P(x=0) for each automaton node, is
% captured
%
% INPUTS
%
% Y
% dim - eg. just one bitstream ('1') or both bitstreams ('2')
%
% OUTPUTS
%
% Ystream

function Ystream = convertYhist2Ystream (Y,dim)

% No. of automata
T = size(Y{1},1);
Ystream = zeros(length(Y),T);

for i=1:T
    Ystream(:,i) = convertY2stream(Y,i,dim);
end

end