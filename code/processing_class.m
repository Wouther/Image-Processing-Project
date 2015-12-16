%Holds data concerning processing status, etc.
%Uses gui object.
classdef processing_class < handle

    properties
        status; %0 if not processing
    end
    
    methods
        
        %Constructor
        function self = processing_class()
            %Initialise
            self.status = 0;
        end
        
        function start(self)
            global gui;
            
            disp('Starting processing...');
            self.set_status(1);
            
            %TODO: processing stuff
            pause(1);
            
            disp('Done processing.');
            self.set_status(0);
        end
        
        function set_status(self, value)
            global gui;
            
            %Update value
            self.status = value;

            %Update gui
            gui.update_button_startstop();
        end
        
    end
        
end