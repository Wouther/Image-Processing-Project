% Considers all nummerbord-formats and picks the most likely(least amount of
% xor errors). returns 'e' for nummerbords with incorrect length in
% symbols.

function l = letterMapWrapper(img, xormax)
    global chardata;
    siz=size(img);
    siz=siz(2);
    siz2=size(chardata.forms);
    siz2=siz2(1);
    tmp=zeros(3,siz);
    errors=zeros(3,siz2);
    sums=zeros(1,siz2);
    
    if(siz~=8)
        l='e';
        return;
    end
    for(n=1:siz)
        images(n)=struct('image',imresize(img(n).image,chardata.defaultsize));
    end;
    for(n=1:siz)
        [tmp,tmp2]=lettermap(images(n).image,chardata.letters,xormax);
        errors(1,n)=tmp2;
        chars(1,n)=tmp;
    end;
    for(n=1:siz)
        [tmp,tmp2]=lettermap(images(n).image,chardata.numbers,xormax);
        errors(2,n)=tmp2;
        chars(2,n)=tmp;
    end;
    for(n=1:siz)
        [tmp,tmp2]=lettermap(images(n).image,chardata.minussign,xormax);
        errors(3,n)=tmp2;
        chars(3,n)=tmp;
    end;
    for(n=1:siz2)
        tmp(1)=0;
        for(n2=1:siz)
            tmp(n2)=errors(chardata.forms(n,n2),n2);
        end;
        sums(n)=sum(tmp);
    end;
    max=1000000;
    result=0;
    for(n=1:siz2)
        if(sums(n)<max)
            max=sums(n);
            result=n;
        end;
    end;
    form=chardata.forms(result,:);
    for(n=1:siz)
        l(n)=chars(form(n),n);
    end;

end