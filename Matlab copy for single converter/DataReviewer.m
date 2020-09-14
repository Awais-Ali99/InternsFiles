%% DATA REVIEWER SCRIPT
clear all;
close all;
clc;


%% Set up initial menu to choose what do look at
choose = questdlg('Do you want to look at the A-scans or the 3D probe image or Compare your MFMC files?',...
'Menu',... 
'A-scans', '3D Image', 'MFMC file Comparison', 'dnf');
%% Load file:
% For A-scans and 3D image load the MFMC file you want (for MFMC comparison
% skip to end)
if (strcmp(choose,'A-scans') || strcmp(choose,'3D Image'))
    % Choose which file to open:
    fname = uigetfile('*.mfmc');

    % Open the MFMC file:
    MFMC = fn_MFMC_open_file(fname);

    %Get lists of probes and sequences in file
    [probe_list, sequence_list] = fn_MFMC_get_probe_and_sequence_refs(MFMC);
    fprintf('File contains %i probes and %i sequences\n', length(probe_list), length(sequence_list));
    fprintf('  Probes:\n');
    for ii = 1:length(probe_list)
        fprintf(['    ', probe_list{ii}.name, '\n']);
    end
    fprintf('  Sequences:\n');
    for ii = 1:length(sequence_list)
        fprintf(['    ', sequence_list{ii}.name, '\n']);
    end

    % Choose which probe to read:
    probe_index = 1;
    PROBE = fn_MFMC_read_probe(MFMC, probe_list{probe_index}.ref);
    fprintf('\nProbe %i details:\n', probe_index);
    disp(PROBE);

    % Choose which sequence to read:
    sequence_index = 1;
    SEQUENCE = fn_MFMC_read_sequence(MFMC, sequence_list{sequence_index}.ref);
    fprintf('\nSequence %i details:\n', sequence_index);
    disp(SEQUENCE);

    % Choose which frame to read
    frame_index = 1;
    FRAME = fn_MFMC_read_frame(MFMC, sequence_list{sequence_index}.ref, frame_index);
    % Get number of elements
    num_el = length(PROBE.ELEMENT_SHAPE);
end

%% Plotting and data review segment:
%
% 
%
%
%

if strcmp(choose,'A-scans') % If A-scans are chosen:
    modePlot = questdlg('What type of data representation do you want?',...
    'Choose type: ', ...
    'Rx for fixed Tx','Tx for fixed Rx','Same Tx and Rx','Rx for fixed Tx');
    error = 1;
    if strcmp(modePlot,'Rx for fixed Tx') == 1
        while error == 1 % run loop while input is wrong
            inp = inputdlg('Choose fixed Tx: ','Tx',[1 35]);
            tx = str2num(inp{1});
            if tx ~= floor(tx)  % check if input is an integer
                fprintf('Please enter an integer \n');
                error = 1;
                continue;

            end
            if tx > length(PROBE.ELEMENT_SHAPE) || tx < 1
                fprintf('Enter a number between 1 and %.0f \n',length(PROBE.ELEMENT_SHAPE));
                error = 1;
                continue;
            end
            error = 0;
        end
        el = tx;
    elseif strcmp(modePlot,'Tx for fixed Rx') == 1
        while error == 1 % run loop while input is wrong
            inp = inputdlg('Choose fixed Rx: ','Rx',[1 35]);
            rx = str2num(inp{1});
            if rx ~= floor(rx)
                fprintf('Please enter an integer \n');
                error = 1;
                continue;

            end
            if rx > length(PROBE.ELEMENT_SHAPE) || rx < 1
                fprintf('Enter a number between 1 and %.0f \n',length(PROBE.ELEMENT_SHAPE));
                error = 1;
                continue;
            end
            error = 0;
        end
        el = rx;

    elseif strcmp(modePlot,'Same Tx and Rx') == 1
        el = length(PROBE.ELEMENT_SHAPE);
    end
    
    
% Set up initial X and Y gaps for cascade plot

xGap = 0.0781e-6;
yGap = 0.02;
% Infinite loop that restarts itself whenever the button to change gaps is
% pressed
while true  
    clf;
    % call plotting function
    fn_MFMC_plotAscans(xGap,yGap,modePlot,num_el,el,MFMC,SEQUENCE,sequence_index,FRAME);
    fig = figure(1);
    % Set up two controls for X and Y gap inputs, and one to confirm
    %
    %
    button1 = uicontrol(fig,'Style','edit');
    button1.String = num2str(xGap);
    annotation('textbox',[0.0199,0.9247,0.0396,0.0358],'String','X gap:','FitBoxToText','on','EdgeColor','none');
    button2 = uicontrol(fig,'Style','edit');
    annotation('textbox',[0.0199,0.855265,0.03958,0.03579],'String','Y gap:','FitBoxToText','on','EdgeColor','none');
    button2.String = num2str(yGap);
    button3 = uicontrol(fig, 'Style', 'togglebutton', 'String', 'Change');
    button1.Position = [30 670 100 20];
    button2.Position = [30 615 100 20];
    button3.Position = [30 560 100 20];
    
    drawnow;
    %
    %
    % Check to see if button is pressed:
    while true
        drawnow;
        % If button is pressed restart the outside loop (to input new gaps)
        if (get(button3, 'Value')==1)
            break;
        end
    end

    % Two if statements to check revert to default if no input is given
    % for the X and Y Gaps
    if (isempty(get(button1, 'String')) == 1)
        xGap = 0.0781e-6;
    else
        % Otherwise save current inputs as X and Y gaps respectively.
        xGap = str2num((get(button1, 'String')));
    end
    if (isempty(get(button2, 'String')) == 1)
        yGap = 0.02;
    else
        yGap = str2num((get(button2, 'String')));
    end
drawnow;

end
pause(0.01);

end


%% Display 3D Image of Probe:
%
%
%
%
if strcmp(choose,'3D Image') % If 3D image is chosen
    fn_3D_image_plot_new(PROBE,num_el);
end

%% MFMC File Comparison Section
%
%
%
%%Open the file and obtain Matlab MFMC structure variable for use in later
%functions
if strcmp(choose,'MFMC file Comparison') % If MFMC File Comparison are chosen:
    clc
    clear

    %Selected both files you want to compare    
    fname1 = uigetfile('*.mfmc');
    fname2 = uigetfile('*.mfmc'); %'COMPARE_LABVIEW.mfmc';

    fn_ComparisonMFMCtoMFMC (fname1,fname2)
end
