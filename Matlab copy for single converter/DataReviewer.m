%% DATA REVIEWER SCRIPT
%
% This is the main script for the data reviewing tool. You can choose
% whether to see the a-scan plotter, the 3D image display or to compare two
% different MFMC files
%
% For the A-scan plotter this script sets up the various buttons and input
% textboxes for the A-scan UI - in the handle.button(i) structure. You
% don't need to set any variables in this script, however some default
% values might be changed from within the fn_MFMC_plotAscans.m function.
%
% For the 3D image you need to choose which probe to display by changing
% the probe_index in the 3D image section (at the bottom of the script)
%
%
%
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
% Open the file and obtain Matlab MFMC structure variable for use in later
% functions
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

%% Plotting and data review segment:
%
% Set some dummy value for initial num_el (for the button(4) setup)
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
    % Create control changing the element for display
    handles.button(4) = uicontrol(fig,'Style','popupmenu');
    handles.button(4).String = {num2str(1)};
    % Create control for choosing display mode
    handles.button(5) = uicontrol(fig,'Style','popupmenu',...
        'String',{'Fixed Tx','Fixed Rx','Same Tx and Rx'});
    % Create controls for Probe, Sequence and Frame selection
    handles.button(6) = uicontrol(fig,'Style','popupmenu');
    handles.button(6).String = {num2str((1:1:length(probe_list))')};
    
    
    handles.button(7) = uicontrol(fig,'Style','popupmenu');
    handles.button(7).String = {num2str((1:1:length(sequence_list))')};
    
    handles.button(8) = uicontrol(fig,'Style','popupmenu');
    handles.button(8).String = {num2str(1)};
    
    % Button to confirm changes and replot (needs to be after other controls)
    handles.button(3) = uicontrol(fig,'Style','pushbutton','String','Replot',...
        'Callback',@(src,event)fn_MFMC_plotAscans(handles,MFMC,...
        probe_list,sequence_list));


    % Button positions:
    handles.button(1).Position = [30 647 100 20];
    handles.button(2).Position = [30 597 100 20];
    handles.button(3).Position = [30 297 100 20];
    handles.button(4).Position = [30 497 100 20];
    handles.button(5).Position = [30 547 100 20];
    handles.button(6).Position = [30 447 100 20];
    handles.button(7).Position = [30 397 100 20];
    handles.button(8).Position = [30 347 100 20];

    % Annotations for the buttons:
    annotation('textbox',[0.0017,0.9569,0.2016,0.0358],'String',...
        'Controls: ',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.9017,0.0399,0.0346],'String','X gap:',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.8321,0.0399,0.0346],'String','Y gap:',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.7625,0.0399,0.0346],'String','Choose mode:',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.6929,0.08044,0.03579],'String','Choose element:',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.6233,0.08044,0.03579],'String','Probe: ',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.5537,0.08044,0.03579],'String','Sequence: ',...
        'FitBoxToText','on','EdgeColor','none');
    annotation('textbox',[0.0162,0.4841,0.08044,0.03579],'String','Frame: ',...
        'FitBoxToText','on','EdgeColor','none');
    
    

    % run plotting function once to get the initial(default) plot
    fn_MFMC_plotAscans(handles,MFMC,probe_list,sequence_list)
end

%% Display 3D Image of Probe:
%
%
%
if strcmp(choose,'3D Image') % If 3D image is chosen
    % Choose which probe to read:
    probe_index = 1;
    PROBE = fn_MFMC_read_probe(MFMC, probe_list{probe_index}.ref);
    num_el = length(PROBE.ELEMENT_SHAPE);
    fn_3D_image_plot_new(PROBE,num_el);
end

