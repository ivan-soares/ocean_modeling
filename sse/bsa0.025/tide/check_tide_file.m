
addpath /home/ivans/roms/matlab/netcdf
addpath /home/ivans/roms/matlab/mexcdf/mexnc
addpath /home/ivans/roms/matlab/mexcdf/snctools
addpath /home/ivans/roms/matlab/roms_otps

file = 'tide_bsa0.025_01a_2019_ref2000.nc'

lon = nc_varget(file,'lon_rho');
lat = nc_varget(file,'lat_rho');
msk = nc_varget(file,'mask_rho');

epha = nc_varget(file,'tide_Ephase');
eamp = nc_varget(file,'tide_Eamp');
cpha = nc_varget(file,'tide_Cphase');
cang = nc_varget(file,'tide_Cangle');
cmin = nc_varget(file,'tide_Cmin');
cmax = nc_varget(file,'tide_Cmax');

if max(max(max(isnan(epha)))) ~= 0 , disp('Ephase has NaNs'), else , disp('Ephase is OK'), end
if max(max(max(isnan(eamp)))) ~= 0 , disp('Eamp   has NaNs'), else , disp('Eamp   is OK'), end
if max(max(max(isnan(cpha)))) ~= 0 , disp('Cphase has NaNs'), else , disp('Cphase is OK'), end
if max(max(max(isnan(cang)))) ~= 0 , disp('Cangle has NaNs'), else , disp('Cangle is OK'), end
if max(max(max(isnan(cmin)))) ~= 0 , disp('Cmin   has NaNs'), else , disp('Cmin   is OK'), end
if max(max(max(isnan(cmax)))) ~= 0 , disp('Cmax   has NaNs'), else , disp('Cmax   is OK'), end

cmin(isnan(cmin)) = 0;

disp(' ')
if max(max(max(isnan(cmin)))) ~= 0 , disp('Cmin   has NaNs'), else , disp('Cmin   is OK'), end

nc_varput(file,'tide_Cmin',cmin)

