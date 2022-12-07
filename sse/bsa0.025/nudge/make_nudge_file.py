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
nnud    = int(sys.argv[5])

grdfile = 'grid_'  + domain + '_' + version + '.nc'
nudfile = 'nudge_' + domain + '_' + version + '_' + itype + '_' + iopt + '.nc'
   
grd = Dataset(grdfile,'r')
nud = Dataset(nudfile,'r+')

################### nudging params ###############################

nsig = 30   # n. of sigma layers

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
cff3  = 1.0e+00 / 360.0e+00

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
    
coef = np.ones([nlat,nlon])*cff3
    
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
