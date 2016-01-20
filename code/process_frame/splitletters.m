% Takes a labeled image and splits it into seperate letters.

function result=splitletters(img)
    siz=size(img);
    n3=2;
    labels(1)=0;
    result(1)=struct('image',-1);
    for(n=1:siz(2))
        column=img(:,n);
        for(n2=1:siz(1))
            %If the current label is not yet used...
            if(not(any(column(n2)==labels)))
                %add the current label
                labels(n3)=column(n2);
                %splilt all pixels with this label in a seperate image with
                %horizontal trimming.
                result(n3-1)=struct('image',trimImageHorizontal(not(img==labels(n3))));
                n3=n3+1;
            end
        end
    end
end