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

# Turn interactive plotting off
plt.ioff()

#import pylab as plt

from matplotlib.colors import BoundaryNorm
from matplotlib.ticker import MaxNLocator

import matplotlib.dates as mdates

#from mpl_toolkits.basemap import Basemap

###########################################################################################

print(' ')
print(' +++ Starting python program +++ ')
print(' ')

###########################################################################################

year = str(sys.argv[1])

dates = []
kinetic_energy  = []
potential_energy  = []
total_energy  = []
net_volume  = []

infile = 'energy_' + year + '.log'

print(' ')
print(' ... read file ' + infile)
print(' ')

f = open(infile,'r')



while True:
      line = f.readline()
      if not line:
             break
      date = [int(i) for i in line.split(' ')[0:5]]
      newdate = datetime(np.array(date)[0], np.array(date)[1], np.array(date)[2], np.array(date)[3], np.array(date)[4], 0 )
      print(newdate)

      e1 = float(line.split(' ')[6])
      e2 = float(line.split(' ')[7])
      e3 = float(line.split(' ')[8])
      e4 = float(line.split(' ')[9])

      dates.append(newdate)
      kinetic_energy.append(e1)
      potential_energy.append(e2)
      total_energy.append(e3)
      net_volume.append(e4)
      
f.close()

#print(dates)

#x_values = [datetime.strptime(d,"%Y-%m-%d %H:%M:%S").date() for d in dates]
#dtFmt = mdates.DateFormatter("%Y-%m-%d %H:%M:%S")

E1 = np.array(kinetic_energy)/np.array(net_volume)
E2 = np.array(potential_energy)/np.array(net_volume)
E3 = np.array(total_energy)/np.array(net_volume)


################# plots

figname='energy_' + year + '.png'

fig, (ax1,ax2,ax3) = plt.subplots(3)
ax1.plot(dates,E1); ax1.grid(); ax1.set_xticklabels([])
ax2.plot(dates,E2); ax2.grid(); ax2.set_xticklabels([])
ax3.plot(dates,E3); ax3.grid()

ax1.set_title('Kinetic Energy per volume');ax1.set_ylabel('J/m³')
ax2.set_title('Potential Energy per volume');ax2.set_ylabel('J/m³')
ax3.set_title('Total Energy per volume');ax3.set_ylabel('J/m³')

ax3.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
ax3.xaxis_date(); ax3.tick_params(axis='x', labelrotation=25)
plt.savefig(figname,dpi=100)
plt.close()


#plt.figure()
#plt.plot(dates,rmses); #plt.grid()
#plt.title('RMSE'),plt.xlabel('days'),plt.ylabel('error')
#plt.gca().xaxis.set_major_formatter(dtFmt)
#plt.savefig('rmse.png',dpi=100)
#plt.close()






###########################################################################################

print(' ')
print(' +++ End of python program +++ ')
print(' ')

###########################################################################################


