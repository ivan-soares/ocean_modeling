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

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

from matplotlib.colors import BoundaryNorm
from matplotlib.ticker import MaxNLocator

#from mpl_toolkits.basemap import Basemap

###########################################################################################

print(' ')
print(' +++ Starting python program +++ ')
print(' ')

###########################################################################################

grdfile = Dataset(str(sys.argv[1]),'r')
clmfile = Dataset(str(sys.argv[2]),'r')
newgrid = Dataset(str(sys.argv[3]),'r+')

prf = grdfile.variables['h'] [:]
msk = grdfile.variables['mask_rho'] [:]
#msk = np.where(tmp > 0, -1, 0)
nlat, nlon = msk.shape

nlevs = 30*np.ones((nlat,nlon)) * msk

vars01 = 'spherical','Vtransform', 'Vstretching', 'theta_s', 'theta_b', 'Tcline', 'hc', 's_rho', 's_w', 'Cs_r', 'Cs_w'
vars02 = 'lon_rho', 'lat_rho', 'mask_rho', 'lon_u', 'lat_u', 'mask_u', 'lon_v', 'lat_v', 'mask_v'

for n in range(len(vars01)):
    print(vars01[n])
    newgrid.variables[vars01[n]] [:] = clmfile.variables[vars01[n]] [:]

for n in range(len(vars02)):
    print(vars02[n])
    newgrid.variables[vars02[n]] [:] = grdfile.variables[vars02[n]] [:]

newgrid.variables['h'] [:] = prf * msk 
newgrid.variables['num_levels'][:] = nlevs

newgrid.close()
grdfile.close()
clmfile.close()

###########################################################################################

print(' ')
print(' +++ End of python program +++ ')
print(' ')

###########################################################################################


