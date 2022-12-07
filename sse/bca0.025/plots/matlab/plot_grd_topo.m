%%%%%%%%%%%%%%%%%%%  add netcdf paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/netcdf
    addpath ~/apps/mymatlab/ivans
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

roms1 = '/home/ivans/roms/cases/brz/brz0.05/grid/grid_brz0.05_01g.nc'
roms2 = '/home/ivans/roms/cases/sse/bca0.025/grid/grid_bca0.025_01b.nc'
roms3 = '/home/ivans/roms/cases/sse/bca0.025/grid/grid_bca0.00833_01a.nc'

lon1 = nc_varget(roms1,'lon_rho');
lat1 = nc_varget(roms1,'lat_rho');
msk1 = nc_varget(roms1,'mask_rho');
prf1 = nc_varget(roms1,'h');

LO1 = min(min(lon1)); LO2 = max(max(lon1));
LA1 = min(min(lat1)); LA2 = max(max(lat1));
box1 = [ LO1 LA2; LO1 LA1; LO2 LA1; LO2 LA2; LO1 LA2 ];

lon2 = nc_varget(roms2,'lon_rho');
lat2 = nc_varget(roms2,'lat_rho');
msk2 = nc_varget(roms2,'mask_rho');
prf2 = nc_varget(roms2,'h');

LO1 = min(min(lon2)); LO2 = max(max(lon2));
LA1 = min(min(lat2)); LA2 = max(max(lat2));
box2 = [ LO1 LA2; LO1 LA1; LO2 LA1; LO2 LA2; LO1 LA2 ];

lon3 = nc_varget(roms3,'lon_rho');
lat3 = nc_varget(roms3,'lat_rho');
msk3 = nc_varget(roms3,'mask_rho');
prf3 = nc_varget(roms3,'h');

LO1 = min(min(lon3)); LO2 = max(max(lon3));
LA1 = min(min(lat3)); LA2 = max(max(lat3));
box3 = [ LO1 LA2; LO1 LA1; LO2 LA1; LO2 LA2; LO1 LA2 ];

load ~/data/costas/costa_mundo.mat

close all
pcolor(lon1,lat1,prf1./msk1), shading flat, axis equal, colorbar, hold on
title('ROMS GRID BRZ0.05 - Topography'), xlabel('Longitude'), ylabel('Latitude')
pcolor(lon2,lat2,prf2./msk2), shading flat, axis equal, plot(box2(:,1), box2(:,2), 'g','linewidth',2)
pcolor(lon3,lat3,prf3./msk3), shading flat, axis equal, plot(box3(:,1), box3(:,2), 'm','linewidth',2)
text(-44.6765, -18.3088, 'GRID BCA 0.025', 'color','g') 
text(-44.235, -20.3676, 'GRID ACU 0.00833', 'color','m')
print -dpng grid_topo_brz0.05.png

figure 
pcolor(lon2,lat2,prf2./msk2), shading flat, axis equal,colorbar, hold on
title('ROMS GRID BCA0.025 - Topography'), xlabel('Longitude'), ylabel('Latitude')
pcolor(lon3,lat3,prf3./msk3), shading flat, axis equal, plot(box3(:,1), box3(:,2), 'm','linewidth',2)
text(-44.235, -20.3676, 'GRID ACU 0.00833', 'color','m'), axis tight
plot_scale(-37.3453,-26.0188)
print -dpng grid_topo_bca0.025.png

figure 
pcolor(lon3,lat3,prf3./msk3), shading flat, axis equal,colorbar, hold on
title('ROMS GRID ACU0.00833 - Topography'), xlabel('Longitude'), ylabel('Latitude'), axis tight
text(-40.999222, -21.846216, '* ACU','color','m')
plot_scale(-39.9575, -23.0216)
print -dpng grid_topo_acu0.00833.png
