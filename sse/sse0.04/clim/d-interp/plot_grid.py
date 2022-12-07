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

roms = Dataset('grid_sse0.04_01a.tmpmsk','r')

coastfile = '/home/ivans/data/costas/costa_mundo.mat'


# get vars


lon = roms.variables['lon_rho'][:]
lat = roms.variables['lat_rho'][:]
msk = roms.variables['mask_rho'][:]

# get coast line

coast = sio.loadmat(coastfile)
clon = coast['lon']
clat = coast['lat']

big_title = 'ROMS grid in Santos & Campos Basins'

lon2 = lon[::10,::10]
lat2 = lat[::10,::10]

nlat, nlon = lon.shape
nlat2, nlon2 = lon2.shape

x = np.array(range(0,nlon,10),dtype='str')
y = np.array(range(0,nlat,10),dtype='str') 


######## plot gridlines


plt.figure()
plt.contourf(lon,lat,msk)
plt.plot(lon2,lat2,'y',linewidth = 0.5);
plt.plot(lon2.transpose(),lat2.transpose(),'y',linewidth = 0.5);
A = plt.axis(); plt.plot(clon,clat,'k', linewidth = 0.5); plt.axis(A)
plt.title(big_title),plt.xlabel('longitude'),plt.ylabel('latitude')
#for d in range(0,nlon2b):
#    plt.text(lon2b[10,d],lat2b[10,d],x2[d], size=4, weight='bold')
#for d in range(0,nlat2b):
#    plt.text(lon2b[d,10],lat2b[d,10],y2[d], size=4, weight='bold')
plt.savefig('sse_gridmask.png',dpi=100)
plt.close()










