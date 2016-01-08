function result=split(img);
siz=size(img);
n3=2;
labels(1)=0;
for(n=1:siz(2))
    column=img(:,n);
    for(n2=1:siz(1))
        if(not(ismember(labels(:),column(n2))))
            labels(n3)=column(n2);
            result(n3-1)=struct('image',trimImageHorizontal(not(img==labels(n3))));
            n3=n3+1;
        end;
    end;
end