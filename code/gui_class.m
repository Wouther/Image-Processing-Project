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
            %TODO: initialise table
            
            %Clean exit when closing window
            set(self.fig, 'CloseRequestFcn', @self.callback_close);
        end
        
        function update_button_startstop(self)
            global processing;
            
            if processing.status == 0 %not currently processing
                set(self.handle.button_startstop, 'Enable', 'on');
            else %currently processing already
                set(self.handle.button_startstop, 'Enable', 'off');
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