function l = lettterMapWrapper(images, xormax)
    global chardata;
    
    siz=size(images);
    siz2=size(chardata.forms);
    tmp=zeros(3,siz);
    errors=zeros(3,siz2);
    sums=zeros(1,siz2);
    for(n=1:siz)
        [tmp,tmp2]=letterMap(images(n),chardata.letters,xormax);
        errors(1,n)=tmp2;
        chars(1,n)=tmp;
    end;
    for(n=1:siz)
        [tmp,tmp2]=letterMap(images(n),chardata.numbers,xormax);
        errors(2,n)=tmp2;
        chars(2,n)=tmp;
    end;
    for(n=1:siz)
        [tmp,tmp2]=letterMap(images(n),minus,xormax);
        errors(3,n)=tmp2;
        chars(3,n)=tmp;
    end;
    for(n=1:siz2)
        tmp(1)=0;
        for(n2=1:siz2)
            tmp(n2)=errors(chardata.forms(n,n2),n2);
        end;
        sum(n)=sum(tmp2);
    end;
    max=1000000;
    result=0;
    for(n=1:siz2)
        if(sum(n)<max)
            max=sum(n);
            result=n;
        end;
    end;
    form=chardata.forms(result);
    for(n=1:siz)
        l(n)=chars(form(n),n);
    end;

end