function [ bin ] = numbinarify( image )
%NUMBINARIFY Turns a given lp into a binary image.
%   Detailed explanation goes here
    %%
    proc = dip_image(rgb2gray( image ));
    %%
    % Sharpen to improve results for smaller signs. Could be made optional
    % for larger images.
    proc = proc - 2 * laplace(proc);
    %%
    proc = ~threshold(proc, 'isodata', Inf);
    
    %%
    proc = opening(proc, 2);
    %%
    bin = proc;
end

