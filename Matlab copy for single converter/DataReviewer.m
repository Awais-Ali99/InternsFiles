%% Script to read and review MFMC data:
clear all;
close all;
clc;

% Choose which MFMC file to open (either set it at fname or use input) :
fname = 'All_in_one_conversion.mfmc';
%fname = input('Enter the name of your .mfmc file: ','s');
%if fname(end-4:end) ~= '.mfmc'  % if input name doesn't end in .mfmc, add it
    %fname = strcat(fname,'.mfmc');
%end


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
fprintf('  Seqeunces:\n');
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

%% Plotting and data review segment:
%
% 
%
modePlot = menu('What type of data representation do you want?','Rx for fixed Tx','Tx for fixed Rx','Same Tx and Rx');
error = 1;
if modePlot == 1
    while error == 1 % run loop while input is wrong
        tx = input('Choose fixed tx: ');
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
    fn_MFMC_plotAscans(modePlot,tx,MFMC,SEQUENCE,sequence_index,FRAME);
elseif modePlot == 2
    while error == 1 % run loop while input is wrong
        rx = input('Choose fixed rx: ');
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
    fn_MFMC_plotAscans(modePlot,rx,MFMC,SEQUENCE,sequence_index,FRAME);
elseif modePlot == 3 
    el = length(PROBE.ELEMENT_SHAPE);
    fn_MFMC_plotAscans(modePlot,el,MFMC,SEQUENCE,sequence_index,FRAME);
    
end



