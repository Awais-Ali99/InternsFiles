function fn_ComparisonMFMCtoMFMC (fname1,fname2)
%% fn_ComparisonMFMCtoMFMC
%
% This code is designed to simply compare the complete probe and sequence
% data structures of the two files to each other.

% The UI will initially ask if a full comparison is required or if only the
% MFMC_DATA is required to be compared.

% It should be noted that this script assumed that if the FRAME_DATA [MFMC_DATA] is not
% equal to the floor of the FRAME_DATA, the data is not integer based but
% rather a floating point requiring multiplication by 32768 to convert to
% integer [Hence adjust as appropriate]
%
%A messege box with the outcome of the comparison is displayed, 
% The command window dsplays all steps of the check as well as the error
% code


%% PROBE 1 READING

MFMC = fn_MFMC_open_file(fname1);

%Get lists of probes and sequences in file
[probe_list, sequence_list] = fn_MFMC_get_probe_and_sequence_refs(MFMC);
fprintf('File contains %i probes and %i sequences\n', length(probe_list), length(sequence_list));
fprintf('  Probes:\n');

%Read data for 1st probe
probe_index = 1;
PROBE1 = fn_MFMC_read_probe(MFMC, probe_list{probe_index}.ref);
fprintf('\nProbe %i details:\n', probe_index);
disp(PROBE1);

%Read data for 1st sequence
sequence_index = 1;
SEQUENCE1 = fn_MFMC_read_sequence(MFMC, sequence_list{sequence_index}.ref);
fprintf('\nSequence %i details:\n', sequence_index);
disp(SEQUENCE1);

%Get first frame of data in the 1st sequence
frame_index = 1;
FRAME1 = fn_MFMC_read_frame(MFMC, sequence_list{sequence_index}.ref, frame_index);
%CHECK IF DATA FOR FRAME IS INTEGER
if FRAME1 == floor(FRAME1);
    FRAME1 = FRAME1;
else
FRAME1 = ceil(FRAME1 * 32768);
end

SEQUENCE1.RECEIVE_LAW = int64(SEQUENCE1.RECEIVE_LAW)
SEQUENCE1.TRANSMIT_LAW = int64(SEQUENCE1.TRANSMIT_LAW)

%----------------------------------------------------------------------------------
%% PROBE 2 READING

MFMC = fn_MFMC_open_file(fname2);

%Get lists of probes and sequences in file
[probe_list, sequence_list] = fn_MFMC_get_probe_and_sequence_refs(MFMC);
fprintf('File contains %i probes and %i sequences\n', length(probe_list), length(sequence_list));
fprintf('  Probes:\n');


%Read data for 2nd probe
probe_index = 1;
PROBE2 = fn_MFMC_read_probe(MFMC, probe_list{probe_index}.ref);
fprintf('\nProbe %i details:\n', probe_index);
disp(PROBE2);

%Read data for 2nd sequence
sequence_index = 1;
SEQUENCE2 = fn_MFMC_read_sequence(MFMC, sequence_list{sequence_index}.ref);
fprintf('\nSequence %i details:\n', sequence_index);
disp(SEQUENCE2);

%Get first frame of data in the 1st sequence
frame_index = 1;
FRAME2 = fn_MFMC_read_frame(MFMC, sequence_list{sequence_index}.ref, frame_index);

%INTEGER CHECK FOR FRAME 2
if FRAME2 == floor (FRAME2)
    FRAME2 = FRAME2;
else
FRAME2 = ceil(FRAME2 * 32768);
end

SEQUENCE2.RECEIVE_LAW = int64(SEQUENCE2.RECEIVE_LAW)
SEQUENCE2.TRANSMIT_LAW = int64(SEQUENCE2.TRANSMIT_LAW)

%-------------------------------------------------------------------------------------
%% Set up initial menu to choose what do look at
choose = questdlg('Do you want to perform a full comparison of the MFMC files or to compare the MFMC Data only?',...
'Menu', 'Full Comparison','MFMC-DATA', 'Cancel');

