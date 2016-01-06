function letter = getLetter( image )
    height=size(image,1);
    n=1;
    i=0;
    p=0
    while(n<size(image,2))
        if(sum(image(:,n))<height)
            i=i+1;
            width=0;
            while (sum(image(:,n+width))<height)
                width=width+1;
                p=p+1;
            end;
            letter(i)=struct('letter','0','image',image(1:height,max(1,n-2):min(size(image,2),n+2+width)),'width',width);
            n=n+width+1;
        else
            n=n+1;
        end
    end
end
