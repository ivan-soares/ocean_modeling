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

f = 'grid_bca0.025_01b.tmpmsk'

coastfile = '/home/ivans/data/costas/costa_mundo.mat'

roms = Dataset(f,'r+')

# get vars

lon1 = roms.variables['lon_rho'][:]
lat1 = roms.variables['lat_rho'][:]
msk1 = roms.variables['mask_rho'][:]


# write mask values

msk1[:,:] = 1.0

msk1[140:150,0:9] = 0.
msk1[150:160,0:60] = 0.
msk1[160:170,0:110] = 0.
msk1[170:180,0:120] = 0.
msk1[180:230,0:150] = 0.
msk1[230:240,0:160] = 0.
msk1[240:250,0:170] = 0.
msk1[250:270,0:180] = 0.
msk1[270:280,0:190] = 0.
msk1[280:292,0:200] = 0.

roms.variables['mask_rho'][:] = msk1[:]
roms.close()

# get coast line

coast = sio.loadmat(coastfile)
clon = coast['lon']
clat = coast['lat']

big_title = 'ROMS grid in Campos Basin'

lon1b = lon1[::10,::10]
lat1b = lat1[::10,::10]

######## plot gridlines


plt.figure()
plt.contourf(lon1,lat1,msk1)
plt.plot(lon1b,lat1b,'k',linewidth = 0.5);
plt.plot(lon1b.transpose(),lat1b.transpose(),'k',linewidth = 0.5);
A = plt.axis(); plt.plot(clon,clat,'k', linewidth = 0.5); plt.axis(A)
plt.title('big_title'),plt.xlabel('longitude'),plt.ylabel('latitude')
plt.savefig('bcampos_grid.png',dpi=100)
plt.close()










