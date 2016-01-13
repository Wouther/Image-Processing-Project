function [ bin ] = numbinarify( image )
%NUMBINARIFY Turns a given lp into a binary image.
%   Detailed explanation goes here
    %%
    proc = dip_image(rgb2gray( image ));
    %%
    % Remove shadow
    afol = maxf(proc,11,'elliptic');
    proc = proc + (255 - afol);
    %%
    % Sharpen to improve results for smaller signs. Could be made optional
    % for larger images.
    proc = proc - 2 * laplace(proc);
    
    %% 
    % Some extra filtering for border pixels
    proc = maxf(proc, 2, 'elliptic');
    proc = minf(proc, 2, 'elliptic');
    %%
    proc = ~threshold(proc, 'isodata', Inf);
    
    %% Remove tiny noise 1
    proc =  bopening(proc, 1);
    
    %%
    bin = proc;
end

