function [nummerborden] = nummerbordvinder(image)
    % Zoekt naar nummerborden.
    %% Threshold
    mskd = createMaskmatlabcolorthreshold(image);
    mskd = dip_image(mskd(:, :, 1)); % Strip off extra colors.
    %% Closing
    mskd = bopening(mskd, 3, -1, 0);
    mskd = bclosing(mskd, 15, -1, 0);
    %%
    mskd = label(mskd, 2, 100, 0);
    %%
    msr = measure(mskd,[],{'Size','Center','DimensionsCube','MajorAxes'},[],Inf,0,0);
    %nummerbordenvec = msr;
    nummerborden = cell(length(msr), 1);
    for i = 1:length(msr)
        r = imcrop(image, [msr(i).Center(1) - msr(i).DimensionsCube(1)/2, msr(i).Center(2) - msr(i).DimensionsCube(2)/2,  msr(i).DimensionsCube(1),  msr(i).DimensionsCube(2)]);
        nummerborden{i} = r;
    end
    %nummerborden = r;%imrotate(r, msr(1).MajorAxes(1) * 360, 'crop');
    