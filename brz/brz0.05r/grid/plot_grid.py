###########################################################################################

#       Python program by IDS @ TOC, Florianopolis, Brazil
#                                                                       2021-02-01

###########################################################################################

import os.path, gc, sys
home = os.path.expanduser('~')
sys.path.append(home + '/scripts/python/')

import math
import numpy as np
import scipy.io as sio

from netCDF4 import Dataset
from datetime import datetime, timedelta

#import matplotlib
#matplotlib.use('Agg')
import matplotlib.pyplot as plt

# Turn interactive plotting off
plt.ioff()

#import pylab as plt

from matplotlib.colors import BoundaryNorm
from matplotlib.ticker import MaxNLocator

#from mpl_toolkits.basemap import Basemap

###########################################################################################

print(' ')
print(' +++ Starting python program +++ ')
print(' ')

###########################################################################################

ny = int(sys.argv[1])

#grid1 = Dataset(str(sys.argv[1]),'r')
#grid2 = Dataset(str(sys.argv[2]),'r')

grid1 = Dataset('d-storage/grid_brz0.05r_01b.nc','r')
grid2 = Dataset('d-storage/grid_brz0.05r_01c.nc','r')
grid3 = Dataset('d-storage/grid_brz0.05r_01d.nc','r')
grid4 = Dataset('d-storage/grid_brz0.05r_01e.nc','r')
grid5 = Dataset('d-storage/grid_brz0.05r_01f.nc','r')

fvars = grid1.variables
fdims = grid1['h'].shape

print(' ')
print(' ... dimensions of vars in file 1 are ' + str(fdims))
print(' ')

lon = grid1.variables['lon_rho'][:]
lat = grid1.variables['lat_rho'][:]
msk = grid1.variables['mask_rho'][:]

prf0 = -1. * grid3.variables['hraw'][0,:,:]
prf1 = -1. * grid1.variables['h'][:]
prf2 = -1. * grid2.variables['h'][:]
prf3 = -1. * grid3.variables['h'][:]
prf4 = -1. * grid4.variables['h'][:]
prf5 = -1. * grid5.variables['h'][:]


tit = 'Bottom topography at latitude ' + str("%.2f" % np.abs(lat[ny,1])) + ' S'
fig = 'bottom_topo_lat_' + str("%.2f" % np.abs(lat[ny,1])) + '.png'

plt.figure()
plt.title(tit); plt.xlabel('Longitude'); plt.ylabel('Latitude')
plt.plot(lon[ny,:],prf0[ny,:], label = 'raw')
plt.plot(lon[ny,:],prf1[ny,:], label = 'npass = 2, order = 4')
plt.plot(lon[ny,:],prf2[ny,:], label = 'npass = 3, order = 4')
plt.plot(lon[ny,:],prf3[ny,:], label = 'npass = 4, order = 4')
plt.plot(lon[ny,:],prf4[ny,:], label = 'npass = 5, order = 4')
plt.plot(lon[ny,:],prf5[ny,:], label = 'npass = 4, order = 5')

plt.grid(); plt.legend()
plt.savefig(fig,dpi=100)
plt.close()

grid1.close()
grid2.close()

###########################################################################################

print(' ')
print(' +++ End of python program +++ ')
print(' ')

###########################################################################################


