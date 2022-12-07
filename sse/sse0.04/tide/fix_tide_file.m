addpath /home/ivans/roms/matlab/netcdf
addpath /home/ivans/roms/matlab/mexcdf/mexnc
addpath /home/ivans/roms/matlab/mexcdf/snctools

f1 = 'tide_sse0.04_01a_2014_ref2000.nc';

lon = nc_varget(f1,'lon_rho');
lat = nc_varget(f1,'lat_rho');
msk = nc_varget(f1,'mask_rho');

period = nc_varget(f1,'tide_period');
epha = nc_varget(f1,'tide_Ephase');
eamp = nc_varget(f1,'tide_Eamp');
cpha = nc_varget(f1,'tide_Cphase');
cang = nc_varget(f1,'tide_Cangle');
cmin = nc_varget(f1,'tide_Cmin');
cmax = nc_varget(f1,'tide_Cmax');

%cmin(isnan(cmin)) = 0;
%nc_varput(f1,'tide_Cmin',cmin)

%pcolor(lon,lat,squeeze(epha(1,:,:epha))), shading flat, axis equal, colorbar