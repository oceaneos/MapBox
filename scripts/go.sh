#!/bin/bash

# go.sh
# Fetches GeoTiffs from NASA NEO
# Processes them using the Oceaneos Imaging Pipeline

#    wget -N ftp://neoftp.sci.gsfc.nasa.gov/geotiff/MY1DMM_CHLORA/2016-07.TIFF
#    ./OceaneosImage.sh --input --debug 2 --zoom 1 --mapbox_account roblabs
#    wget -N ftp://neoftp.sci.gsfc.nasa.gov/geotiff/MY1DMM_CHLORA/2016-08.TIFF
#    ./OceaneosImage.sh --input --debug 2 --zoom 1 --mapbox_account roblabs
#    wget -N ftp://neoftp.sci.gsfc.nasa.gov/geotiff/MY1DMM_CHLORA/2016-09.TIFF
#    ./OceaneosImage.sh --input --debug 2 --zoom 1 --mapbox_account roblabs

# Testing parameters
# Alternatively skip wget
# set this 1 to wget files from the FTP SERVER_ROOT
#  set to 0 to skip wget.  That is, if you've already downloaded a sample set
wget_tiff=1

# Alternatively, preflight the script to make sure its going to go off properly
# set to 1 to echo the script call to the screen, but don't run the script
#  set to 0 to echo and run the script.  Set to 0 for production, set to 1 for testing
preflight=0

ftp_root=ftp://neoftp.sci.gsfc.nasa.gov/geotiff/MY1DMM_CHLORA/
root=MY1DMM_CHLORA
min_year=2002
# TODO  should be current year, but 'date +%Y', doesn't work properly in this script on macOS
max_year=2016
# TODO would prefer to iterate over 'date +%m', doesn't work properly in this script on macOS
months="01 02 03 04 05 06 07 08 09 10 11 12"

mapbox_account=mriedijk
zoom=6


for y in `seq $min_year $max_year`
do
  for m in $months
  do
    file="MY1DMM_CHLORA_$y-$m.TIFF"
    echo ""
    echo "-----"
    echo "processing $file"

    if [ $wget_tiff -eq 1 ]
    then

      wgetCmd="wget -N $ftp_root$file"
      echo $wgetCmd

      if [ $preflight -eq 0 ]
      then
        wget -N $ftp_root$file
      fi
    fi

    cmd="./OceaneosImage.sh --input $file --format WEBP --debug 2 --zoom $zoom --mapbox_account $mapbox_account"
    echo $cmd

    if [ $preflight -eq 0 ]
    then
      ./OceaneosImage.sh --input $file --format WEBP --debug 2 --zoom $zoom --mapbox_account $mapbox_account
    fi

  done
done
