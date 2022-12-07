romsfile='/home/ivans/roms/cases/sse/bsa0.02/clim/storage/roms_clm_bsa0.02_03c_glbv_20190801.nc'
hycomfile='/home/ivans/mdata/hncoda/GLBv0.08_65W20W-42S20N/glbv_20190901-000000Z.nc'


close all

A = [ -49 -39 -4000 0];

close all
plot_across_zonal(romsfile,'ROMS',249,200,'vvel',A)
print -dtiff roms.tif

close all
plot_across_zonal_hycom(hycomfile,'HYCOM',0,232,'vvel',A)
print -dtif hycom.tif
