function result = checkNullTypes(types)

result = 0;

for i=1:length(types)
    if isempty(types{i})
        result = 1;
    end
end

end