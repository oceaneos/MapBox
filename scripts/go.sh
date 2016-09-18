#!/bin/bash

# go.sh
# Fetches GeoTiffs from NASA NEO
# Processes them using the Oceaneos Imaging Pipeline

#    wget -N ftp://neoftp.sci.gsfc.nasa.gov/geotiff/MY1DMM_CHLORA/2016-7.TIFF
#    ./OceaneosImage.sh --input --debug 2 --zoom 1 --mapbox_account roblabs
#    wget -N ftp://neoftp.sci.gsfc.nasa.gov/geotiff/MY1DMM_CHLORA/2016-8.TIFF
#    ./OceaneosImage.sh --input --debug 2 --zoom 1 --mapbox_account roblabs
#    wget -N ftp://neoftp.sci.gsfc.nasa.gov/geotiff/MY1DMM_CHLORA/2016-9.TIFF
#    ./OceaneosImage.sh --input --debug 2 --zoom 1 --mapbox_account roblabs


ftp_root=ftp://neoftp.sci.gsfc.nasa.gov/geotiff/MY1DMM_CHLORA/
root=MY1DMM_CHLORA
min_year=2002
max_year=2017  # TODO should be current year
month=12


for y in `seq $min_year $max_year`
do
  for m in `seq 1 $month`
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
