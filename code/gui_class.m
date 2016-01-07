%Handles all GUI events, callbacks, etc.
%Uses processing object.
classdef gui_class < handle

    properties
        fig;
        handle;
    end
    
    methods

        %Constructor
        function self = gui_class()
            %Start gui
            self.fig    = gui_figure; %use 'gui_figure' .fig and .m as created with GUIDE
            self.handle = guihandles(self.fig);

            %Initialise
            set(self.handle.figure1, 'Name', 'License plate recognition GUI');
            
            self.handle.axes_video.XTick = [];
            self.handle.axes_video.YTick = [];
            self.handle.axes_video.XColor = [1 1 1];
            self.handle.axes_video.YColor = [1 1 1];
            
            self.clean();
            
            %Clean exit when closing window
            set(self.fig, 'CloseRequestFcn', @self.callback_close);
        end
        
        %Load a file. Optionally accepts a (path to a) file as an argument,
        % otherwise displays system selection dialogue.
        function load_file(self, varargin)
            global processing;
            
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
            
            %File accepted, so delete old processing and gui data...
            if exist('processing', 'var')
                delete(processing);
            end
            self.clean();
            
            % ...then load new file and update gui
            self.update_textfield('text_file', [fname '.' fext]);
            processing = processing_class(fpath);
        end
        
        %Start processing
        function start(self)
            global processing;
            
            %(Re)load file
            if exist('processing', 'var')
                if processing.frame.nr ~= 0 %already ran
                    %Reload the current file (this also cleans up)
                    fpath = processing.file.path;
                    self.load_file(fpath);
                end
            else
                self.load_file();
            end
            
            %Start processing
            processing.start();
        end
        
        %Shows the last frame in the GUI's video axes.
        function show_video_frame(self)
            global processing;
            
            axes(self.handle.axes_video);
            image(processing.frame.image);
            %set(gcf, 'position', [150 150 self.vid.Width self.vid.Height]);
            %set(gca, 'units', 'pixels');
            %set(gca, 'position', [0 0 self.vid.Width self.vid.Height]);

            %showFrameOnAxis(gui.handle.axes_video, frame);
            %TODO
        end
        
        %Cleans gui as preparation for new video file. Erases image,
        % deletes results in table, etc.
        function clean(self)
            self.handle.table_results.Data = {}; %empty table
            set(self.handle.button_start, 'Enable', 'off'); %disable start button
            %TODO: clean the rest
        end
        
        function update_table_results(self)
            global processing;
            
            self.handle.table_results.Data = processing.results;
        end
        
        %Update a specific text field.
        function update_textfield(self, fieldname, text)
            h = eval(['self.handle.' fieldname]);
            set(h, 'String', text);
        end
        
        %Disables the start button if currently processing, enables
        % otherwise. First argument is processing status.
        function update_button_start(self, status)
            if status == 0 %not currently processing
                set(self.handle.button_start, 'Enable', 'on');
            else %currently processing already
                set(self.handle.button_start, 'Enable', 'off');
            end
        end
        
        function exit(self)
            %Close window
            delete(self.fig);
        end
        
        function callback_close(self, ~, event)
            %Exit on window close
            self.exit();
        end
    end
    
end