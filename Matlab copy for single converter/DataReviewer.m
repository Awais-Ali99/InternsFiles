%% DATA REVIEWER SCRIPT
clear all;
close all;
clc;
%
%
%% Set up initial menu to choose what do look at
choose = questdlg('Do you want to look at the A-scans, the 3D probe image or Compare your MFMC files?',...
'Menu',... 
'A-scans', '3D Image', 'MFMC file Comparison', 'dnf');
%% MFMC File Comparison Section
%
%
%
%%Open the file and obtain Matlab MFMC structure variable for use in later
%functions
if strcmp(choose,'MFMC file Comparison') % If MFMC File Comparison are chosen:
    %Select both files you want to compare    
    fname1 = uigetfile('*.mfmc');
    fname2 = uigetfile('*.mfmc'); %'COMPARE_LABVIEW.mfmc';

    fn_ComparisonMFMCtoMFMC (fname1,fname2)
end

%% Load file for A-scans/3D image:
% For A-scans and 3D image load the MFMC file you want
if (strcmp(choose,'A-scans') || strcmp(choose,'3D Image'))
    fname = uigetfile('*.mfmc');
end
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

%% Plotting and data review segment:
%
if strcmp(choose,'A-scans')  
    % Set up fig
    fig = figure('Name','A-scan Plots');
    % Following 3 lines maximise the figure in fullscreen
    % (otherwise the annotations and buttons get misplaced)
    pause(0.00001);
    frame_h = get(handle(gcf),'JavaFrame');
    set(frame_h,'Maximized',1);

    % Create controls for entering X and Y gaps
    handles.button(1) = uicontrol(fig,'Style','edit');
    handles.button(2) = uicontrol(fig,'Style','edit');
    % Create controls for choosing mode and changing the element for display
    handles.button(4) = uicontrol(fig,'Style','edit',...
        'Max',length(PROBE.ELEMENT_SHAPE),'Min',1);
    handles.button(5) = uicontrol(fig,'Style','popupmenu',...
        'String',{'Fixed Tx','Fixed Rx','Same Tx and Rx'});
    % Button to confirm changes and replot (needs to be after other controls)
    handles.button(3) = uicontrol(fig,'Style','pushbutton','String','Replot',...
        'Callback',@(src,event)fn_MFMC_plotAscans(handles,...
        MFMC,PROBE,SEQUENCE,sequence_index,FRAME));


    % Button positions:
    handles.button(1).Position = [30 670 100 20];
    handles.button(2).Position = [30 615 100 20];
    handles.button(3).Position = [30 440 100 20];
    handles.button(4).Position = [30 500 100 20];
    handles.button(5).Position = [30 560 100 20];

    % Annotations for the buttons:
    annotation('textbox',[0.0017,0.9569,0.2016,0.0358],'String',...
        'Enter X and Y gaps (leave empty for default)',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.914,0.0399,0.0346],'String','X gap:',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.8446,0.0399,0.0346],'String','Y gap:',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.7719,0.0399,0.0346],'String','Choose mode:',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.6929,0.08044,0.03579],'String','Choose element:',...
        'FitBoxToText','on','EdgeColor','none');

    % run plotting function once to get the initial(default) plot
    fn_MFMC_plotAscans(handles,MFMC,PROBE,SEQUENCE,sequence_index,FRAME)
end

%% Display 3D Image of Probe:
%
%
%
if strcmp(choose,'3D Image') % If 3D image is chosen
    fn_3D_image_plot_new(PROBE,num_el);
end
%
%