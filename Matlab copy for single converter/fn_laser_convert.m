function exp_data=fn_laser_convert(fname_laser,varargin)
% This function loads the raw laser-obtained data into MATLAB and converts
% it into an exp_data struct - in the same format as fn_ds_convert.m does.
% Some parameters (like pitch, width and centre frequency) are set up in 
% the beginning of the function currently but the function could be updated 
% to load them from the file if the file contains them.
%
% The mandatory input to this function is the name of the laser data file and
% optionally the ph_velocity can be input (otherwise it's set to 3200);
%
%
%
load(fname_laser);
% User Parameters:
%
pitch = 0.3e-3;
width = 0.2e-3; % total width of the element
% Set centre frequency as 15MHz
exp_data.array.centre_freq = 15e6;
%
%
% Additional parameters:
if nargin < 2
    ph_vel = 3200;
else
    ph_vel = varargin{1};
end
% Find number of elements and also populate exp_data struct with time
% array, FMC data and ph_vel array.
% 
num_el = sqrt(length(FMC));
exp_data.time = time;
exp_data.time_data = FMC.';
exp_data.ph_velocity=ph_vel;

i = 0;
% For loop for the transmitter:
for ii = 1:num_el
    % For loop for receiver (tx1,rx1,tx1,rx2,etc.)
    for jj = 1:num_el
        i = i+1;
        exp_data.tx(i) = ii;
        exp_data.rx(i) = jj;
    end
end

% Define centre of each element based on element number and pitch
el_xc=[1:num_el]*pitch;

% create array of equispaced elements in the x-dir:
exp_data.array.el_xc=el_xc-mean(el_xc); 
% beginning of element 1 in x-dir:
exp_data.array.el_x1=exp_data.array.el_xc-width/2; 
exp_data.array.el_x2=exp_data.array.el_xc+width/2; 
% All the elements are at 0 in the y- and z-axis:
exp_data.array.el_yc=zeros(size(el_xc));
% All elements have the same y- and z- coordinates (only x changes)
exp_data.array.el_y1=exp_data.array.el_yc;
exp_data.array.el_y2=exp_data.array.el_yc;
exp_data.array.el_zc=zeros(size(el_xc));
exp_data.array.el_z1=exp_data.array.el_zc;
exp_data.array.el_z2=exp_data.array.el_zc;


fname = strcat(fname_laser,'_exp_data.mat');
% delete saved data if it already exists:
if exist(fname, 'file')
     delete(fname);
     fprintf('Old exp_data deleted \n');
end
save(fname,'exp_data');
end