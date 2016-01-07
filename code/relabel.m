function result=relabel(img);
size=size(img);
n3=2;
labels(1)=0;
for(n=1:size(1))
    column=img(:,n);
    for(n2=1:size(column(2)))
        if(not(ismember(labels(),column(n2))))
            labels(n3)=column(n2);
            n3=n3+1;
            break;
        end;
    end;
end;
for (n=2:size(labels))
    x=lables(n);
    image(:,:,n-1)=(img==x);
    image(:,:,n-1)=image(:,:,n-1)*(n-1);
end;
result=sum(image,3);
end