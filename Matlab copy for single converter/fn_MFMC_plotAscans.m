function fn_MFMC_plotAscans(modePlot,num_el,el,MFMC,SEQUENCE,sequence_index,FRAME)

i = 0;    % set A-scan counter to 0, this tracks which relative A-scan you are on (e.g. 1st,2nd,etc. all the way to 64th)
if strcmp(modePlot,'Rx for fixed Tx') == 1 % FIXED Tx
    for ascan_index = ((el-1)*num_el+1):1:(el*num_el)  % for loop from first to last A-scan for particular fixed transmitter
        i = i+1; % counter for each ascan
        hold on;
        transmit_law = fn_MFMC_read_law(MFMC, SEQUENCE.TRANSMIT_LAW(ascan_index, :));
        receive_law = fn_MFMC_read_law(MFMC, SEQUENCE.RECEIVE_LAW(ascan_index, :));
        fprintf('\nTransmit law for A-scan %i in sequence %i:\n', ascan_index, sequence_index);
        disp(transmit_law);
        fprintf('\nReceive law for A-scan %i in sequence %i:\n', ascan_index, sequence_index);
        disp(receive_law);

        % define x and y gaps for cascade plot:
        xGap = 0.0781e-6; 
        yGap = 0.02;

        time_pts = size(FRAME, 1);
        time_axis = SEQUENCE.START_TIME + [0: time_pts - 1] * SEQUENCE.TIME_STEP;
        time_axis = time_axis + xGap*i; % in each loop shift the time axis by an extra xGap
        amplitude_axis = FRAME(:, ascan_index);
        amplitude_axis = amplitude_axis + yGap*i; % in each loop shift the amplitude by an extra yGap
        plot(time_axis * 1e6, amplitude_axis);
        xlabel('Time (\mus)');
        ylabel('Amplitude (V)');
        
    end
    fprintf('Showing fixed tx \n');
    
elseif strcmp(modePlot,'Tx for fixed Rx') == 1
    for ascan_index = el:num_el:length(SEQUENCE.TRANSMIT_LAW)  % for loop from first to last A-scan for particular fixed receiver
        i = i+1; % counter for each ascan
        hold on;
        transmit_law = fn_MFMC_read_law(MFMC, SEQUENCE.TRANSMIT_LAW(ascan_index, :));
        receive_law = fn_MFMC_read_law(MFMC, SEQUENCE.RECEIVE_LAW(ascan_index, :));
        fprintf('\nTransmit law for A-scan %i in sequence %i:\n', ascan_index, sequence_index);
        disp(transmit_law);
        fprintf('\nReceive law for A-scan %i in sequence %i:\n', ascan_index, sequence_index);
        disp(receive_law);

        % define x and y gaps for cascade plot:
        xGap = 0.0781e-6; 
        yGap = 0.02;

        time_pts = size(FRAME, 1);
        time_axis = SEQUENCE.START_TIME + [0: time_pts - 1] * SEQUENCE.TIME_STEP;
        time_axis = time_axis + xGap*i; % in each loop shift the time axis by an extra xGap
        amplitude_axis = FRAME(:, ascan_index);
        amplitude_axis = amplitude_axis + yGap*i; % in each loop shift the amplitude by an extra yGap
        plot(time_axis * 1e6, amplitude_axis);
        xlabel('Time (\mus)');
        ylabel('Amplitude (V)');
        
    end
    fprintf('Showing fixed rx \n');
    
elseif strcmp(modePlot,'Same Tx and Rx') == 1
    for element = 1:el
        ascan_index = element.^2;  
        i = i+1; % counter for each ascan
        hold on;
        transmit_law = fn_MFMC_read_law(MFMC, SEQUENCE.TRANSMIT_LAW(ascan_index, :));
        receive_law = fn_MFMC_read_law(MFMC, SEQUENCE.RECEIVE_LAW(ascan_index, :));
        fprintf('\nTransmit law for A-scan %i in sequence %i:\n', ascan_index, sequence_index);
        disp(transmit_law);
        fprintf('\nReceive law for A-scan %i in sequence %i:\n', ascan_index, sequence_index);
        disp(receive_law);

        % define x and y gaps for cascade plot:
        xGap = 0.0781e-6; 
        yGap = 0.02;

        time_pts = size(FRAME, 1);
        time_axis = SEQUENCE.START_TIME + [0: time_pts - 1] * SEQUENCE.TIME_STEP;
        time_axis = time_axis + xGap*i; % in each loop shift the time axis by an extra xGap
        amplitude_axis = FRAME(:, ascan_index);
        amplitude_axis = amplitude_axis + yGap*i; % in each loop shift the amplitude by an extra yGap
        plot(time_axis * 1e6, amplitude_axis);
        xlabel('Time (\mus)');
        ylabel('Amplitude (V)');
    end
    fprintf('Fixed both \n');
end