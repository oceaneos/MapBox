# Copyright 2016 ePi Rational, Inc.  All rights reserved.
# Copyright 2016 Oceaneos Environmental Solutions, Inc.  All rights reserved.
# Oceaneos Image Pipeline
#   Usage
#     ./OceaneosImage.sh input_tiff --debug 2 --format PNG --zoom 1 --mapbox_account roblabs
#
#  --format be can either of these UPPER CASE choices
#     PNG
#     WEBP

#   Example
#     ./OceaneosImage.sh MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.TIFF --format PNG --zoom 1 --mapbox_account roblabs

# command line options
while [[ "$#" > 1 ]]; do case $1 in
    --input) input_tiff="$2";;
    --debug) debug="$2";;
    --zoom) zoom="$2";;
    --mapbox_account) mapbox_account="$2";;
    --format) format="$2";;
    *) break;;
  esac; shift; shift
done


# Image output parameters
format_lower=png


# Assume the date stamp is the third field of the file name
#   Example,
#       IFS='_' read -r -a array <<< "MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.TIFF"
#       echo "${array[2]}"
#     will create the substring
#       2016-07-01
IFS='.' read -r -a fileName <<< "$input_tiff"
file_name_no_ext="${fileName[0]}"

IFS='_' read -r -a array <<< "$file_name_no_ext"
input_date="${array[2]}"


# Several steps implies several file names in Pipeline
#   These are all the files that will be generated from the input
# VRT files, used for color tables
blue_yellow_color_table=$input_date.blue-yellow.colortable.vrt
blue_red_color_table=$input_date.blue-red.colortable.vrt
blue_red_color_table_CHECK=check.$input_date.blue-red.colortable.vrt

# Final VRT, ready to be cut up into layers for Mapbox.
final_vrt=$file_name_no_ext.vrt

#TIFF files
blue_red_tiff=blue2red.$file_name_no_ext.tif

# Mbtile
mbtiles=$file_name_no_ext.mbtiles

# ----------------
# make sure to remove any existing folders or .mbtiles so we know we have a fresh file
rm -rf $file_name_no_ext
rm $mbtiles

if [ $debug -gt 1 ]
then
  echo "parameters"
  echo "  debug =" $debug
  echo "  format =" $format
  echo "  input_tiff =" $input_tiff
  echo "  zoom =" $zoom
  echo "  mapbox_account =" $mapbox_account
  echo ""
  echo "Calculated values"
  echo "  file_name_no_ext =" $file_name_no_ext
  echo "  input_date =" $input_date
  echo "  blue_yellow_color_table =" $blue_yellow_color_table
  echo "  blue_red_color_table =" $blue_red_color_table
  echo "  blue_red_color_table_CHECK =" $blue_red_color_table_CHECK
  echo "  blue_red_tiff =" $blue_red_tiff
  echo "  final_vrt =" $final_vrt
  echo "  mbtiles =" $mbtiles
  echo ""
fi

#  This makes a file that has the look up table
#    with no modification it is the Blue to Yellow color ramp.
gdal_translate -of VRT $input_tiff $blue_yellow_color_table

#  In order to make a Blue to Red color ramp, remove the green channel
gdalNoGreen.py $blue_yellow_color_table $blue_red_color_table

# Apply the blue to red color look up table
gdal_translate $blue_red_color_table $blue_red_tiff

# Alternatively, check the red2blue color table actually took by inspecting a VRT
gdal_translate -of VRT $blue_red_tiff $blue_red_color_table_CHECK

# Expand the data to four bands, rgba, and assign NODATA for transparency over land masses
gdal_translate -of vrt -expand rgba -a_nodata 0 $blue_red_tiff $final_vrt

# Prepare temp.vrt for "slippy" map tiles, one step closer to Mapbox
#  Zoom level 0 (whole earth) to a reasonalbe zoom level of 6.
gdal2tilesp.py -z 0-$zoom -f $format $final_vrt
if [ $zoom -gt 2 ]
then
  echo "Due to an (unexplained) issue with the tile cutter, we need to rerun the tile cutter at lower zooms "
  #  -e 'resumes' the the tilecutter and 
  gdal2tilesp.py -z 5 -w all -e -f $format $final_vrt
  gdal2tilesp.py -z 4 -w all -e -f $format $final_vrt
  gdal2tilesp.py -z 3 -w all -e -f $format $final_vrt
  gdal2tilesp.py -z 2 -w all -e -f $format $final_vrt
  gdal2tilesp.py -z 1 -w all -e -f $format $final_vrt
  gdal2tilesp.py -z 0 -w all -e -f $format $final_vrt
fi

# Update the metadata for attribution
# attribution for NASA NEO
json -I -f $file_name_no_ext/metadata.json -e 'this.name="'$file_name_no_ext'"'
json -I -f $file_name_no_ext/metadata.json -e 'this.description="'$file_name_no_ext'"'
json -I -f $file_name_no_ext/metadata.json -e 'this.attribution="<a href=\"http://neo.sci.gsfc.nasa.gov\" target=\"_blank\">© NASA NEO</a>"'


# pack the cut tiles into an mbtile, https://github.com/mapbox/mbtiles-spec
# creates a file called
#    $file_name_no_ext.mbtiles
mb-util --image_format=$format_lower $file_name_no_ext $mbtiles


#  Upload to Mapbox
# Be sure to set the environment variable
# export MAPBOX_SUPER_TOKEN=<token from mapbox>
echo "mapbox --access-token=\$MAPBOX_SUPER_TOKEN upload $file_name_no_ext.mbtiles $mapbox_account.$file_name_no_ext"
mapbox --access-token=$MAPBOX_SUPER_TOKEN upload $file_name_no_ext.mbtiles $mapbox_account.$file_name_no_ext
