########################################################################################

#    combine gridfiles_r, rid_u, gridfiles_v & gridfiles_p in one roms grid file
#
#                                                          by IDS @ TOC, Ctba 2019

############################ *** importing libraries *** ###############################

import os.path, gc, sys
home = os.path.expanduser('~')
sys.path.append(home + '/scripts/python/')

import numpy as np
import time as tempo

from shapiro  import *
from my_tools import *
from netCDF4  import Dataset

########################################################################################

print(' ')
print(' +++ MAKE GRID STEP 02: PYTHON program to run Shapiro filter on ROMS topo  +++')
print(' ')

########################################################################################


##### grid file name

romsfile = str(sys.argv[1])
romsgrd = Dataset(romsfile,'r+')

##### params for shapiro filter

order = int(sys.argv[2])
scheme = int(sys.argv[3])
npass = int(sys.argv[4])

##### min and max allowable topography

mindep = float(sys.argv[5])
maxdep = float(sys.argv[6])

#print(mindep)
#print(maxdep)

##### Do it for each var type

V = ['psi', 'u' , 'v' , 'rho']; nvars = len(V)

for n in range(nvars):

    var = V[n]

    print(' ')
    print(' ... doing topo at ' + var + ' points ...')
    print(' ')

    prf_name = 'h_'    + var
    lon_name = 'lon_'  + var
    lat_name = 'lat_'  + var
    msk_name = 'mask_' + var

    lon = romsgrd.variables[lon_name] [:]
    lat = romsgrd.variables[lat_name] [:]
    prf = romsgrd.variables[prf_name] [:]
    msk = romsgrd.variables[msk_name] [:]

    # compute r before filtering
    r = rfactor(prf,msk)

    # filter
    prf = shapiro_2d(prf, order, scheme, npass)

    # compute r after filtering
    r = rfactor(prf,msk)

    # fix max, min, mask
    prf[np.where(prf < mindep)] = mindep
    prf[np.where(prf > maxdep)] = maxdep
    prf[np.where(msk == 0)] = 0.0001

    nlat, nlon = np.shape(prf)

    romsgrd.variables[prf_name] [:] = prf[:]

    del lon, lat, msk

#### dont forget to write h

romsgrd.variables['h'] [:] = prf[:]

romsgrd.close()

print(' ')
print(' +++ END of STEP 02 +++')
print(' ')

##########################################################################################



