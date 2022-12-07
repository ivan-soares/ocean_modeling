    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools

    addpath ~/roms/matlab/grid
    addpath ~/roms/matlab/landmask
    addpath ~/roms/matlab/utility

    f1 = 'grid_bca0.00833_01b.nc';
    f2 = 'grid_acu0.00833_01b.nc';

    var = {'u';'v';'psi'}

    r1.lon = nc_varget(f1,'lon_rho');
    r1.lat = nc_varget(f1,'lat_rho');
    r1.msk = nc_varget(f1,'mask_rho');
    r1.prf = nc_varget(f1,'h');
    
    r1.prf(find(r1.prf <= 5.)) = 5.;
    r1.prf = r1.prf.*r1.msk
    r1.prf(find(r1.prf <= 0)) = 0.1
    nc_varput(f2,['h_rho'],r1.prf)
    
        
    for n = 1:3

        v = var{n}

        r2.lon = nc_varget(f2,['lon_' v]);
        r2.lat = nc_varget(f2,['lat_' v]);
        r2.msk = nc_varget(f2,['mask_' v]);
        
        r2.prf = griddata(r1.lon,r1.lat,r1.prf,r2.lon,r2.lat);

        r2.prf(find(r2.prf <= 5.)) = 5.;
        r2.prf = r2.prf.*r2.msk
        r2.prf(find(r2.prf <= 0)) = 0.1;
    
        nc_varput(f2,['h_' v],r2.prf)

    end
   

   
   
   
    