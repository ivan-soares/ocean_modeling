
        addpath ~/roms/matlab/netcdf
        addpath ~/roms/matlab/mexcdf/mexnc
        addpath ~/roms/matlab/mexcdf/snctools

        addpath ~/roms/matlab/grid
        addpath ~/roms/matlab/landmask
        addpath ~/roms/matlab/utility

        addpath ~/roms/matlab/seagrid
        addpath ~/roms/matlab/seagrid/presto
        
        f1 = 'etopo_cut.nc'
        f2 = 'grid.nc'
        
        lon1 = nc_varget(f1,'lon');
        lat1 = nc_varget(f1,'lat');
        prf1 = nc_varget(f1,'z');
        
        lon2 = nc_varget(f2,'lon');
        lat2 = nc_varget(f2,'lat');
%         prf2 = nc_varget(f2,'z');
        
%         msk2 = ones(size(prf2));
%         msk2(find(prf2 >= 0)) = 0;
        
        load costa_leste_com_ilhas
        
        plot(lon2,lat2,'g','LineWidth',0.5), axis equal, hold on
        plot(lon2',lat2','g','LineWidth',0.5)
        plot(lon,lat,'m')
        
%         figure
%         pcolor(lon1,lat1,prf1), shading flat, axis equal, colorbar, hold on
%         pcolor(lon2,lat2,prf2), shading flat, axis equal
%         
%         figure
%         pcolor(lon2,lat2,prf2./msk2),  shading flat, axis equal, colorbar
        