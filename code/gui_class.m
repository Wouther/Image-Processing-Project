%Handles all GUI events, callbacks, etc.
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
            %set(gca, 'Visible', 'off'); %TODO: turn axis off for image display
            self.clean();
            
            %Clean exit when closing window
            set(self.fig, 'CloseRequestFcn', @self.callback_close);
        end
        
        %Cleans gui as preparation for new video file. Erases image,
        % deletes results in table, etc.
        function clean(self)
            self.handle.table_results.Data = {}; %empty table
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
        
        function update_button_start(self)
            global processing;
            
            if processing.status == 0 %not currently processing
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