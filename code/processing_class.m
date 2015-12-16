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
        function self = processing_class(fpath)
            %Initialise
            self.results = {};
            self.set_status(0);
            self.load_file(fpath);
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
        
        %Load file for processing. Error checking (file existance, etc.)
        % already done in gui_class.
        function load_file(self, fpath)
            self.file.path = fpath;
            
            %TODO: load raw file in matlab, ready for processing
        end
        
        function set_status(self, value)
            global gui;
            
            %Update value
            self.status = value;
            
            %Update gui
            gui.update_button_start(self.status);
        end
        
    end
        
end