########################################################################################

#    write grid diff factor, visc factor & coriolis (f)
#
#                                                          by IDS @ TOC, Ctba 2019

############################ *** importing libraries *** ###############################

import os.path, gc, sys
home = os.path.expanduser('~')
sys.path.append(home + '/scripts/python/')

import numpy as np
import time as tempo

from my_tools import *
from netCDF4  import Dataset

########################################################################################


print(' '); 
print(' +++ MAKE GRID STEP 04: PYTHON program to write diff/visc/coriolis +++')
print(' '); 


grd = Dataset(str(sys.argv[1]),'r+')

lon = grd.variables['lon_rho'] [:]
lat = grd.variables['lat_rho'] [:]
msk = grd.variables['mask_rho'] [:]

nrow = msk.shape[0]
ncol = msk.shape[1]

print(' ')
print(' ... roms grid is sized ' + str(nrow) + ' rows x ' + str(ncol) + ' cols')
print(' ')

coef1 = np.zeros([nrow, ncol])
coef2 = np.zeros([nrow, ncol])

NC1 = 40
NC2 = 40
fac1 = 1000
fac2 = 1000

print(' ')
print(' ... compute and write viscosity and diffusivity coeffs')
print(' ')

# coef1 : viscosity
for k in range(NC1):
    for c in range(k,ncol-k):
        coef1[       k,c] = fac1*(NC1+1-k)/NC1
        coef1[nrow-1-k,c] = fac1*(NC1+1-k)/NC1
       
    
for k in range(NC1):
    for r in range(k,nrow-k):
        coef1[r,k       ] = fac1*(NC1+1-k)/NC1
        coef1[r,ncol-1-k] = fac1*(NC1+1-k)/NC1

#coef2 : diffusivity
for k in range(NC2):
    for c in range(k,ncol-k):
        coef2[       k,c] = fac2*(NC2+1-k)/NC2
        coef2[nrow-1-k,c] = fac2*(NC2+1-k)/NC2


for k in range(NC2):
    for r in range(k,nrow-k):
        coef2[r,k       ] = fac2*(NC2+1-k)/NC2
        coef2[r,ncol-1-k] = fac2*(NC2+1-k)/NC2

####   write out visc/diff coeff


out_visc = grd.variables['visc_factor']
out_diff = grd.variables['diff_factor']

out_visc[:,:] = coef1
out_diff[:,:] = coef2

    
####  compute Coriolis

print(' ')
print(' ... compute and write Coriolis parameter')
print(' ')
   
radius = 6.37e+06
oneday = 8.64e+04
omega  = 2.0e+00 * np.pi / oneday
coriolis = 2.0e+00 * omega * np.sin(lat * np.pi / 180.0e+00)

####  write out coriolis

grd.variables['f'] [:] = coriolis

grd.close()


print(' ')
print(' +++ END of STEP 04 +++')
print(' ')

##############################################################



