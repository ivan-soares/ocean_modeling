
F0 = '~/roms/cases/sse/bsa1.50/clim/python/grid_bsa1.50_02c.nc';
F1 = '~/roms/cases/sse/bsa1.50/clim/python/clim_bsa1.50_02c_2012_glbu.nc'
F2 = '~/roms/cases/sse/bsa1.50/clim/python/glbu_bsa1.12_2012.nc'


figure, compare_zonal_shots(F0,F1,F2,140,120,43,'temp')
figure, compare_zonal_shots(F0,F1,F2,140,80,33,'temp')

figure, compare_snap_shots(F0,F1,F2,140,'temp',2012)
figure, compare_snap_shots(F0,F1,F2,140,'salt',2012)
figure, compare_snap_shots(F0,F1,F2,140,'velo',2012)