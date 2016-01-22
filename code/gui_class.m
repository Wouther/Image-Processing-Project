%Handles all GUI events, callbacks, etc.
%Uses processing object.
classdef gui_class < handle

    properties
        fig;
        handle;
        hProgressText; %handle of textfield in progress bar (last license plate)
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
            
            if nargin <= 1 %no argument passed
                [accepted, fpath, is_video] = select_file();
            else
                [accepted, fpath, is_video] = select_file(varargin{1});
            end
            
            if ~accepted
                return;
            end
            
            %Check whether it's a video (not an image)
            if ~is_video
                fprintf('Error: File is an image, not video, so not supported by VideoReader.\n');
                return;
            end
            
            %File accepted, so delete old processing and gui data...
            if exist('processing', 'var')
                delete(processing);
            end
            self.clean();
            
            % ...then load new file and update gui
            [~, fname, fext] = fileparts(fpath); %fext includes leading period
            self.update_textfield('text_file', [fname fext]);
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
        
        %Stop processing after this frame
        function stop(self)
            global processing;
            
            processing.interrupt();
        end
        
        %Shows the last frame in the GUI's video axes.
        function show_video_frame(self)
            global processing settings;
            
            if settings.show_processed_video
                f = processing.frame.image_processed;
            else
                f = processing.frame.image;
            end
            
            image(f, 'Parent', self.handle.axes_video);
            self.handle.axes_video.Visible = 'off';
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
            self.update_progressbar(0, '');
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
        % otherwise. Vice versa for stop button. First argument is processing status.
        function update_button_start(self, status)
            if status == 0 %not currently processing
                set(self.handle.button_start, 'Enable', 'on');
                set(self.handle.button_stop,  'Enable', 'off');
            else %currently processing already
                set(self.handle.button_start, 'Enable', 'off');
                set(self.handle.button_stop,  'Enable', 'on');
            end
        end
        
        %Update the progress bar.
        function update_progressbar(self, fraction, txt)
            ax = self.handle.axes_progress;
            barh(ax, 0, fraction, 1, 'g');
            
            %TODO: why does this have to be set every time?
            set(ax, 'XLim', [0 1]);
            set(ax, 'XTick', []);
            set(ax, 'YTick', []);
            set(ax, 'XTickLabel', []);
            set(ax, 'YTickLabel', []);

            %Also show the last result seperately
            self.hProgressText = text(0.5, 0, txt, 'Parent', self.handle.axes_progress, ...
                'HorizontalAlignment', 'center');
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