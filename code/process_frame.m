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
    global chardata; %Temporary. TODO: load it somewhere.
    %load ../../resoures/chardata.mat; %Error incorrect path if done here?
    license_plate = lettermap(plate_img, chardata, 1000);
    
    processed_img = plate_img; %temporarily as test
end
