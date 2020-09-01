%% BRAIN to MFMC Conversion Script
close all; clear all; clc;

%Name of MFMC file to create
fname = 'All_in_one_conversion.mfmc';

if exist(fname, 'file')
     delete(fname);
     disp('File deleted')
 end

%Create MFMC file and MFMC structure needed for subsequent functions (this
%MFMC variable should not be altered)
MFMC = fn_MFMC_open_file(fname);

%Load raw data to brain function (fn_ds)
%File loaded as required test file
fname_rawdata= '2FRD';
exp_data = fn_ds_convert(fname_rawdata);

%Open BRAIN file
fname_brain = exp_data;



%% PROBE
%Create probe from BRAIN's exp_data.array
[PROBE]=fn_MFMC_helper_brain_array_to_probe(exp_data.array);
%Add probe details to MFMC file
[PROBE]=fn_MFMC_helper_add_probe_if_new(MFMC,PROBE);
%% SEQUENCE / Focal laws
% Convert exp_data focal law to MFMC Sequence
[SEQUENCE]=fn_MFMC_helper_brain_exp_data_to_sequence(exp_data,PROBE);
% Add sequence if new
[SEQUENCE]=fn_MFMC_helper_add_sequence_if_new(MFMC,SEQUENCE);
%% FRAME
fn_MFMC_helper_brain_exp_data_to_frame(exp_data,MFMC,SEQUENCE);

%% Post-processing (Information on MFMC file)
h5disp(fname);
tmp = dir(fname);
fprintf('File size: %.2f MB\n', tmp.bytes / 1e6);
