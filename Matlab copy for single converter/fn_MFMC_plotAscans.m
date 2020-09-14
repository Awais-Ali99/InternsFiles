function fn_MFMC_plotAscans(xGap,yGap,modePlot,num_el,el,MFMC,SEQUENCE,sequence_index,FRAME)


i = 0;    % set A-scan counter to 0, this tracks which relative A-scan you are on (e.g. 1st,2nd,etc. all the way to 64th)
if strcmp(modePlot,'Rx for fixed Tx') == 1 
for ascan_index = ((el-1)*num_el+1):1:(el*num_el)  % for loop from first to last A-scan for particular fixed transmitter
    i = i+1; % counter for each ascan
    hold on;
    
    time_pts = size(FRAME, 1);
    time_axis = SEQUENCE.START_TIME + [0: time_pts - 1] * SEQUENCE.TIME_STEP;
    time_axis = time_axis + xGap*i; % in each loop shift the time axis by an extra xGap
    amplitude_axis = FRAME(:, ascan_index);
    amplitude_axis = amplitude_axis + yGap*i; % in each loop shift the amplitude by an extra yGap
    plot(time_axis * 1e6, amplitude_axis);
    xlabel('Time (\mus)');
    ylabel('Amplitude (V)');
    % Annotate plot:
    lbl = 'All A-scans for fixed Tx';
    str = strcat(lbl,{' '},num2str(el));
    title(str);

end
fprintf('Showing fixed tx \n');

elseif strcmp(modePlot,'Tx for fixed Rx') == 1
for ascan_index = el:num_el:length(SEQUENCE.TRANSMIT_LAW)  % for loop from first to last A-scan for particular fixed receiver
    i = i+1; % counter for each ascan
    hold on;
    
    time_pts = size(FRAME, 1);
    time_axis = SEQUENCE.START_TIME + [0: time_pts - 1] * SEQUENCE.TIME_STEP;
    time_axis = time_axis + xGap*i; % in each loop shift the time axis by an extra xGap
    amplitude_axis = FRAME(:, ascan_index);
    amplitude_axis = amplitude_axis + yGap*i; % in each loop shift the amplitude by an extra yGap
    plot(time_axis * 1e6, amplitude_axis);
    xlabel('Time (\mus)');
    ylabel('Amplitude (V)');
    lbl = 'All A-scans for fixed Rx';
    str = strcat(lbl,{' '},num2str(el));
    title(str);

end
fprintf('Showing fixed rx \n');

elseif strcmp(modePlot,'Same Tx and Rx') == 1
for element = 1:el
    ascan_index = element.^2;  
    i = i+1; % counter for each ascan
    hold on;

    time_pts = size(FRAME, 1);
    time_axis = SEQUENCE.START_TIME + [0: time_pts - 1] * SEQUENCE.TIME_STEP;
    time_axis = time_axis + xGap*i; % in each loop shift the time axis by an extra xGap
    amplitude_axis = FRAME(:, ascan_index);
    amplitude_axis = amplitude_axis + yGap*i; % in each loop shift the amplitude by an extra yGap
    plot(time_axis * 1e6, amplitude_axis);
    xlabel('Time (\mus)');
    ylabel('Amplitude (V)');
    lbl = 'All A-scans for same Tx and Rx';
    title(lbl);
end
fprintf('Fixed both \n');
end

end
