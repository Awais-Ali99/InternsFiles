err = 0;
counter = 0;
while err == 0
    try 
        counter = counter+1;
        FRAME = fn_MFMC_read_frame(MFMC, sequence_list{sequence_index}.ref, counter);
    catch
        'MATLAB:The index arguments exceed the size of the dataset.';
        frame_number = counter-1;
        disp(frame_number)
        err = 1;
    end
end