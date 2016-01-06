%Select a file and check if it exists and is supported
%Optionally accepts a (path to a) file as an argument, otherwise displays
% system selection dialogue. Returns boolean whether the file is accepted
% and path to file, respectively.
%Accepts both video and image files. Returns whether the file is a video as
% a boolean.
function [accepted, fpath, is_video] = select_file(varargin)
    %Initialize
    accepted = false; %reject file by default
    fpath    = [];
    is_video = false;

    %Select file
    if nargin == 0 %no argument passed
        [fname, ffolder] = uigetfile('../resources/*.avi');
        if fname == false %dialogue was dismissed
            return;
        end
        fpath = [ffolder fname];
    else
        fpath = varargin{1};
    end

    %Check existance
    if exist(fpath, 'file') ~= 2
        fprintf('Error: file "%s" does not exist.\n', fpath);
        return;
    end

    %Check if format supported
    [~, ~, fext] = fileparts(fpath);
    fext = fext(2:end); %remove leading period
    ext_video = VideoReader.getFileFormats(); %supported video file extensions
    ext_image = imformats;                    %supported image file extensions
    is_video  = any(ismember({ext_video.Extension}, fext));
    is_image  = any(ismember([ext_image.ext],       fext));
    if ~(is_video || is_image)
        fprintf('Error: Unsupported file type (not a video or an image).\n');
        return;
    end
    
    %Not rejected upto now, so accept file
    accepted = true;
end