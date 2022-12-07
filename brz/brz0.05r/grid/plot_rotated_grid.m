    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/m_map
    addpath ~/apps/mymatlab/ivans

    gridfile  = 'mask_r.nc';
    coastfile = 'costa_leste.mat';

    load(coastfile);

    g.lon = nc_varget(gridfile,'lon_rho');
    g.lat = nc_varget(gridfile,'lat_rho');
    g.msk = nc_varget(gridfile,'mask_rho');
    g.prf = nc_varget(gridfile,'h');

    g.prf(find(g.prf <= 10.0)) = 10.0;
    g.prf(find(g.msk == 00.0)) = 0.01;
    
    [ny, nx] = size(g.msk);
   

    bbox = [ g.lon(1,1)   g.lat(1,1); ...
             g.lon(ny,1)  g.lat(ny,1); ...
             g.lon(ny,nx) g.lat(ny,nx); ...
             g.lon(1,nx)  g.lat(1,nx); ...
             g.lon(1,1)   g.lat(1,1) ];

    close all

    pcolor(g.lon,g.lat,g.prf./g.msk), shading flat, colormap(jet), colorbar, axis equal, A = axis;
    title('GRID BRZ0.05r - Topografia do fundo do mar')
    xlabel('Longitude'), ylabel('Latitude')
    hold on, fill(lon,lat,[.5 .8 .1]), axis([-55  -25  -42 2])
    plot(bbox(:,1),bbox(:,2),'LineWidth',2), grid on
    print -dpng rotated_grid.png

