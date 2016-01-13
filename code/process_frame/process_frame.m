%Processes a single video frame
%Frame image passed as argument.
%Returns detected license plate as string, empty string if none detected.
%Also returns a processed version of the frame (image) for display / debugging.
function [license_plate, processed_img] = process_frame(img)
    license_plate = []; %initialize, no license plate found
    
    %Find license plate in image
    plate_img = nummerbordvinder(img)
    plate_img = plate_img{1}; %Temporary. TODO: add possibility to
        % process multiple license plates
    
    %Convert to binary image
    plate_img = dip_image(rgb2gray(plate_img));
    plate_img = brmedgeobjs(~threshold(plate_img, 'Isodata', Inf));
    plate_img = opening(plate_img, 2); %remove some noise
    
    %Perform character recognition on license plate image
    tmp_img = label(plate_img);
    tmp_img = dip_array(tmp_img);
    tmp_img = split(tmp_img);
    load ../resources/charData.mat; %Error incorrect path if done here?
    for n = 1:size(tmp_img,2)
        license_plate(n) = lettermap(tmp_img(n).image, chardata, 1000);
    end;
    license_plate = char(license_plate);
    
    processed_img = plate_img; %temporarily as test
end