%Launch GUI, etc.

clc;

%Settings
%...

%Handle unclean exit from last run or when gui still open
if exist('gui', 'var') && ~isempty(gui.fig)
    delete(gui.fig);
end

clearvars gui processing;

%Set global variables
global gui processing;

%Initialise
gui        = gui_class();
processing = processing_class();

%Add all parent folders to path
%Makes functions/classes accessible to scripts in folders.
addpath('..', '-begin');
