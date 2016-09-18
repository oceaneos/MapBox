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


ftp_root=ftp://neoftp.sci.gsfc.nasa.gov/geotiff/MY1DMM_CHLORA/
root=MY1DMM_CHLORA
min_year=2002
# TODO  should be current year, but 'date +%Y', doesn't work properly in this script on macOS
max_year=2016
# TODO would prefer to iterate over 'date +%m', doesn't work properly in this script on macOS
months="01 02 03 04 05 06 07 08 09 10 11 12"


for y in `seq $min_year $max_year`
do
  for m in $months
  do
      wgetCmd="wget -N $ftp_root$root_$y-$m.TIFF"
      echo $wgetCmd
      cmd="./OceaneosImage.sh --input $f --debug 2 --zoom 1 --mapbox_account roblabs"
      echo $cmd
  done
done

#
# for f in MY1DMM_CHLORA*.TIFF; do
#   echo "------"
#
#   cmd="./OceaneosImage.sh --input $f --debug 2 --zoom 1 --mapbox_account roblabs"
#   echo $cmd
#   # exec $cmd
#
#   echo ""
# done
