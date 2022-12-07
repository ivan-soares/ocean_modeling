addpath ~/roms/matlab/netcdf
addpath ~/roms/matlab/mexcdf/mexnc
addpath ~/roms/matlab/mexcdf/snctools

today = '20210101';
outfile = ['altimeter_tracks_' today '.png'];

sat = {'al';'c2n';'h2b';'j3';'s3a';'s3b'};
satname = {'Altika';'Cryosat 2';'Haiyang- 2B';'Jaison 3';'Sentinel 3A';'Sentinel 3B'};
trackcol = {'.b';'.c';'.r';'.m';'.k';'.g'};
satcolor = {'b';'c';'r';'m';'k';'g'};

lati = [-22.25,-22.50,-22.75,-23.00,-23.25,-23.50];

load costa_sudeste

close all
fill(lon,lat,[.2 .6 .4]), hold on
title('Altimeters tracks from 2021-01-01 to 2021-01-10')
xlabel('Longitude'); ylabel('Latitude')

grid = '../conf/roms_grid_bsa0.10.nc'
glon = nc_varget(grid,'lon_rho');
glat = nc_varget(grid,'lat_rho');
[nlat,nlon] = size(glon)

g = [glon(1,1),       glat(1,1);    ... 
     glon(nlat,1),    glat(nlat,1);  ...
     glon(nlat,nlon), glat(nlat,nlon); ...
     glon(1,nlon),    glat(1,nlon); ...
     glon(1,1),       glat(1,1)];
     
     
plot(g(:,1), g(:,2),'k')
     
     
for n=1:6

infile = ['../trunk/obs_' sat{n} '_' today '.nc']
slon = nc_varget(infile,'lon');
slat = nc_varget(infile,'lat');

plot(slon,slat,trackcol{n})
text(-48.5,lati(n),satname{n},'color',satcolor{n})
end

eval(['print -dpng ' outfile])

