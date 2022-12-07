##################################################################

import os, gc
import sys, math
import numpy as np
import math

from netCDF4   import Dataset

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

sys.path.append('/home/ivans/scripts/python/')


####################### names  ###################################

print(' ')
print(' +++ Starting script to make nudge file for ROMS +++')
print(' ')

domain  = str(sys.argv[1])
version = str(sys.argv[2])
itype   = str(sys.argv[3])
iopt    = str(sys.argv[4])

grdfile = 'grid_'  + domain + '_' + version + '.nc'
nudfile = 'nudge_' + domain + '_' + version + '_' + itype + '_' + iopt + '.nc'
   
grd = Dataset(grdfile,'r')
nud = Dataset(nudfile,'r+')

################### nudging params ###############################

nsig = 30   # n. of sigma layers
nnud = 270  # n. of lines toward the center of domain

#### params for linear type

outer = 1.00e+00
inner = 1.00e+02

if   iopt == '1d1yr':
     outer = 1.00e+00                 # border coeff
     inner = 3.65e+02
elif iopt == '1d1mo':
     outer = 1.00e+00                 # border coeff
     inner = 3.00e+01

day   = 1.0e+00                  # could be 86400.00e+00
cff1  = 1.0e+00 / (outer * day)  # day-1
cff2  = 1.0e+00 / (inner * day)  # day-1


#### params for exponential type

border = 1.00e+00  # value of nudging coef at the outer border
decay  = 1.00e+01  # decay toward interior: 30 will be strong

if   iopt == 'strong':
     decay = 30.0e+00
elif iopt == 'medium':
     decay = 10.0e+00
elif iopt == 'weak':
     decay = 1.0e+00

print(' ')
print(' ... domain = ' + domain)
print(' ... version = ' + version)
print(' ... itype = ' + itype)
print(' ... iopt = ' + iopt)
print(' ... decay = ' + str(decay))
print(' ... inner c = ' + str(inner))
print(' ... outer c = ' + str(outer))
print(' ')


##################################################################

rlon = grd.variables['lon_rho'] [:,:]
rlat = grd.variables['lat_rho'] [:,:]
mask = grd.variables['mask_rho'][:,:]
    
nlat = rlat.shape[0]
nlon = rlat.shape[1]
    
coef = np.zeros([nlat,nlon])
    
####################### DO IT !  #################################

if   itype[0:3] in {'exp'}:
     print(' ... will make an exponential decay nudge')
     print(' ... decay = ' + str(decay))
     print(' ')  
     for k in range(nnud):
         for c in range(k, nlon-k):
             coef[       k,c] = border*math.exp(-decay*(k)/nnud)
             coef[nlat-1-k,c] = border*math.exp(-decay*(k)/nnud)

         for r in range(k, nlat-k):
             coef[r,       k] = border*math.exp(-decay*(k)/nnud)
             coef[r,nlon-1-k] = border*math.exp(-decay*(k)/nnud)

elif itype[0:3] in {'lin'}:
     print(' ... will make a linear decay nudge')
     print(' ... cff1 = ' + str(cff1) + ', cff2 = ' + str(cff2))
     print(' ')
     for n in range(nnud):
         iini = n
         iend = nlon-n
         for i in range(iini,iend):
             jini = n
             jend = nlat-1-n
             coef[jini, i] = cff2 + float(nnud-n)*(cff1 - cff2)/float(nnud) #south
             coef[jend, i] = cff2 + float(nnud-n)*(cff1 - cff2)/float(nnud) #north

     for n in range(nnud):
         jini = n
         jend = nlat-n
         for j in range(jini,jend):
             iini = n
             iend = nlon-1-n
             coef[j, iini] = cff2 + float(nnud-n)*(cff1 - cff2)/float(nnud) #west
             coef[j, iend] = cff2 + float(nnud-n)*(cff1 - cff2)/float(nnud) #east

