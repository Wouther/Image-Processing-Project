%Launch GUI, etc.

clc;
clearvars settings;
global settings;

%Settings
settings.show_processed_video = false; %Show processed video instead of raw file
settings.solution_file = '../resources/trainingSolutions.mat'; %File with
    % solutions to compare results with
settings.frame_divider = 5; %Only process every one in <this number> frames,
    % skip the rest. Set to 1 to process all frames.

%Handle unclean exit from last run or when gui still open
if exist('gui', 'var') && ~isempty(gui.fig)
    delete(gui.fig);
end

clearvars gui processing;

%Set global variables
global gui processing;

%Initialise
gui = gui_class();

%Automatically load a file (temporarily, for debugging)
while ~exist('gui', 'var')
    pause(0.1);
end
pause(1);
gui.load_file('..\resources\Trainingsvideo.avi');
