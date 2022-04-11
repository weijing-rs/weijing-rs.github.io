%;+
%; :Author: Dr. Jing Wei (Email: weijing_rs@163.com)
%;-

%Define work and output paths
WorkPath = 'F:\CHAP\codes\test\';
OutPath = WorkPath;

%Define air pollutant type 
%e.g., PM1, PM2.5, PM10, O3, NO2, SO2, and CO, et al.
AP = 'PM2.5';

%Define spatial resolution 
%e.g., 1 km ≈ 0.01 degree
SP = 0.01; %Degrees

fdir = dir([WorkPath,'*.nc']);

nc_lon = ncread([WorkPath,fdir(1).name],'lon');
nc_lat = ncread([WorkPath,fdir(1).name],'lat');
num_lon = double(length(nc_lon));
num_lat = double(length(nc_lat));
min_lon = double(min(nc_lon));
max_lon = double(max(nc_lon));
max_lat = double(max(nc_lat));
min_lat = double(min(nc_lat));
unit_lon = SP; %(max_lon-min_lon)/(length(nc_lon)-1);
unit_lat = SP; %(max_lat-min_lat)/(length(nc_lat)-1);
nc_R = georefcells([min_lat-unit_lat/2,max_lat+unit_lat/2],...
    [min_lon-unit_lon/2,max_lon+unit_lon/2],[num_lat,num_lon]);

for i = 1:length(fdir)
    data = ncread([WorkPath,fdir(i).name],AP);
    data = flip(single(data)');
    %Define missing value: from NaN to -999
    %temp_pollutant(isnan(data))=-999;
    %Define output file
    outfile = [OutPath,fdir(i).name(1:end-3),'.tif'];
    geotiffwrite(outfile,data,nc_R);
    disp([outfile, ' Finished']);
end