elif itype[0:3] in {'new'}:
     print(' ... will make a 11-line linear decay nudge')
     print(' ')

     ### south

     coef[   0, 0:nlon-0] = 1.0e+00
     coef[   1, 1:nlon-1] = 1.0e+00
     coef[   2, 2:nlon-2] = 0.9e+00
     coef[   3, 3:nlon-3] = 0.8e+00
     coef[   4, 4:nlon-4] = 0.7e+00
     coef[   5, 5:nlon-5] = 0.6e+00
     coef[   6, 6:nlon-6] = 0.5e+00
     coef[   7, 7:nlon-7] = 0.4e+00
     coef[   8, 8:nlon-8] = 0.3e+00
     coef[   9, 9:nlon-9] = 0.2e+00
     coef[  10,10:nlon-10] = 0.1e+00

     ### north

     coef[nlat- 1, 0:nlon-0] = 1.0e+00
     coef[nlat- 2, 1:nlon-1] = 1.0e+00
     coef[nlat- 3, 2:nlon-2] = 0.9e+00
     coef[nlat- 4, 3:nlon-3] = 0.8e+00
     coef[nlat- 5, 4:nlon-4] = 0.7e+00
     coef[nlat- 6, 5:nlon-5] = 0.6e+00
     coef[nlat- 7, 6:nlon-6] = 0.5e+00
     coef[nlat- 8, 7:nlon-7] = 0.4e+00
     coef[nlat- 9, 8:nlon-8] = 0.3e+00
     coef[nlat-10, 9:nlon-9] = 0.2e+00
     coef[nlat-11,10:nlon-10] = 0.1e+00

     ### west

     coef[ 0:nlat-0,   0] = 1.0e+00
     coef[ 1:nlat-1,   1] = 1.0e+00
     coef[ 2:nlat-2,   2] = 0.9e+00
     coef[ 3:nlat-3,   3] = 0.8e+00
     coef[ 4:nlat-4,   4] = 0.7e+00
     coef[ 5:nlat-5,   5] = 0.6e+00
     coef[ 6:nlat-6,   6] = 0.5e+00
     coef[ 7:nlat-7,   7] = 0.4e+00
     coef[ 8:nlat-8,   8] = 0.3e+00
     coef[ 9:nlat-9,   9] = 0.2e+00
     coef[10:nlat-10, 10] = 0.1e+00

     ### east

     coef[ 0:nlat-0, nlon- 1] = 1.0e+00
     coef[ 1:nlat-1, nlon- 2] = 1.0e+00
     coef[ 2:nlat-2, nlon- 3] = 0.9e+00
     coef[ 3:nlat-3, nlon- 4] = 0.8e+00
     coef[ 4:nlat-4, nlon- 5] = 0.7e+00
     coef[ 5:nlat-5, nlon- 6] = 0.6e+00
     coef[ 6:nlat-6, nlon- 7] = 0.5e+00
     coef[ 7:nlat-7, nlon- 8] = 0.4e+00
     coef[ 8:nlat-8, nlon- 9] = 0.3e+00
     coef[ 9:nlat-9, nlon-10] = 0.2e+00
     coef[10:nlat-10,nlon-11] = 0.1e+00

else:
   sys.exit('unknown data base')

#################################################################################

M0 = coef

M1 = np.zeros([nsig, nlat, nlon])
M2 = np.zeros([nsig, nlat, nlon])
M3 = np.zeros([nsig, nlat, nlon])
M4 = np.zeros([nsig, nlat, nlon])

for k in range(nsig):
    M1[k,:,:] = coef
    M2[k,:,:] = coef
    M3[k,:,:] = coef
    M4[k,:,:] = coef

nud_spher = nud.variables['spherical']
nud_rlon  = nud.variables['lon_rho']
nud_rlat  = nud.variables['lat_rho']

nud_m2 = nud.variables['M2_NudgeCoef']
nud_m3 = nud.variables['M3_NudgeCoef']
nud_tp = nud.variables['temp_NudgeCoef']
nud_sl = nud.variables['salt_NudgeCoef']
nud_tr = nud.variables['tracer_NudgeCoef']

nud_spher[:] = 1
nud_rlon[:,:] = rlon
nud_rlat[:,:] = rlat

nud_m2[:,:] = M0
nud_m3[:,:] = M1
nud_tp[:,:] = M2
nud_sl[:,:] = M3
nud_tr[:,:] = M4

################################################################################
#                              end of script
################################################################################
