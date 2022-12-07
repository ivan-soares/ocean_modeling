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

#f1 = '/home/ivans/roms/cases/brz/brz0.05/grid/grid_brz0.05_01g.nc'
f2 = '/home/ivans/roms/cases/sse/sse0.04/grid/grid_sse0.04_01a.nc'
#f3 = '/home/ivans/roms/cases/sse/bca0.025/grid/grid_bca0.00833_01a.nc'

coastfile = '/home/ivans/data/costas/costa_mundo.mat'

#roms01 = Dataset(f1,'r')
roms02 = Dataset(f2,'r')
#roms03 = Dataset(f3,'r')

# get vars

#lon1 = roms01.variables['lon_rho'][:]
#lat1 = roms01.variables['lat_rho'][:]
#msk1 = roms01.variables['mask_rho'][:]
#prf1 = roms01.variables['h'][:]

lon2 = roms02.variables['lon_rho'][:]
lat2 = roms02.variables['lat_rho'][:]
msk2 = roms02.variables['mask_rho'][:]
prf2 = roms02.variables['h'][:]

#lon3 = roms03.variables['lon_rho'][:]
#lat3 = roms03.variables['lat_rho'][:]
#msk3 = roms03.variables['mask_rho'][:]
#prf3 = roms03.variables['h'][:]

# get coast line

coast = sio.loadmat(coastfile)
clon = coast['lon']
clat = coast['lat']

big_title = 'ROMS grid in Santos Bampos Basins'

lon2b = lon2[::10,::10]
lat2b = lat2[::10,::10]

nlat2, nlon2 = lon2.shape
nlat2b, nlon2b = lon2b.shape

x2 = np.array(range(0,nlon2,10),dtype='str')
y2 = np.array(range(0,nlat2,10),dtype='str') 


######## plot gridlines


plt.figure()
#plt.plot(lon2,lat2,'r',linewidth = 0.5);
plt.plot(lon2b,lat2b,'k',linewidth = 0.5);
plt.plot(lon2b.transpose(),lat2b.transpose(),'k',linewidth = 0.5);
A = plt.axis(); plt.plot(clon,clat,'k', linewidth = 0.5); plt.axis(A)
plt.title(big_title),plt.xlabel('longitude'),plt.ylabel('latitude')
for d in range(0,nlon2b):
    plt.text(lon2b[10,d],lat2b[10,d],x2[d], size=4, weight='bold')
for d in range(0,nlat2b):
    plt.text(lon2b[d,10],lat2b[d,10],y2[d], size=4, weight='bold')
plt.savefig('sse_grid.png',dpi=100)
plt.close()










