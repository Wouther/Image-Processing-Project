%Processes data and stores results, etc.
%Uses gui object.
%Uses process_frame.m
classdef processing_class < handle

    properties
        status; %0 if not processing
        do_interrupt; %stops proccesing after next frame if set to true
        file; %File being processed. Structure with field 'path'.
        results; %Cell array with rows {'license plate', frame nr, timestamp}
        results_raw; %like 'results', but without post-processing
        vid; %VideoReader object of loaded file
        frame; %Last video frame processed. Structure with fields 'image',
        % 'nr' and 'timestamp'
    end
    
    methods
        
        %Constructor
        function self = processing_class(fpath)
            %Initialise
            self.results = {};
            self.do_interrupt = false;
            self.results_raw = {};
            self.set_status(0);
            self.load_file(fpath);
            self.frame.nr = 0; %used to indicate not processed yet
        end
        
        function start(self)
            global gui settings;
            
            self.do_interrupt = false;
            self.set_status(1);
            
            %Process frame-by-frame
            clearvars self.frame;
            self.frame.nr = 0;
            while ~self.do_interrupt && hasFrame(self.vid)
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
                %Note: if this line is removed, replace it with 'drawnow' to
                % not break the interrupt functionality. It flushes Matlab's
                % callback queue to process any possible interrupts.
            end
            
            if self.do_interrupt
                disp(['Note: processing was interrupted, so the results might' ...
                    ' be only partial.']);
            end
            
            %Post-process data
            self.results_raw = self.results;
            self.results     = self.post_process(self.results);
            gui.update_table_results();
            
            self.set_status(0);
            
            %Compare results with solution
            checkSolution(self.results, settings.solution_file)
        end
        
        %Post-processing of data (e.g. error checking)
        function proc = post_process(self, unproc)
            unproc(find(char(unproc(:,1)) == 'e'),:) = []; %remove errors
            
            %Determine (frame number of) license plate transitions
            delta_char = sum((char(unproc(1:size(unproc,1)-1,1)) ~= ...
                              char(unproc(2:size(unproc,1),  1))), 2);
                %n/o characters different per frame
                %matching frame numbers: cell2mat(unproc(2:end,2))
            delta_plate = find(delta_char > 3) + 1; %indices of significantly different license plates
            %TODO: perhaps combine with information about location of license plate?
            
            %Show graph (temporary, for debugging)
            if false
                figure();
                hold on;
                bar(cell2mat(unproc(delta_plate, 2)), (max(delta_char)+1)*ones(size(delta_plate)), 'g');
                bar(cell2mat(unproc(2:end,2)), sum(delta_char,2), 'r');
                title('First frames of video');
                xlabel('frame number');
                ylabel('number of characters different from next frame');
                hold off;
            end
            
            %For each license plate, determine most likely result
            proc = {};
            delta_plate = [1; delta_plate; size(unproc,1)+1];
            for i = 1:(length(delta_plate) - 1) %loop through plates
                %Select only results of single license plate
                range = delta_plate(i):(delta_plate(i+1) - 1);
                if length(range) < 2 %ignore if too few results
                    continue;
                end
                pl = char(unproc(range,1)); %all plates in range
                proc(end+1,:) = {'', cell2mat(unproc(range(1),2)), ...
                    cell2mat(unproc(range(1),3))}; %store frame/timestamp
                
                %Calculate most probable result
                proc_plate = [];
                for j = 1:size(pl,2) %loop through character positions
                    [chars,~,chars_occ] = unique(pl(:,j));
                    P = zeros(size(chars));
                    for k = 1:length(chars) %loop through possible characters for position
                        P(k) = numel(find(chars_occ == k)); %chance (occurences) of characters on this position
                    end
                    [~,kmax] = max(P);
                    
                    if chars(kmax) ~= ' ' %ignore spaces (occur when incorrect too long plate)
                        proc_plate(end+1) = chars(kmax); %store most probably character
                    end
                end
                proc(end,1) = {char(proc_plate)};
            end
        end
        
        %Interrupts processing: stops after this frame
        function interrupt(self)
            self.do_interrupt = true;
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