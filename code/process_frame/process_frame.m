%Processes a single video frame
%Frame image passed as argument.
%Returns detected license plate as string, empty string if none detected.
%Also returns a processed version of the frame (image) for display / debugging.
function [license_plate, processed_img] = process_frame(img)
    license_plate = []; %initialize, no license plate found
    
    %Find license plate in image
    %img2 = nummerbordvinder(img)
    
    %Perform character recognition on license plate image
    %license_plate = ??? %TODO: how? Files added: getColor.m, getLetter.m and lettermap.m
    
    processed_img = img; %temporarily as test
end
