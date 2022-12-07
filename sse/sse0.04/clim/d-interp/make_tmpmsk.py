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

f = str(sys.argv[1])

coastfile = '/home/ivans/data/costas/costa_mundo.mat'

roms = Dataset(f,'r+')

# get vars

lon1 = roms.variables['lon_rho'][:]
lat1 = roms.variables['lat_rho'][:]
msk1 = roms.variables['mask_rho'][:]


# write mask values

msk1[:,:] = 1.0

msk1[ 60:140,0:10] = 0.
msk1[140:150,0:20] = 0.
msk1[150:160,0:30] = 0.
msk1[160:170,0:40] = 0.
msk1[170:180,0:60] = 0.
msk1[180:190,0:80] = 0.
msk1[190:200,0:100] = 0.
msk1[200:210,0:110] = 0.
msk1[210:220,0:180] = 0.
msk1[220:230,0:190] = 0.
msk1[230:250,0:200] = 0.
msk1[250:260,0:210] = 0.
msk1[260:280,0:220] = 0.
msk1[280:318,0:230] = 0.

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










