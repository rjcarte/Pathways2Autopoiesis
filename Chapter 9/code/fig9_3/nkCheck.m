% According to Ref: Johnson(2010) a valid e-machine must have no more than
% nk-1 transitions (otherwise it is not minimal)
%
% 'symbols' is always set to 4 (0|0,0|1,1|0,1|1) in our universe of e-machines
% INPUT:
% Tc - machine to test
%
% OUTPUT:
% nk = 0 (fails the nk rule); nk = 1 (passes the nk rule)

function nk = nkCheck(Tc)

dims=checkMachineDim(Tc);
symbols = 4;

% The nk-1 rule does not apply to 1-state e-machines
if dims > 1
    if size(Tc,1) > ((dims*symbols)-1)
        nk = 0;
    else
        nk = 1;
    end
else
    nk = 1;
end

end