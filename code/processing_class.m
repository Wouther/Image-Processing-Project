%Holds data concerning processing status, etc.
%Uses gui object.
classdef processing_class < handle

    properties
        status; %0 if not processing
        file; %File being processed. Structure with fields 'path' and 'raw'.
        results; %Cell array with rows {'license plate', frame nr, timestamp}
    end
    
    methods
        
        %Constructor
        function self = processing_class()
            %Initialise
            self.status  = 0;
            self.file    = '';
            self.results = {};
        end
        
        function start(self)
            disp('Starting processing...');
            self.set_status(1);
            
            %TODO: processing stuff
            pause(1);
            
            disp('Done processing.');
            self.set_status(0);
        end
        
        %Add a new result to the table
        function add_result(self, text, frame, time)
            global gui;
            
            self.results(end+1,:) = {text, frame, time};
            gui.update_table_results();
        end
        
        %Load a file. Optionally accepts a (path to a) file as an argument,
        % otherwise displays system selection dialogue.
        function load_file(self, varargin)
            global gui;
            
            %Select file
            if nargin == 1 %no argument passed
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
            [~, fname, fext] = fileparts(fpath);
            fext = fext(2:end); %remove leading period
            supported_ext = VideoReader.getFileFormats();
            if ~any(ismember({supported_ext.Extension}, fext))
                fprintf('Error: VideoReader can''t read .%s files on this system.\n', fext);
                return;
            end
            
            %File accepted: store it
            self.file.path = fpath;

            %Update gui
            self.set_status(0);
            gui.clean();
            gui.update_textfield('text_file', [fname fext]);
            
            %TODO: load raw file in matlab, ready for processing
        end
        
        function set_status(self, value)
            global gui;
            
            %Update value
            self.status = value;

            %Update gui
            gui.update_button_start();
        end
        
    end
        
end