########################################################################################

#    write grid distance and metric factors: 

#          x_rho: X location of RHO-points (meter)
#          y_rho: Y location of RHO-points (meter)
#                 the same for x_u, y_u, x_v, y_v, x_psi, y_psi

#          pn: curvilinear coordinate metric in XI  (meter -1)
#          pm: curvilinear coordinate metric in ETA (meter -1)

#          dndx: XI-derivative  of inverse metric factor pn (meter)
#          dmde: ETA-derivative of inverse metric factor pm (meter)
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

print(' ')
print(' +++ MAKE GRID STEP 03: PYTHON program to write grid metrics +++')
print(' ')

########################################################################################

grdfile = str(sys.argv[1])
grd = Dataset(grdfile, 'r+')

radius = 6.37e+06          # Radius of Earth
twopi = 2.0e+00 * np.pi    # 2 * Pi
dfac = np.pi / 1.8e+02     # division factor: Pi/180

delta = float(sys.argv[2]) # grid resolution in degrees
angle = float(sys.argv[3]) # grid rotation angle

print(' ')
print(' ... grid delta x is ' + str(delta))
print(' ... grid angle is ' + str(angle))
print(' ')

angle = angle * np.pi / 180.0


var = ['u', 'v', 'psi', 'rho']
nvars = len(var)

#################   compute x, y, delx, dely 

for n in range(nvars):

    lon_name = 'lon_'  + var[n]
    lat_name = 'lat_'  + var[n]
    msk_name = 'mask_' + var[n]

    x_name = 'x_' + var[n]
    y_name = 'y_' + var[n]

    print(' '); print(' ... compute ' + x_name + ' and ' + y_name) 

    lon = grd.variables[lon_name] [:, :]
    lat = grd.variables[lat_name] [:, :]
    msk = grd.variables[msk_name] [:, :]

    nrow = msk.shape[0]
    ncol = msk.shape[1]

    grd_size = str(nrow) + ' rows x ' + str(ncol) + ' cols'
    print(' ... ' + var[n] + ' grid is sized ' + grd_size)

    x = np.zeros([nrow, ncol])
    y = np.zeros([nrow, ncol])

    delta_x = np.zeros([nrow, ncol])
    delta_y = np.zeros([nrow, ncol])

    for r in range(nrow):
        for c in range(ncol):
            coslat = np.cos(lat[r, c] * dfac)
            delta_x[r, c] = twopi * radius * coslat * delta / 3.6e+02
        for c in range(ncol-1):
            x[r,c+1] = x[r,c] + delta_x[r, c]
        


    for c in range(ncol):
        for r in range(nrow):
            delta_y[r, c] = twopi * radius * delta / 3.6e+02
        for r in range(nrow-1):
            y[r+1,c] = y[r,c] + delta_y[r, c]

    ####  write out x,y

    grd.variables[x_name] [:] = x[:]
    grd.variables[y_name] [:] = y[:]


#################   set spherical (0/1), xl, el

print(' '); print(' ... set spherical, xl, el & angle '); print(' ')

nr2 = int(nrow/2)
nc2 = int(ncol/2)

spheri = 1
#angle = np.ones[[nrow,ncol]] * angle * np.pi / 180.

xl = np.cumsum(delta_x[nr2, :]); XL = delta_x[nr2,0] + xl[len(xl)-1]; print(' ... xl = ' + str(XL))
el = np.cumsum(delta_y[:, nc2]); EL = delta_y[0,nc2] + el[len(el)-1]; print(' ... el = ' + str(EL))

grd.variables['xl'][:] = XL
grd.variables['el'][:] = EL
grd.variables['spherical'] = spheri
grd.variables['angle'] [:] = -angle


#	int spherical ;
#		spherical:long_name = "grid type logical switch" ;
#		spherical:flag_values = 0, 1 ;
#		spherical:flag_meanings = "Cartesian spherical" ;
#	double xl ;
#		xl:long_name = "basin length in the XI-direction" ;
#		xl:units = "meter" ;
#	double el ;
#		el:long_name = "basin length in the ETA-direction" ;
#		el:units = "meter" ;
#	double angle(eta_rho, xi_rho) ;
#		angle:long_name = "angle between XI-axis and EAST" ;
#		angle:units = "radians" ;

