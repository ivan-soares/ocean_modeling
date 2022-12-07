
function [lon,lat,t,msk] = compare_snap_shots(grdfile,file1,file2,tt,var,year)

    switch (var)
        case {'temp','salt'}
            lon1=nc_varget(grdfile,'lon_rho'); nlon1 = size(lon1,2)
            lat1=nc_varget(grdfile,'lat_rho'); nlat1 = size(lat1,1)
            msk1=nc_varget(grdfile,'mask_rho');
        case {'velo'}
            lon1=nc_varget(grdfile,'lon_rho'); nlon1 = size(lon1,2)
            lat1=nc_varget(grdfile,'lat_rho'); nlat1 = size(lat1,1)
            lon_u=nc_varget(grdfile,'lon_u'); nlon_u = size(lon_u,2)
            lat_u=nc_varget(grdfile,'lat_u'); nlat_u = size(lat_u,1)
            lon_v=nc_varget(grdfile,'lon_v'); nlon_v = size(lon_v,2)
            lat_v=nc_varget(grdfile,'lat_v'); nlat_v = size(lat_v,1)
            msk1=nc_varget(grdfile,'mask_rho');
        otherwise
            disp('Unknown variable')
    end

        lon2 = nc_varget(file2,'lon'); nlon2 = length(lon2)
        lat2 = nc_varget(file2,'lat'); nlat2 = length(lat2)
  
    switch (var)
        case 'temp'
            t1 = squeeze(nc_varget(file1,'temp',      [tt 19 0 0],[1 1 nlat1 nlon1]));
            t2 = squeeze(nc_varget(file2,'water_temp',[tt  0 0 0],[1 1 nlat2 nlon2]));
        case 'salt'
            t1 = squeeze(nc_varget(file1,'salt',    [tt 19 0 0],[1 1 nlat1 nlon1]));
            t2 = squeeze(nc_varget(file2,'salinity',[tt  0 0 0],[1 1 nlat2 nlon2]));
        case 'velo'
            u = squeeze(nc_varget(file1,'u', [tt 19 0 0],[1 1 nlat_u nlon_u]));
            v = squeeze(nc_varget(file1,'v', [tt 19 0 0],[1 1 nlat_v nlon_v]));
            u(:,nlon_u+1) = u(:,nlon_u);
            v(nlat_v+1,:) = v(nlat_v,:);
            t1 = sqrt(u.^2 + v.^2);
            
            u = squeeze(nc_varget(file2,'water_u',[tt 0 0 0],[1 1 nlat2 nlon2]));
            v = squeeze(nc_varget(file2,'water_v',[tt 0 0 0],[1 1 nlat2 nlon2]));
            t2 = sqrt(u.^2 + v.^2);          
    end

    mmin1 = min(min(t1./msk1));
    mmax1 = max(max(t1./msk1));
    
    mmin2 = min(min(t2));
    mmax2 = max(max(t2));
    
    minmax1 = [num2str(mmin1) '/' num2str(mmax1)]
    minmax2 = [num2str(mmin2) '/' num2str(mmax2)]
    
    [lon2,lat2] = meshgrid(lon2,lat2);
    
    switch (var)
        case 'temp'
            pcolor(lon1,lat1,t1./msk1), shading interp, colorbar, colormap(flipud(mypal3(0.75))); caxis([12 28])
            title(['ROMS Temperature @ surface, day ' num2str(tt) ', ' num2str(year) ', min/max = ' minmax1]); A = axis;
            xlabel('Longitude'), ylabel('Latitude')
            figure
            pcolor(lon2,lat2,t2), shading interp, colorbar, colormap(flipud(mypal3(0.75))); caxis([12 28])
            title(['CODA Temperature @ surface, day ' num2str(tt) ', ' num2str(year) ', min/max = ' minmax2]); axis(A);
            xlabel('Longitude'), ylabel('Latitude')
        case 'salt'
            pcolor(lon1,lat1,t1./msk1), shading interp, colorbar, colormap(flipud(mypal3(0.75))); caxis([32.5 37.5])
            title(['ROMS Salinity @ surface, day ' num2str(tt) ', ' num2str(year) ', min/max = ' minmax1]); A = axis;
            xlabel('Longitude'), ylabel('Latitude')
            figure
            pcolor(lon2,lat2,t2), shading interp, colorbar, colormap(flipud(mypal3(0.75))); caxis([32.5 37.5])
            title(['CODA Salinity @ surface, day ' num2str(tt) ', ' num2str(year) ', min/max = ' minmax2]); axis(A);
            xlabel('Longitude'), ylabel('Latitude')
        case 'velo'
            pcolor(lon1,lat1,t1./msk1), shading interp, colorbar, colormap(flipud(mypal3(0.75))); caxis([-.75 .75])
            title(['ROMS Velocity @ surface, day ' num2str(tt) ', ' num2str(year) ', min/max = ' minmax1]); A = axis;
            xlabel('Longitude'), ylabel('Latitude')
            figure
            pcolor(lon2,lat2,t2), shading interp, colorbar, colormap(flipud(mypal3(0.75))); caxis([-.75 .75])
            title(['CODA velocity @ surface, day ' num2str(tt) ', ' num2str(year) ', min/max = ' minmax2]); axis(A);
            xlabel('Longitude'), ylabel('Latitude')         
        otherwise
            disp('Unknown variable')
    end


    
