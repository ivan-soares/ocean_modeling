
    % check deep layer data in HNCODA and NEMO
    
    
    f1 = '/home/brunosr/Casedata/CMEMS/2012/nemo_npo_1.12_2012-01-01.nc';
    f2 = '/home/brunosr/TOC_STORAGE/ROMS_environment/HYCOM_3D_large/N61_S9_E-99_W-171_year2012_m01-01_d01-01_3hr';
    f3 = '/home/brunosr/roms/cases/npo1.125_large/clim/input_npo07b_ini_2012.nc';
    f4 = '/home/brunosr/roms/cases/npo1.125_large/clim/input_npo07b_ini_2012_nemo.nc';
    
    nemo.lon = nc_varget(f1,'longitude',102,1);
    nemo.lat = nc_varget(f1,'latitude', 339,1);
    nemo.prof = -nc_varget(f1,'depth');
    nemo.temp = nc_varget(f1,'thetao',[0 0 339 102],[1 50 1 1]);
    
    coda.lon = nc_varget(f2,'lon', 107,1);
    coda.lat = nc_varget(f2,'lat', 352,1);
    coda.prof = -nc_varget(f2,'depth');
    coda.temp = nc_varget(f2,'water_temp',[0 0 352 107],[1 40 1 1]);
    
    mod1.lon = nc_varget(f3,'lon_rho',[268 44],[1 1]);
    mod1.lat = nc_varget(f3,'lat_rho',[268 44],[1 1]);
    mod1.prof = nc_varget(f3,'Cs_r').*nc_varget(f3,'h',[268 44],[1 1]);
    mod1.temp = nc_varget(f3,'temp',[0 0 268 44],[1 30 1 1]);  
    
    mod2.lon = nc_varget(f4,'lon_rho',[268 44],[1 1]);
    mod2.lat = nc_varget(f4,'lat_rho',[268 44],[1 1]);
    mod2.prof = nc_varget(f4,'Cs_r').*nc_varget(f4,'h',[268 44],[1 1]);
    mod2.temp = nc_varget(f4,'temp',[0 0 268 44],[1 30 1 1]);
    
    plot(nemo.temp,nemo.prof,'b', nemo.temp,nemo.prof,'ob', ...
         coda.temp,coda.prof,'r', coda.temp,coda.prof,'or', ...
         mod1.temp,mod1.prof,'c', mod1.temp,mod1.prof,'.c', ...
         mod2.temp,mod2.prof,'m', mod2.temp,mod2.prof,'.m')
     
    legend('nemo','ncoda','roms-coda','roms-nemo')