#################   compyte pn, pm, dndx, dmde & angle

print(' '); print(' ... compute pn, pm, dndx, dmde '); print(' ')

pm = 1.0e+00 / delta_x
pn = 1.0e+00 / delta_y    

dndx = np.zeros([nrow, ncol])
dmde = np.zeros([nrow, ncol])


i = delta_x.shape[0]
j = delta_x.shape[1]

print(' '); print(' ... delta x is dimensioned ' + str(i) + ' x ' + str(j))
print(delta_x)

i = delta_y.shape[0]
j = delta_y.shape[1]

print(' '); print(' ... delta y is dimensioned ' + str(i) + ' x ' + str(j))
print(delta_y)

for r in range(1, nrow-1):
    #print(' r = ' + str(r))
    for c in range(1, ncol-1):
        #print(' c = ' + str(c))
        dndx[r, c] = 0.5 * (delta_y[r, c+1] - delta_y[r, c-1])
        dmde[r, c] = 0.5 * (delta_x[r+1, c] - delta_x[r-1, c])

nr = nrow-1
nc = ncol-1

#west: col 0
dndx[:, 0] = dndx[:, 1]
dmde[:, 0] = dmde[:, 1]

#east: col ncol
dndx[:, nc] = dndx[:, nc-1]
dmde[:, nc] = dmde[:, nc-1]

#south: row 0
dndx[0, :] = dndx[1, :]
dmde[0, :] = dmde[1, :]
 
#north: row nrow
dndx[nr, :] = dndx[nr-1, :]
dmde[nr, :] = dmde[nr-1, :]

grd.variables['pm'] [:] = pm[:]
grd.variables['pn'] [:] = pn[:]
grd.variables['dndx'] [:] = dndx[:]
grd.variables['dmde'] [:] = dmde[:]

grd.close()

print(' ')
print(' +++ END of STEP 03 +++')
print(' ')


#  Lp = nrow
#  Mp = ncol

#  L = Lp-1;   Lm = L-1;
#  M = Mp-1;   Mm = M-1;

#  pm = 1.0./dx;
#  pn = 1.0./dy;

#  dndx(2:L,2:M) = 0.5.*(1.0./pn(3:Lp,2:M ) - 1.0./pn(1:Lm,2:M ));
#  dmde(2:L,2:M) = 0.5.*(1.0./pm(2:L ,3:Mp) - 1.0./pm(2:L ,1:Mm));

#  dndx(1  ,:)=dndx(2    ,:);
#  dndx(end,:)=dndx(end-1,:);
#  dndx(:,  1)=dndx(:,    2);
#  dndx(:,end)=dndx(:,end-1);

#  dndx(1  ,  1)=0.5*(dndx(1    ,    2)+dndx(2    ,    1));
#  dndx(1  ,end)=0.5*(dndx(1    ,end-1)+dndx(2    ,  end));
#  dndx(end,  1)=0.5*(dndx(end  ,    2)+dndx(end-1,    1));
#  dndx(end,end)=0.5*(dndx(end-1,  end)+dndx(end  ,end-1));

#  dmde(1  ,  :)=dmde(2    ,:);
#  dmde(end,  :)=dmde(end-1,:);
#  dmde(:  ,  1)=dmde(:,    2);
#  dmde(:  ,end)=dmde(:,end-1);

#  dmde(1  ,  1)=0.5*(dmde(1    ,    2)+dmde(2    ,    1));
#  dmde(1  ,end)=0.5*(dmde(1    ,end-1)+dmde(2    ,  end));
#  dmde(end,  1)=0.5*(dmde(end  ,    2)+dmde(end-1,    1));
#  dmde(end,end)=0.5*(dmde(end-1,  end)+dmde(end  ,end-1));

##############################################################



