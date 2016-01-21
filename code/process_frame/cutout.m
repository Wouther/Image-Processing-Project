function [cutres, numb] = cutout(mask, image)
   %% Find the four corner points.
   [ypos, xpos] = find(mask);
   
   [unused, pos] = min(xpos-ypos);
   bl = [xpos(pos), ypos(pos)]; % Top Left
   %bl = [ypos(pos), xpos(pos)]; % Top Left
   
   [unused, pos] = max(xpos-ypos);
   tr = [xpos(pos), ypos(pos)]; % Top Right
   %tr = [ypos(pos), xpos(pos)]; % Top Right
   
   [unused, pos] = max(xpos+ypos);
   br = [xpos(pos), ypos(pos)]; % Bottom Left
   %br = [ypos(pos), xpos(pos)]; % Bottom Left
   
   [unused, pos] = min(xpos+ypos);
   tl = [xpos(pos), ypos(pos)]; % Bottom right
   %tl = [ypos(pos), xpos(pos)]; % Bottom right
   % Is this a licensep: 2 = yes, 1 = probably not, 0 = nope.
   
   numb = 2;
   %% Constants and stuff.
   height = 40;
   width = 128;
   %height = 38;
   %width = 174;
   %fixedPoints = [tl; tr; br; bl];
   %movingPoints = [1 1; width 1; width height; 1 height];
   fixedPoints = [tl; bl; br; tr];
   movingPoints = [1 1; 1 height; width height; width 1];
   %fix = [tl; bl; br; tr];
   %mov = [1 1; height 1; height width; 1 width];
   %% Tansform
   % From https://stackoverflow.com/questions/21818151/display-image-between-four-corner-points-matlab
   % Also with some help from Youri.
   try
   img = rgb2gray(image);
   TFORM = fitgeotrans(fixedPoints,movingPoints,'projective');
   R=imref2d(size(img),[1 size(img,2)],[1 size(img,1)]);
   cutres=imcrop(imwarp(image,R,TFORM,'OutputView',R), [1 1 width height]);
   %cutres=imwarp(image,TFORM);
   catch ME
      cutres = 0;
      numb = 0; 
   end
   
% Old approach below, I slightly gave up since I would also have to do
% interpolation, and this would probably be slower than a built in matrix
% matlab thingy.
%    cutres = double(zeros(height, width));
%    
%    tophorz = (tl - tr)/width;
%    leftvert = (tl - bl)/height;
%    bottomhorz = (bl - br)/width;
%    rightvert = (tr - br)/height;
%    %% Compute pixel locations.
%    yvec = [1:height]/double(height);
%    yvec = repmat(yvec', 1, 2);
%    yvec = yvec .* repmat(rightvert, height, 1) + (1-yvec) .* repmat(leftvert, height, 1);
%    
%    xvec = [1:width]/double(width);
%    xvec = repmat(xvec', 1, 2);
%    xvec = xvec .* repmat(bottomhorz, width, 1) + (1-xvec) .* repmat(tophorz, width, 1);
%    %%
%    for y = 1:height
%       for x = 1:width
%           pos = tl + xvec(x) + yvec(y);
%       end
%    end
   
end

