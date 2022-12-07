###############################################################################

import os, gc, sys
import scipy.io

import numpy as np
import matplotlib.pyplot as plt

sys.path.append('/home/ivans/scripts/python/')

#from get_netcdf import *
from mpl_toolkits.basemap import Basemap
from netCDF4 import Dataset

os.environ['PROJ_LIB'] = '/home/ivans/apps/anaconda-3.7.0/pkgs/proj4-5.2.0-he6710b0_1/share/proj'
os.environ['PROJ_LIB'] = '/home/ivans/apps/anaconda-3.7.0/pkgs/basemap-1.2.0-py37h705c2d8_0/share/basemap'

###############################################################################


# file names

f1 = '/home/ivans/roms/cases/brz/brz0.05/grid/grid_brz0.05_01g.nc'
f2 = '/home/ivans/roms/cases/sse/bca0.025/grid/grid_bca0.025_01c.nc'
f3 = '/home/ivans/roms/cases/sse/bsa0.02/grid/grd_bca0.00833_01a.nc'

coastfile = '/home/ivans/data/costas/costa_mundo.mat'

roms01 = Dataset(f1,'r')
roms02 = Dataset(f2,'r')
roms03 = Dataset(f3,'r')

# get vars

lon1 = roms01.variables['lon_rho'][:]
lat1 = roms01.variables['lat_rho'][:]
msk1 = roms01.variables['mask_rho'][:]
prf1 = roms01.variables['h'][:]

# get coast line

coast = scipy.io.loadmat(coastfile)


big_title = ' Oceanic topography off Brazil '
small_title = 'Campos Bight topography (meters)'

# limits of grid_bca0.025_01b.nc
i1 = [-45.15, -45.14, -35.15, -35.15, -45.15]
j1 = [-19.25, -26.50, -26.50, -19.25, -19.25]

######## plot topography

m = Basemap(projection='merc',llcrnrlat=-35,urcrnrlat=10,\
            llcrnrlon=-55,urcrnrlon=-30,resolution='c')

#m = Basemap(width=3000000,height=5000000,projection='lcc',
#    resolution='c',lat_1=-35.,lat_2=8,lat_0=-15,lon_0=-40.)

m.drawcoastlines()
m.etopo()

# draw parallels and meridians.
m.drawparallels(np.arange(-35.,10.,10.),labels=[True,True,False,False],dashes=[2,2])
m.drawmeridians(np.arange(-50.,30.,10.),labels=[False,False,False,True],dashes=[2,2])

# draw the border of bsa0.02_02c grid
x1,y1 = m(i1, j1)
m.plot(x1, y1, 'r', linewidth=1)

#m.drawmapboundary(fill_color='lightblue')
plt.title(big_title)
plt.savefig('topo.png', dpi = 100)
plt.close()









