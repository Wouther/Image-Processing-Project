function [ bin ] = numbinarify( image )
%NUMBINARIFY Turns a given lp into a binary image.
%   Detailed explanation goes here
    %%
    proc = dip_image(image(:, :, 1));
    %%
    % Remove shadow
    afol = maxf(proc,11,'elliptic');
    proc = proc + (255 - afol);
    %%
    % Sharpen to improve results for smaller signs. Could be made optional
    % for larger images.
    proc = proc - 4 * laplace(proc);

    %%
    proc = ~threshold(proc, 'isodata', Inf);
    
    %% Remove tiny noise 1
    procx =  bopening(proc, 1, 2, 0);
    proc = bpropagation(procx, proc, Inf, -1, 0);
    %%
    proc = brmedgeobjs(proc);
    %% Remove tiny noise 2.
    proc = label(proc, 2, 15); % Minimal size of any object is 15
    proc = proc > 0;
    %%
    bin = proc;
end

