%% DATA REVIEWER SCRIPT
clear all;
close all;
clc;

% Choose which MFMC file to open:
fname = 'DAVEWEDGEFIX.mfmc' %uigetfile('*.mfmc');


%--------------------------------------------------------------------------
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
%% 
%Read data for 1st probe
probe_index = 1;
PROBE = fn_MFMC_read_probe(MFMC, probe_list{probe_index}.ref);
fprintf('\nProbe %i details:\n', probe_index);
disp(PROBE);

%Read data for 1st sequence
sequence_index = 1;
SEQUENCE = fn_MFMC_read_sequence(MFMC, sequence_list{sequence_index}.ref);
fprintf('\nSequence %i details:\n', sequence_index);
disp(SEQUENCE);

% Get first frame of data
frame_index = 1;
FRAME = fn_MFMC_read_frame(MFMC, sequence_list{sequence_index}.ref, frame_index);
% Get number of elements
num_el = length(PROBE.ELEMENT_SHAPE);

%% Set up initial menu to choose what do look at
choose = questdlg('Do you want to look at the A-scans or the 3D probe image or Compare your MFMC files?',...
'Menu',... 
'A-scans', '3D Image', 'MFMC file Comparison', 'dnf');
%% Plotting and data review segment:
%
% 
%
if strcmp(choose,'A-scans') == 1 % If A-scans are chosen:
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
        fn_MFMC_plotAscans(modePlot,num_el,tx,MFMC,SEQUENCE,sequence_index,FRAME);
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
        fn_MFMC_plotAscans(modePlot,num_el,rx,MFMC,SEQUENCE,sequence_index,FRAME);
    elseif strcmp(modePlot,'Same Tx and Rx') == 1
        el = length(PROBE.ELEMENT_SHAPE);
        fn_MFMC_plotAscans(modePlot,num_el,el,MFMC,SEQUENCE,sequence_index,FRAME);
    end
end
%% Display 3D Image of Probe:
%
%
%
%
if strcmp(choose,'3D Image') == 1 % If 3D image is chosen
    fn_3D_image_plot_new(PROBE,num_el);
end

%% MFMC File Comparison Section
%
%
%
%%Open the file and obtain Matlab MFMC structure variable for use in later
%functions
if strcmp(choose,'MFMC file Comparison') == 1 % If MFMC File Comparison are chosen:
clc
clear

%Selected both files you want to compare    
fname1 = 'wedge_converted.mfmc';
fname2 = 'wedge_converted.mfmc'; %'COMPARE_LABVIEW.mfmc';

fn_ComparisonMFMCtoMFMC (fname1,fname2)
end
