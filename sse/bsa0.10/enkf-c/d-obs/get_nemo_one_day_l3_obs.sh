#!/bin/bash
#

##############################################################################################################

#   bash script to download data from Copernicus Marine Environment Monitoring Service (CMEMS) 
#   it uses moty-client v1.6.0 and python v2.27.12 to download GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS

#   Motu-Client python files were installed as following:

#   python --version                  # It should return: "Python 2.7.X" where "X" is equal or superior to "10"
#   python -m pip install motu-client # It should install and display the version of the motu-client package 
#                                       v1.6.00 as of June 2018.
#   python -m motu-client --help      # If it does return an error, then follow the below workaround.

##############################   help text   #################################################################

     help_txt1="Function get_one-day.sh takes 4 arguments:"
     help_txt2="(1)year, (2)month, (3)day, (4)passwd "
     help_txt3="the passwd shall be in between single quote"

     if [ "$1" == "-h" ]; then
        echo " "
        echo "    Usage: `basename $0` [$help_txt1 $help_txt2]"
        echo " "
        exit 0
     fi

##############################################################################################################

   today=$1

   yr=${today:0:4}
   mm=${today:4:2}
   dd=${today:6:2}

   west=$2
   east=$3
   south=$4
   north=$5
      
   pass=$6

   date1="${yr}-${mm}-${dd} 00:00:00"
   date2="${yr}-${mm}-${dd} 23:00:00"

   echo date ini = $date1
   echo date end = $date2

# sets url, service ID and product ID

   server="https://nrt.cmems-du.eu/motu-web/Motu"
   service='SEALEVEL_GLO_PHY_L3_NRT_OBSERVATIONS_008_044-DGF'
   product='dataset-duacs-nrt-global-al-phy-l3'

# ouput file

   outdir=`pwd`
   outfile="sealevel_L3_nrt_${today}.nc"

# motu client dir

   mdir="$HOME/.local/lib/python2.7/site-packages"
   #mdir="$HOME/apps/motu-client-1.8.5/src/python"
   #mdir="$HOME/Applications/motu-1.4.00/src/python" 

# Do it !!!!!

  python $mdir/motuclient.py --user isoares --pwd $pass --motu $server --service-id $service --product-id $product --date-min $date1 --date-max $date2 --out-dir $outdir --out-name $outfile

#    python $mdir/motuclient.py --user isoares --pwd $pass --motu $server --service-id $service --product-id $product --longitude-min $west --longitude-max $east --latitude-min $south --latitude-max $north --date-min $date1 --date-max $date2 --depth-min $prof1 --depth-max $prof2 --variable so --variable thetao --variable zos --variable uo --variable vo --out-dir $outdir --out-name $outfile

#python -m motuclient --motu https://nrt.cmems-du.eu/motu-web/Motu --service-id SEALEVEL_GLO_PHY_L3_NRT_OBSERVATIONS_008_044-DGF --product-id dataset-duacs-nrt-global-al-phy-l3 --date-min "2021-01-01 00:15:19" --date-max "2021-01-31 18:58:08" --out-dir <OUTPUT_DIRECTORY> --out-name <OUTPUT_FILENAME> --user <USERNAME> --pwd <PASSWORD>

##  end of script
