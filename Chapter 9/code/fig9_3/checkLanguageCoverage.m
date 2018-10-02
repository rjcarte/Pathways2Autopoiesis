% Check that the input language covered by Ta exists in Tc
function complete = checkLanguageCoverage(Ta,Tc)

language = Ta(:,2);
language = unique(language);

language2 = Tc(:,2);
language2 = unique(language2);

check = intersect(language,language2);

if length(check) < length(language)
    % Not a valid e-machine
    complete = 0;
else
    complete = 1;
end

end