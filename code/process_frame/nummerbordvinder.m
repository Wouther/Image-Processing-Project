function [nummerborden] = nummerbordvinder(image)
    % Zoekt naar nummerborden.
    %% Threshold
    mskd = createMaskmatlabcolorthreshold(image);
    mskd = dip_image(mskd(:, :, 1)); % Strip off extra colors.
    %% Closing
    mskd = bclosing(mskd, 15, -1, 0);
    mskd = bopening(mskd, 3, -1, 0);
    %%
    mskd = label(mskd, 2, 100, 0);
    %%
    msr = measure(mskd,[],{'Size','Center','DimensionsCube','MajorAxes'},[],Inf,0,0);
    %nummerbordenvec = msr;
    df = 360/(2 * pi);
    nummerborden = cell(length(msr), 1);
    for i = 1:length(msr)
        angle = atan(msr(i).MajorAxes(2)/msr(i).MajorAxes(1));
        point = [msr(i).Center(1), msr(i).Center(2)];
        r = image;
        point = point - [size(r, 2) size(r, 1)]/2;
        rotmtx = [cos(angle) -sin(angle);
              sin(angle) cos(angle)];
        point = point * rotmtx;
        r = imrotate(r, angle * df);
        point = point + [size(r, 2) size(r, 1)]/2;
        r = imcrop(r, [point(1) - msr(i).DimensionsCube(1)/2, point(2) - msr(i).DimensionsCube(2)/2,  msr(i).DimensionsCube(1),  msr(i).DimensionsCube(2)]);
        nummerborden{i} = r;
    end
    % To get a binary image:
    % num = nummerbordvinder(img); proc = dip_image(rgb2gray(num{1})); proc = brmedgeobjs(~threshold(proc, 'Isodata', Inf));
    % Ex: 
    %num = nummerbordvinder(imread('test3.png'));  proc = dip_image(rgb2gray(num{1})); proc = opening(brmedgeobjs(~threshold(proc, 'Isodata', Inf)), 2)
    %nummerborden = 
    %nummerborden = r;
    