%% Full Comparison Section
% Buttons presented for the type of comparison desired by the user
if strcmp(choose,'Full Comparison') == 1 % If Full Comparison is chosen:
% PROBE CHECK
error_flag_p = 0;

%PROBE COMPARISON
%PROBE Datagroup comparison section
%Probe Element_position check
 if (PROBE1.ELEMENT_POSITION(:)) ~= (PROBE2.ELEMENT_POSITION(: ));
     error_flag_p = 1;
 end
 %Probe Shape check
 if (PROBE1.ELEMENT_SHAPE(:)) ~= (PROBE2.ELEMENT_SHAPE(:))
     error_flag_p = 2;
 end
 %Probe element_major check
 if (PROBE1.ELEMENT_MAJOR(:)) ~= (PROBE2.ELEMENT_MAJOR(:))
     error_flag_p = 3;
 end
 %Probe centre frequency check
 if PROBE1.CENTRE_FREQUENCY ~= PROBE2.CENTRE_FREQUENCY
 error_flag_p = 4;
 end
 %Probe element_minor check
 if (PROBE1.ELEMENT_MINOR(:)) ~= (PROBE2.ELEMENT_MINOR(:))
     error_flag_p = 5;
 end
  %Probe element_minor check
 if (PROBE1.TYPE) ~= (PROBE2.TYPE)
     error_flag_p = 6;
 end
if error_flag_p == 0;
    fprintf('PROBE Verification pass\n');
else
    fprintf('PROBE Verification fail error_flag_p number is \n ');
    fprintf(error_flag_p);
end


% Sequence Check

error_flag_s = 0;
%sequence Probe_list check
if (SEQUENCE1.PROBE_LIST(:)) ~= (SEQUENCE2.PROBE_LIST(:));
    error_flag_s = 1;
end

%Recieve and Transmit Array creation and Comparison
%The Transmit and Recieve Law arrays may be found in uint8 form
%code hence required conversion to integer form before comparison
for n = 1: 4096  % LOOP will need adjusting based on number of ASCANS in MFMC files being tested
    
%MFMC 1 FILE LAW ARRAY CREATION
RECEIVE1_LAW_SOLVED(n) = SEQUENCE1.RECEIVE_LAW(n, 8)*(256^7) + SEQUENCE1.RECEIVE_LAW(n, 7)*(256^6) + SEQUENCE1.RECEIVE_LAW(n, 6)*(256^5) +SEQUENCE1.RECEIVE_LAW(n, 5)*(256^4) + SEQUENCE1.RECEIVE_LAW(n, 4)*(256^3) +SEQUENCE1.RECEIVE_LAW(n, 3)*(256^2) +SEQUENCE1.RECEIVE_LAW(n, 2)*(256^1) +SEQUENCE1.RECEIVE_LAW(n, 1)*(256^0);
TRANSMIT1_LAW_SOLVED(n)= SEQUENCE1.TRANSMIT_LAW(n, 8)*(256^7) + SEQUENCE1.TRANSMIT_LAW(n, 7)*(256^6) + SEQUENCE1.TRANSMIT_LAW(n, 6)*(256^5) +SEQUENCE1.TRANSMIT_LAW(n, 5)*(256^4) + SEQUENCE1.TRANSMIT_LAW(n, 4)*(256^3) +SEQUENCE1.TRANSMIT_LAW(n, 3)*(256^2) +SEQUENCE1.TRANSMIT_LAW(n, 2)*(256^1) +SEQUENCE1.TRANSMIT_LAW(n, 1)*(256^0);

