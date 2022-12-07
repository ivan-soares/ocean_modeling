
    function plot_across_zonal(infile,model,tt,reflat,var,A)
    
    addpath ~/apps/mymatlab/ivans
    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/netcdf

    switch (var)
        case {'temp','salt'}
            lon=nc_varget(infile,'lon_rho'); nlon = size(lon,2)
            lat=nc_varget(infile,'lat_rho'); nlat = size(lat,1)
        case {'vvel'}
            lon=nc_varget(infile,'lon_v'); nlon = size(lon,2)
            lat=nc_varget(infile,'lat_v'); nlat = size(lat,1)
        otherwise
            disp('Unknown variable')
    end

    csr = nc_varget(infile,'Cs_r'); nsig=length(csr);
    prf = squeeze(nc_varget(infile,'h',[reflat 0],[1 nlon]));
    alat = nc_varget(infile,'lat_rho',[reflat 0],[1 1])
    
    for n = 1:nsig
        prof(n,:) = csr(n).*prf(:);
        dist(n,:) = lon(reflat,:);
    end

    switch (var)
        case 'temp'
            t = squeeze(nc_varget(infile,'temp', [tt 0 reflat 0],[1 nsig 1 nlon]));
            pcolor(dist,prof,t), shading interp, colorbar, colormap(mypal_redblue(40)); caxis([2 27])
            title([model ' Temperature @ latitude  ' num2str(lat(reflat,1))])
        case 'salt'
            s = squeeze(nc_varget(infile,'salt', [tt 0 reflat 0],[1 nsig 1 nlon]));
            pcolor(dist,prof,s), shading interp, colorbar, colormap(mypal_redblue(40)); caxis([32.5 37.5])
            title([model ' Salinity @ latitude  ' num2str(lat(reflat,1))])
        case 'vvel'
            v = squeeze(nc_varget(infile,'v',[tt 0 reflat 0],[1 nsig 1 nlon]));
            pcolor(dist,prof,v), shading interp, colorbar, colormap(mypal_redblue(40)); caxis([-.25 .25])
            title([model ' Velocity @ latitude  ' num2str(lat(reflat,1))])
        otherwise
            disp('Unknown variable')
    end

    ylabel('Depth'), xlabel('Longitude')
    axis([A])
   
