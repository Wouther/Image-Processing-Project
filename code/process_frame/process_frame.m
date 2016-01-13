%Processes a single video frame
%Frame image passed as argument.
%Returns detected license plate as string, empty string if none detected.
%Also returns a processed version of the frame (image) for display / debugging.
function [license_plate, processed_img] = process_frame(img)
    license_plate = []; %initialize, no license plate found

    %Find license plate in image
    plate_img = nummerbordvinder(img);
    plate_img = plate_img{1}; %Temporary. TODO: add possibility to
        % process multiple license plates

    %Convert to binary image
    plate_img = numbinarify(plate_img);

    %Perform character recognition on license plate image
    tmp_img = label(plate_img);
    tmp_img = dip_array(tmp_img);
    tmp_img = splitletters(tmp_img);
    global chardata;
    license_plate = letterMapWrapper(tmp_img, ...
        chardata.letters, chardata.numbers, chardata.minussign, chardata. forms, 100000);
    
    processed_img = plate_img; %temporarily as test
end
