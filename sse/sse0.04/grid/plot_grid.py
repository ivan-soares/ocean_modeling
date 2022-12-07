###############################################################################

import os.path, gc, sys
home = os.path.expanduser('~')
sys.path.append(home + '/scripts/python/')

import math
import numpy as np
import scipy.io as sio

from netCDF4 import Dataset
from datetime import datetime, timedelta

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# Turn interactive plotting off
plt.ioff()

#import pylab as plt

from matplotlib.colors import BoundaryNorm
from matplotlib.ticker import MaxNLocator


###############################################################################


# file names

coastfile = '/home/ivans/data/costas/costa_mundo.mat'
romsfile = '/home/ivans/roms/cases/sse/sse0.04/grid/grid_sse0.04_01b.nc2'
romsfile = Dataset(romsfile,'r')

# get vars

lon = romsfile.variables['lon_rho'][:]
lat = romsfile.variables['lat_rho'][:]
msk = romsfile.variables['mask_rho'][:]
prf = romsfile.variables['h'][:]

# get coast line

coast = sio.loadmat(coastfile)
clon = coast['lon']
clat = coast['lat']

big_title = 'ROMS grid in Santos Bampos Basins'

nlat, nlon = lon.shape

######## plot gridlines


plt.figure()
plt.contourf(lon,lat,msk)
plt.plot(lon,lat,'r',linewidth = 0.5);
plt.plot(lon.transpose(),lat.transpose(),'k',linewidth = 0.5);
A = plt.axis(); plt.plot(clon,clat,'k', linewidth = 0.5); plt.axis(A)
plt.title(big_title),plt.xlabel('longitude'),plt.ylabel('latitude')
plt.savefig('sse_grid.png',dpi=100)
plt.close()










