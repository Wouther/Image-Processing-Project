%Tests the processing of single frame
%That is: opens image file and calls process_frame(). Optionally accepts two
% two arguments: a (path to a) file and a timestamp (in seconds) in case
% of a video file. If not passed, the user will be asked for these.
%Returns detected license plate as string, empty string if none detected.
% Also returns (path to) the file processed.
function [license_plate, fpath]  = test_process_frame(varargin)
    addpath('..', '-begin'); %add parent folder to path
    
    license_plate = []; %initialize, no license plate found
    
    %Select file
    if nargin < 1 %no file passed as first argument
        [accepted, fpath, is_video] = select_file();
    else
        [accepted, fpath, is_video] = select_file(varargin{1});
    end
    
    if ~accepted
        return;
    end
    
    %Read image
    if is_video %file is video
        %Select frame
        if nargin < 2 %no timestamp passed as second argument
            frame.timestamp = input('Video file detected. Enter timestamp of frame to be processed: ');
        else
            frame.timestamp = varargin{2};
        end
        
        if ~isnumeric(frame.timestamp)
            fprintf('Error: Timestamp ''%i'' is not a number.\n', frame.timestamp);
            return;
        end
        
        %Read video frame
        vid = VideoReader(fpath);
        vid.CurrentTime = frame.timestamp;
        if hasFrame(vid)
            frame.image     = readFrame(vid);
            frame.timestamp = vid.CurrentTime; %update in case next frame was grabbed
        else
            fprintf('Error: this frame is not available.\n');
            return;
        end
    else %file is image
        %Read image
        frame.image = imread(fpath);
    end
    
    %Process frame and display frame and result
    [license_plate, frame.image_processed] = process_frame(frame.image);
    if ~isempty(license_plate)
        fprintf('License plate found: %s.\n', license_plate);
    else
        fprintf('No license plate found.\n');
    end
    
    %Show processed frame
    ax = axes();
    image(frame.image, 'Parent', ax);
    ax.Visible = 'Off';
end