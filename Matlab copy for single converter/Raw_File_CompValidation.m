clc
clear

%Condition for if raw data files exist

file_exist = input ("Are .cfg and .png RAW FILES present? [Y = 1 or N = 0]");
if file_exist > 1 || file_exist < 0;
    fprintf ("Invalid Entry")
end


if file_exist == 0;
    fprintf ("Code cannot execute without invalid entry")
end


if file_exist == 1 ; 
fname_file = '2FRD';
values_raw = fn_ds_convert(fname_file);    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Open the file and obtain Matlab MFMC structure variable for use in later
%functions
fname = 'All_in_one_conversion.mfmc';
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

%Get first frame of data in the 1st sequence
frame_index = 1;
FRAME = fn_MFMC_read_frame(MFMC, sequence_list{sequence_index}.ref, frame_index);

%Read focal laws of 4096 A-scan in frame in first sequence
ascan_index = 4096;
transmit_law = fn_MFMC_read_law(MFMC, SEQUENCE.TRANSMIT_LAW(ascan_index, :));
receive_law = fn_MFMC_read_law(MFMC, SEQUENCE.RECEIVE_LAW(ascan_index, :));
fprintf('\nTransmit law for A-scan %i in sequence %i:\n', ascan_index, sequence_index);
disp(transmit_law);
fprintf('\nReceive law for A-scan %i in sequence %i:\n', ascan_index, sequence_index);
disp(receive_law);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for m = 1:1020;
 for n = 1:4096;
if FRAME(m,n) ~= values_raw.time_data (m,n)
fprintf('fail FRAME array values validation failed in' m 'row and' n 'column')
end
 end
end


end


%
    