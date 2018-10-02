function object = reLabel(object)

if isempty(object)
    keyboard
end

count1=unique(object(:,1));
count2=unique(object(:,3));
count=count1;
count(end+1:length(count1)+length(count2))=count2;
count=unique(count);

back=object;

for i=1:length(count)
    [I1,J1]=find(object(:,1)==count(i));
    [I2,J2]=find(object(:,3)==count(i));
    I=I1; I(end+1:length(I1)+length(I2))=I2;
    J=J1; J(end+1:length(J1)+length(J2))=J2;
    
    for j=1:size(I1,1)
        object(I1(j),1)=i;
    end
    for k=1:size(I2,1)
        object(I2(k),3)=i;
    end
end

end