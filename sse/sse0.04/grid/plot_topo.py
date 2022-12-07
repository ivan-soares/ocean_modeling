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

f1 = '/home/ivans/roms/cases/sse/sse0.04/grid/grid_sse0.04_01b.nc'

coastfile = '/home/ivans/data/costas/costa_mundo.mat'

roms = Dataset(f1,'r')

# get vars

lon = roms.variables['lon_rho'][:]
lat = roms.variables['lat_rho'][:]
msk = roms.variables['mask_rho'][:]
prf = roms.variables['h'][:]

# get coast line

coast = scipy.io.loadmat(coastfile)

big_title = 'Bacias de Campos e Santos'

# limits of grid_sse0.04_01b.nc

lon1 = lon.min()
lon2 = lon.max()

lat1 = lat.min()
lat2 = lat.max()

i1 = [lon1, lon1, lon2, lon2, lon1]
j1 = [lat2, lat1, lat1, lat2, lat2]

######## plot topography

m = Basemap(projection='merc',llcrnrlat=-33,urcrnrlat=-17,\
            llcrnrlon=-51,urcrnrlon=-30,resolution='i')

#m = Basemap(width=3000000,height=5000000,projection='lcc',
#    resolution='c',lat_1=-35.,lat_2=8,lat_0=-15,lon_0=-40.)

m.drawcoastlines()
m.etopo()

# draw parallels and meridians.
m.drawparallels(np.arange(-35.,-10.,5.),labels=[True,True,False,False],dashes=[2,2])
m.drawmeridians(np.arange(-50.,-30.,5.),labels=[False,False,False,True],dashes=[2,2])

# draw the border of grid
x1,y1 = m(i1, j1)
m.plot(x1, y1, 'r', linewidth=2)

#m.drawmapboundary(fill_color='lightblue')
plt.title(big_title)
plt.savefig('topo.png', dpi = 100)
plt.close()









