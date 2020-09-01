%SUMMARY
%   Example of reading from an MFMC structure in an HDF5 file. File is
%   created first by executing 'example_create_file.m'.

%First create the file then clear everything and restore path to default
%run('example_create_file');
fname = 'mfmc_converted.mfmc';
clearvars -except fname;
close all;
clc;
%crestoredefaultpath;


%--------------------------------------------------------------------------
%Open the file and obtain Matlab MFMC structure variable for use in later
%functions
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

%Get second frame of data in the 1st sequence
frame_index = 1;
FRAME = fn_MFMC_read_frame(MFMC, sequence_list{sequence_index}.ref, frame_index);



% Choose which A-scan to display (tx * rx)

tx = 32;
i = 0;
for ascan_index = ((tx-1)*64+1):1:(tx*64)  % e.g. at tx = 32 31*64 will be the last a-scan with tx=31 so we add 1
    i = i+1; % counter for each ascan
    hold on;
    transmit_law = fn_MFMC_read_law(MFMC, SEQUENCE.TRANSMIT_LAW(ascan_index, :));
    receive_law = fn_MFMC_read_law(MFMC, SEQUENCE.RECEIVE_LAW(ascan_index, :));
    fprintf('\nTransmit law for A-scan %i in sequence %i:\n', ascan_index, sequence_index);
    disp(transmit_law);
    fprintf('\nReceive law for A-scan %i in sequence %i:\n', ascan_index, sequence_index);
    disp(receive_law);
    % define x and y gaps:
    
    xGap = 0.0781e-6; 
    yGap = 0.02;
 
    time_pts = size(FRAME, 1);
    time_axis = SEQUENCE.START_TIME + [0: time_pts - 1] * SEQUENCE.TIME_STEP;
    time_axis = time_axis + xGap*i;
    amplitude_axis = FRAME(:, ascan_index);
    amplitude_axis = amplitude_axis + yGap*i;
    %figure;
    plot(time_axis * 1e6, amplitude_axis);
    xlabel('Time (\mus)');
    ylabel('Amplitude (V)');
end