%MFMC 2 FILE LAW ARRAY CREATION
RECEIVE2_LAW_SOLVED(n) = SEQUENCE2.RECEIVE_LAW(n, 8)*(256^7) + SEQUENCE2.RECEIVE_LAW(n, 7)*(256^6) + SEQUENCE2.RECEIVE_LAW(n, 6)*(256^5) +SEQUENCE2.RECEIVE_LAW(n, 5)*(256^4) + SEQUENCE2.RECEIVE_LAW(n, 4)*(256^3) +SEQUENCE2.RECEIVE_LAW(n, 3)*(256^2) +SEQUENCE2.RECEIVE_LAW(n, 2)*(256^1) +SEQUENCE2.RECEIVE_LAW(n, 1)*(256^0);
TRANSMIT2_LAW_SOLVED(n)= SEQUENCE2.TRANSMIT_LAW(n, 8)*(256^7) + SEQUENCE2.TRANSMIT_LAW(n, 7)*(256^6) + SEQUENCE2.TRANSMIT_LAW(n, 6)*(256^5) +SEQUENCE2.TRANSMIT_LAW(n, 5)*(256^4) + SEQUENCE2.TRANSMIT_LAW(n, 4)*(256^3) +SEQUENCE2.TRANSMIT_LAW(n, 3)*(256^2) +SEQUENCE2.TRANSMIT_LAW(n, 2)*(256^1) +SEQUENCE2.TRANSMIT_LAW(n, 1)*(256^0);
end

if RECEIVE1_LAW_SOLVED(:) ~= RECEIVE2_LAW_SOLVED(:)
    error_flag_s = 2;
end   
if TRANSMIT1_LAW_SOLVED(:) ~= TRANSMIT2_LAW_SOLVED(:)
    error_flag_s = 3;
end

%sequence Probe_Placment check
if (SEQUENCE1.PROBE_PLACEMENT_INDEX(:)) ~= (SEQUENCE2.PROBE_PLACEMENT_INDEX(:));
    error_flag_s = 4;
end
%sequence Probe_Position check
if SEQUENCE1.PROBE_POSITION (:) ~= SEQUENCE2.PROBE_POSITION (:)
     error_flag_s = 5;
end
%sequence Probe_X_Direction check
if SEQUENCE1.PROBE_X_DIRECTION(:) ~= SEQUENCE2.PROBE_X_DIRECTION(:)
     error_flag_s = 6;
end
%sequence Probe_Y_Direction check
if SEQUENCE1.PROBE_Y_DIRECTION (:) ~= SEQUENCE2.PROBE_Y_DIRECTION (:)
    error_flag_s = 7;
end
%sequence TYPE check
if SEQUENCE1.TYPE ~= SEQUENCE2.TYPE
    error_flag_s = 8;
end
%sequence TIME_STEP check
if SEQUENCE1.TIME_STEP ~= SEQUENCE2.TIME_STEP
    error_flag_s = 9;
end
%sequence Start_time check
if SEQUENCE1.START_TIME ~= SEQUENCE2.START_TIME
    error_flag_s = 10;
end
%sequence Specimen_velocity check
if SEQUENCE1.SPECIMEN_VELOCITY ~= SEQUENCE2.SPECIMEN_VELOCITY
    error_flag_s = 11;
end

if error_flag_s == 0;
    fprintf('SEQUENCE Verification pass\n');
else
    fprintf('SEQUENCE Verification fail error_flag_s number is\n');
    fprintf(error_flag_p)
end

% Frame Check

ABSFRAME = abs(FRAME1 - FRAME2);
if ABSFRAME <= 1
fprintf('FRAME Verificaton PASS\n');
else fprintf('error in MFMC_DATA values\n')
end


if error_flag_s == 0 && error_flag_s == 0
    msgbox('Operation Completed, Complete Verfication pass, all datasets and attributes are the same');
else
    msgbox('Operation Completed, Verfication failed, check command window');
end
end
%---------------------------------------------------------------------------
% MFMC_DATA Section
if strcmp(choose,'MFMC-DATA') == 1 % If only MFMC comparison is chosen:
    % Frame Check
ABSFRAME = abs(FRAME1 - FRAME2);
if ABSFRAME <= 1
msgbox('Operation Completed,FRAME Verificaton PASS');
else msgbox('Operation Completed,error in MFMC_DATA values')
end
end
end
