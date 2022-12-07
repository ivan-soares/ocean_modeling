
    function plot_across_zonal_hycom(infile,model,tt,reflat,var,A)
    
    addpath ~/apps/mymatlab/ivans
    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/netcdf

    lat = nc_varget(infile,'lat'); nlat = length(lat)
    lon = nc_varget(infile,'lon')-360; nlon = length(lon)
    depth = nc_varget(infile,'depth'); nz = length(depth)

 
    for n = 1:nz
        prof(n,1:nlon) = -depth(n);
        dist(n,:) = lon(:);
    end

    %keyboard
    
    switch (var)
        case 'temp'
            t = squeeze(nc_varget(infile,'water_temp', [0 0 reflat 0],[1 nz 1 nlon]));
            pcolor(dist,prof,t), shading interp, colorbar, colormap(mypal_redblue(40)); caxis([2 27])
            title([model ' Temperature @ latitude  ' num2str(lat(reflat,1))])
        case 'salt'
            s = squeeze(nc_varget(infile,'salinity', [0 0 reflat 0],[1 nz 1 nlon]));
            pcolor(dist,prof,s), shading interp, colorbar, colormap(mypal_redblue(40)); caxis([32.5 37.5])
            title([model ' Salinity @ latitude  ' num2str(lat(reflat,1))])
        case 'vvel'
            v = squeeze(nc_varget(infile,'water_v',[0 0 reflat 0],[1 nz 1 nlon]));
            pcolor(dist,prof,v), shading interp, colorbar, colormap(mypal_redblue(40)); caxis([-.25 .25])
            title([model ' Velocity @ latitude  ' num2str(lat(reflat,1))])
        otherwise
            disp('Unknown variable')
    end

    ylabel('Depth'), xlabel('Longitude')
    axis([A])
   
