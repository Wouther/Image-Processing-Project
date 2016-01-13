%Processes data and stores results, etc.
%Uses gui object.
%Uses process_frame.m
classdef processing_class < handle

    properties
        status; %0 if not processing
        file; %File being processed. Structure with field 'path'.
        results; %Cell array with rows {'license plate', frame nr, timestamp}
        vid; %VideoReader object of loaded file
        frame; %Last video frame processed. Structure with fields 'image',
        % 'nr' and 'timestamp'
    end
    
    methods
        
        %Constructor
        function self = processing_class(fpath)
            %Initialise
            self.results = {};
            self.set_status(0);
            self.load_file(fpath);
            self.frame.nr = 0; %used to indicate not processed yet
        end
        
        function start(self)
            global gui;
            
            self.set_status(1);
            
            %Process frame-by-frame
            clearvars self.frame;
            self.frame.nr = 0;
            while hasFrame(self.vid)
                %Read next frame
                self.frame.image     = readFrame(self.vid);
                self.frame.nr        = self.frame.nr + 1;
                self.frame.timestamp = self.vid.currentTime;
                
                %Process frame
                [license_plate, self.frame.image_processed] = process_frame(self.frame.image);
                if ~isempty(license_plate)
                    self.add_result(license_plate, self.frame.nr, self.frame.timestamp);
                end
                
                %Display frame
                gui.show_video_frame();
            end
            
            %TODO perhaps: processing stuff not specific to single frame
            % (such as: error checking on consecutive license plates?)
            
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
            global gui;
            
            self.file.path = fpath;
            
            %Load file in matlab
            self.vid = VideoReader(self.file.path);
            
            %Show first frame as preview
            %axes(gui.handle.axes_video);
            %image(getdata(self.vid, 1), 'Parent', gui.handle.axes_video);
            %TODO, use gui.show_video_frame()
        end
        
        function set_status(self, value)
            global gui;
            
            %Update value
            self.status = value;
            
            %Update gui
            gui.update_button_start(self.status);
        end
        
        %Destructor
        function delete(self)
            %Close video file
            %release(self.vid); %TODO
        end
        
    end
        
end