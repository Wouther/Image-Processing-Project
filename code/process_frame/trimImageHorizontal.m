function img =trimImage(image)
    siz=size(image);
    offsetLeft=0;
    offsetRight=0;


    for(n=1:siz(2))
        if(sum(image(:,n),1)==siz(1))
            offsetLeft=offsetLeft+1;
        else
            break;
        end;
    end;
    for(n=siz(2):-1:1)
        if(sum(image(:,n),1)==siz(1))
            offsetRight=offsetRight+1;
        else
            break;
        end;
    end;
    left=offsetLeft+1;
    right=siz(2)-offsetRight;
    img=image(:,left:right);
end