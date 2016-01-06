%Processes a single video frame
%Returns detected license plate as string or 'false' if none detected.
%Also returns a processed version of the frame (image) for display / debugging.
function [license_plate, processed_frame] = process_frame()
    global processing;
    f = processing.frame; %shorthand for clarity
    
    license_plate = []; %initialize, no license plate found
    
    processed_frame = ~f.image; %temporarily as test
    
end

