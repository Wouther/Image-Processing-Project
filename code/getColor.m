function y = getColor(img,color,threshold)
a(:,:,1)=img(:,:,1,:)-color(1);
a(:,:,2)=img(:,:,2,:)-color(2);
a(:,:,3)=img(:,:,3,:)-color(3);
b=sum(abs(a),3);
y=b<(threshold);
end