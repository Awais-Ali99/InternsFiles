function exp_data=fn_ds_convert(fname, varargin);
%load and convert diagnostic sonar datasets
%close all
%clear all

if nargin<2
    ph_vel=6300;
else                      %multiple input argument allowance rules set?
    ph_vel=varargin{1};
end

fnamepng=[fname '.png'];      %taking in .png and .cfg file
fnamecfg=[fname '.cfg'];     

%load and convert the ultrasonic data
data=imread(fnamepng);
data=double(data);
data=data-2^15;
data=data./2^15;
exp_data.time_data=double(data.');

%read in the configuration to set up the exp_data file correctly
delimiter = ' ';
startRow = 5;
endRow = inf;
formatSpec = '%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(fnamecfg,'r');
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end
fclose(fileID);

sections={'[2D','[Wedge','[FMC','[Ascan]'};
need_fields=[4 12 6 3];

tot_count=1;
for jj=1:length(sections)  % for each section:
    count=1;
    found_field=0;
    while found_field==0
        % check if the current line in dataArray matches the name of
        % required section:
        found_field=strcmp(dataArray{1}{count},sections{jj});
        if found_field==1
            % define the location of each section
            locs(jj)=count;
            % for each field in section:
            for ii=1:need_fields(jj)
                cfg_dat{tot_count,1}=dataArray{1}{locs(jj)+ii};
                k = 2;
                % In order to get the value corresponding to the data, find
                % the column with = sign then read value from the next
                % column
                while (dataArray{k}{locs(jj)+ii}) ~= '='
                    k = k+1;
                end
                  % OUTDATED METHOD:
%                 while (isnan(str2double(dataArray{k}{locs(jj)+ii})) && k<length(dataArray))
%                     k = k + 1;
%                 end
                cfg_dat{tot_count,2}=dataArray{k+1}{locs(jj)+ii};
                tot_count=tot_count+1;
            end
        end
        % if it doesn't match, go to next line:
        count=count+1;
    end
end
num_els=str2num(cfg_dat{18,2});
samp_freq=str2num( cfg_dat{23,2})*1e6;
time_step=1/samp_freq;
time_len=str2num( cfg_dat{24,2});
start_samp=str2num( cfg_dat{25,2});
exp_data.time=[start_samp:(start_samp+time_len-1)].*time_step;
exp_data.time=exp_data.time.';

pitch=str2num( cfg_dat{3,2})*1e-3;
el_width=str2num( cfg_dat{4,2})*1e-3;
exp_data.array.centre_freq=str2num( cfg_dat{1,2})*1e6;
exp_data.ph_velocity=ph_vel;

% Wedge data:
exp_data.array.wedge.wedge_angle = str2num(cfg_dat{6,2});
exp_data.array.wedge.roof_angle = str2num(cfg_dat{7,2});
exp_data.array.wedge.velocity = str2num(cfg_dat{8,2});
exp_data.array.wedge.length = str2num(cfg_dat{9,2})*1e-3;
exp_data.array.wedge.width = str2num(cfg_dat{10,2})*1e-3;
exp_data.array.wedge.height = str2num(cfg_dat{11,2})*1e-3;
exp_data.array.wedge.Elem1_Pos_X = str2num(cfg_dat{12,2});
exp_data.array.wedge.Elem1_Pos_Y = str2num(cfg_dat{13,2});
exp_data.array.wedge.Elem1_Pos_Z = str2num(cfg_dat{14,2});
exp_data.array.wedge.Elem1_Wedge_Pos_X = str2num(cfg_dat{15,2});
exp_data.array.wedge.Elem1_Wedge_Pos_Y = str2num(cfg_dat{16,2});





el_xc=[1:num_els]*pitch;        %%Distance from centre of PCS X axis calculated 
exp_data.array.el_xc=el_xc-mean(el_xc);
exp_data.array.el_x1=exp_data.array.el_xc-pitch/2;
%exp_data.array.el_x2=exp_data.array.el_xc+pitch/2;  %changed to x2
exp_data.array.el_yc=zeros(size(el_xc));
exp_data.array.el_y1=exp_data.array.el_yc;
%exp_data.array.el_y2=exp_data.array.el_yc;
exp_data.array.el_zc=zeros(size(el_xc));
exp_data.array.el_z1=exp_data.array.el_zc;
%exp_data.array.el_z2=exp_data.array.el_zc;

count=0;
for ii=1:num_els
    for jj=1:num_els
        count=count+1;
        exp_data.tx(count)=ii;
        exp_data.rx(count)=jj;
    end
end

%save(fname,'exp_data')
end
