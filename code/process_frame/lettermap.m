%Checks an image and performs character recognition based on sum of xor
%errors. It only checks against the characters in the array argument.
function [l,e] = lettermap(image,array,xormax)
    y=size(array);
    y=y(2);
    character='E';
    max=xormax;
    for(n=1:y)
        x=xor(array(n).image,image);
        s=sum(sum(x));
        if(s<max)
            max=s;
            character=array(n).letter;
        end;
    end;
    l=character;
    e=max;
end