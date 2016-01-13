%Initialize Matlab (perform actions that are required only once per session)

%% Add subfolders and all parent folders to path
%Makes functions/classes accessible to scripts in folders.
addpath('process_frame', '-begin');
addpath('..',            '-begin');

%% Load data for character recognition
disp('Loading data for character recognition...');
global letters numbers minussign forms;
load('..\resources\data.mat');

%% Initialize DIPimage for use in test_process_frame()
disp('Initializing DIPimage...');
run('C:\Program Files\DIPimage 2.7\dipstart.m');


disp('Done.');
