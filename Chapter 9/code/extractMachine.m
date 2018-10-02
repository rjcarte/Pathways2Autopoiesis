function T = extractMachine (Tc,bins,str_bins)

a=1;
T = [];

for i=1:size(Tc,1)
    if ~isempty(intersect(Tc(i,1),bins)) && ~isempty(intersect(Tc(i,3),bins))
        % Extract this transition
        T(a,:) = Tc(i,:);
        a=a+1;
    end
end

if ~isempty(T)
    T = reLabel(T);
end

end