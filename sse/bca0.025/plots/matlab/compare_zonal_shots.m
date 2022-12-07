
    function compare_zonal_shots(grdfile,infile1,infile2,tt,reflat1,reflat2,var)

    % grdfile is ROMS gridfile
    switch (var)
        case {'temp','salt'}
            lon1=nc_varget(grdfile,'lon_rho'); nlon1 = size(lon1,2)
            lat1=nc_varget(grdfile,'lat_rho'); nlat1 = size(lat1,1)
            msk1=nc_varget(grdfile,'mask_rho');
        case {'vvel'}
            lon1=nc_varget(grdfile,'lon_v'); nlon1 = size(lon1,2)
            lat1=nc_varget(grdfile,'lat_v'); nlat1 = size(lat1,1)
            msk1=nc_varget(grdfile,'mask_v');
        otherwise
            disp('Unknown variable')
    end

    % infile2 is CODA or NEMO, lon/lat names doesnt change
    lon2=nc_varget(infile2,'lon'); nlon2 = length(lon2)
    lat2=nc_varget(infile2,'lat'); nlat2 = length(lat2)
    
    % get ROMS prof
    csr = nc_varget(infile1,'Cs_r'); nsig=length(csr);
    prf = squeeze(nc_varget(infile1,'h',[reflat1 0],[1 nlon1]));
    
    for n = 1:nsig
        prof1(n,:) = csr(n).*prf(:);
        dist1(n,:) = lon1(reflat1,:);
    end
    
    % get CODA prof
    dep = nc_varget(infile2,'depth'); nz = length(dep)
    
    for n = 1:nlon2
        prof2(:,n) = -dep(:);
    end
    
    for n = 1:nz
        dist2(n,:) = lon2(:);
    end
    
    switch (var)
        case 'temp'
            t1 = squeeze(nc_varget(infile1,'temp',      [tt 0 reflat1 0],[1 nsig 1 nlon1]));
            t2 = squeeze(nc_varget(infile2,'water_temp',[tt 0 reflat2 0],[1 nz   1 nlon2]));
        case 'salt'
            t1 = squeeze(nc_varget(infile1,'salt',    [tt 0 reflat1 0],[1 nsig 1 nlon1]));
            t2 = squeeze(nc_varget(infile2,'salinity',[tt 0 reflat2 0],[1 nz   1 nlon2]));
        case 'vvel'
            t1 = squeeze(nc_varget(infile1,'v',      [tt 0 reflat1 0],[1 nsig 1 nlon1]));
            t2 = squeeze(nc_varget(infile2,'water_v',[tt 0 reflat2 0],[1 nz   1 nlon2]));
    end
        
    for n = 1:nsig
        t1(n,:) = t1(n,:)./msk1(reflat1,:);
    end
    
    switch (var)
        case 'temp'
            subplot(2,1,1)
            pcolor(dist1,prof1,t1), shading interp, colorbar, colormap(flipud(mypal3(0.75))); caxis([2 27])
            title(['ROMS Temperature @ latitude  ' num2str(lat1(reflat1,1))])
            axis([-50.4 -39.6 -1000 0])
            ylabel('Depth')
            subplot(2,1,2)
            pcolor(dist2,prof2,t2), shading interp, colorbar, colormap(flipud(mypal3(0.75))); caxis([2 27])
            title(['CODA Temperature @ latitude  ' num2str(lat2(reflat2))])
            ylabel('Depth'), xlabel('Longitude')
            axis([-50.4 -39.6 -1000 0])
        case 'salt'
            s = squeeze(nc_varget(infile,'salt', [tt 0 reflat 0],[1 nsig 1 nlon]));
            pcolor(dist,prof,s), shading interp, colorbar, colormap(mypal_ssec); caxis([32.5 37.5])
            title([model ' Salinity @ latitude  ' num2str(lat(reflat,1))])
        case 'vvel'
            v = squeeze(nc_varget(infile,'v',[tt 0 reflat 0],[1 nsig 1 nlon]));
            pcolor(dist,prof,v), shading interp, colorbar, colormap(mypal_ssec); caxis([-1 1])
            title([model ' Velocity @ latitude  ' num2str(lat(reflat,1))])
        otherwise
            disp('Unknown variable')
    end

  

   
