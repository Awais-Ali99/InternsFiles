function fn_MFMC_plotAscans(handles,MFMC,probe_list,sequence_list)
% This function contains the bulk of the calculations and operations
% necessary for the plotting of the A-scans. Most values are directly
% inherited from the Data Reviewer UI controls, but some default values
% (like the default X and Y gaps) can be adjusted here.
% The function uses 3 different for loops to plot the 3 different modes -
% fixed tx, fixed rx and same tx/rx. The way each mode plots the A-scans is
% explained in the comments above the for loops.



% Set what X and Y gaps you want as default:
xGap_def = 0.0781e-6;
yGap_def = 0.02;

% Clear axes
cla;
%% Allocate variables from handles
% Two if statements to check revert to default if the button fields are
% empty
if isempty(get(handles.button(1), 'String'))
    xGap = xGap_def;
else
    % Otherwise save current inputs as X and Y gaps respectively.
    xGap = str2double(get(handles.button(1), 'String'));
end
if isempty(get(handles.button(2), 'String'))
    yGap = yGap_def;
else
    yGap = str2double(get(handles.button(2), 'String'));
end
% Update the edit fields on figure window:
set(handles.button(1),'String',xGap);
set(handles.button(2),'String',yGap);
 
% Get value of chosen mode (1 = Fixed Tx, 2 = Fixed Rx, 3 = Same Tx/Rx)
modePlot = get(handles.button(5),'Value');

probe_index = get(handles.button(6),'Value');
PROBE = fn_MFMC_read_probe(MFMC, probe_list{probe_index}.ref);

sequence_index = get(handles.button(7),'Value');
SEQUENCE = fn_MFMC_read_sequence(MFMC, sequence_list{sequence_index}.ref);

% Try/catch while loop to determine the number of frames in this sequence
% The loop stops when the frame_index it tries to read doesn't exist
err = 0;
counter = 0;
while err == 0
    try 
        counter = counter+1;
        FRAME = fn_MFMC_read_frame(MFMC, sequence_list{sequence_index}.ref, counter);
    catch
        'MATLAB:The index arguments exceed the size of the dataset.';
        frame_number = counter-1;
        disp(frame_number)
        err = 1;
    end
end
% Populate the Frame dropdown control with the number of frames
set(handles.button(8),'String',{num2str((1:1:frame_number)')});

frame_index = str2double(get(handles.button(8),'String'));
FRAME = fn_MFMC_read_frame(MFMC, sequence_list{sequence_index}.ref, frame_index);

num_el = length(PROBE.ELEMENT_SHAPE);
el = get(handles.button(4),'Value');
 
% Update the choose element dropdown menu:
set(handles.button(4),'String',{num2str((1:1:num_el)')});
drawnow;
%% Main Plotting script
% set A-scan counter i to 0, this tracks which relative A-scan you are on 
% (e.g. 1st,2nd,etc. all the way to 64th, regardless of what actual A-scan
%  it is, e.g. 4095th,4096th,etc.)
i = 0;    
if modePlot == 1
    % for loop from first to last A-scan for particular fixed transmitter
    for ascan_index = ((el-1)*num_el+1):1:(el*num_el)  
        i = i+1; % counter for each ascan
        hold on;

        time_pts = size(FRAME, 1);
        time_axis = SEQUENCE.START_TIME + [0: time_pts - 1] * SEQUENCE.TIME_STEP;
        time_axis = time_axis + xGap*i; % in each loop shift the time axis by an extra xGap
        amplitude_axis = FRAME(:, ascan_index);
        amplitude_axis = amplitude_axis + yGap*i; % in each loop shift the amplitude by an extra yGap
        plot(time_axis * 1e6, amplitude_axis);
        xlabel('Time (\mus)');
        ylabel('Amplitude (V)');
        % Annotate plot:
        lbl = 'All A-scans for fixed Tx';
        str = strcat(lbl,{' '},num2str(el));
        title(str);

    end
fprintf('Showing fixed tx \n');

elseif modePlot == 2
    % for loop from first to last A-scan for particular fixed receiver
    for ascan_index = el:num_el:length(SEQUENCE.TRANSMIT_LAW)  
        i = i+1; % counter for each ascan
        hold on;

        time_pts = size(FRAME, 1);
        time_axis = SEQUENCE.START_TIME + [0: time_pts - 1] * SEQUENCE.TIME_STEP;
        time_axis = time_axis + xGap*i; % in each loop shift the time axis by an extra xGap
        amplitude_axis = FRAME(:, ascan_index);
        amplitude_axis = amplitude_axis + yGap*i; % in each loop shift the amplitude by an extra yGap
        plot(time_axis * 1e6, amplitude_axis);
        xlabel('Time (\mus)');
        ylabel('Amplitude (V)');
        lbl = 'All A-scans for fixed Rx';
        str = strcat(lbl,{' '},num2str(el));
        title(str);

    end
fprintf('Showing fixed rx \n');

elseif modePlot == 3
    el = num_el;
    for element = 1:el
        ascan_index = element.^2;  
        i = i+1; % counter for each ascan
        hold on;

        time_pts = size(FRAME, 1);
        time_axis = SEQUENCE.START_TIME + [0: time_pts - 1] * SEQUENCE.TIME_STEP;
        time_axis = time_axis + xGap*i; % in each loop shift the time axis by an extra xGap
        amplitude_axis = FRAME(:, ascan_index);
        amplitude_axis = amplitude_axis + yGap*i; % in each loop shift the amplitude by an extra yGap
        plot(time_axis * 1e6, amplitude_axis);
        xlabel('Time (\mus)');
        ylabel('Amplitude (V)');
        lbl = 'All A-scans for same Tx and Rx';
        title(lbl);
    end
    fprintf('Fixed both \n');
    % Update the element box to '-' (as it's not needed for this mode)
    set(handles.button(4),'String','-');
end
drawnow;
end
