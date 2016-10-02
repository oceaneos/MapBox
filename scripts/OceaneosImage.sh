# Copyright 2016 ePi Rational, Inc.  All rights reserved.
# Copyright 2016 Oceaneos Environmental Solutions, Inc.  All rights reserved.
# Oceaneos Image Pipeline
#   Example Usage
#     ./OceaneosImage.sh --input MY1DMM_CHLORA_2002-07.TIFF --output_folder ../../output --zoom 6  --format WEBP --mapbox_account oceaneos
#
#  --format be can either of these UPPER CASE choices
#     PNG
#     WEBP
#
#  Debug - You can skip the Mapbox.com upload by omitting --mapbox_account
#  Debug - You can skip the tile cutting by omitting --format




# command line options
while [[ "$#" > 1 ]]; do case $1 in
    --input) input_tiff="$2";;
    --output_folder) output_folder="$2";;
    --color_map) color_map="$2";;
    --debug) debug="$2";;
    --zoom) zoom="$2";;
    --mapbox_account) mapbox_account="$2";;
    --format) format="$2";;
    *) break;;
  esac; shift; shift
done


# Image output parameters
#  always user lower case 'png', regardless if --format is 'PNG' or 'WEBP'  (--format is case sensitive)
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

IFS='-' read -r -a colorMapArray <<< "$color_map"
color_map_name="${colorMapArray[0]}"


# Several steps implies several file names in Pipeline
#   These are all the files that will be generated from the input
# VRT files, used for color tables
current_color_table=$output_folder/$input_date.current.colortable.vrt
new_color_table=$output_folder/$input_date.new.colortable.vrt
new_color_table_CHECK=$output_folder/check.$input_date.new.colortable.vrt

# Final VRT, ready to be cut up into layers for Mapbox.
final_vrt=$output_folder/$file_name_no_ext.vrt
final_tiles_folder=$output_folder/$file_name_no_ext

#TIFF files
new_tiff=$output_folder/$color_map_name.$file_name_no_ext.tif

# Mbtile
mbtiles=$output_folder/$file_name_no_ext.mbtiles

# ----------------
# make sure to remove any existing folders or .mbtiles so we know we have a fresh file
rm -rf $file_name_no_ext
rm $mbtiles

# If $debug is set to any value, then execute this block
if [ ! -z "$debug" ]
  then
  echo "parameters"
  echo "  debug =" $debug
  echo "  color_map =" $color_map
  echo "  format =" $format
  echo "  input_tiff =" $input_tiff
  echo "  zoom =" $zoom
  echo "  mapbox_account =" $mapbox_account
  echo ""
  echo "Calculated values"
  echo "  color_map_name =" $color_map_name
  echo "  file_name_no_ext =" $file_name_no_ext
  echo "  input_date =" $input_date
  echo "  current_color_table =" $current_color_table
  echo "  new_color_table =" $new_color_table
  echo "  new_color_table_CHECK =" $new_color_table_CHECK
  echo "  new_tiff =" $new_tiff
  echo "  final_vrt =" $final_vrt
  echo "  final_tiles_folder =" $final_tiles_folder
  echo "  mbtiles =" $mbtiles
  echo ""
fi

#  This makes a file that has the look up table
#    with no modification it is the current color ramp.
gdal_translate -of VRT $input_tiff $current_color_table

if [ $color_map == "noG" ]
  then
  #  In order to make a Blue to Red color ramp, remove the green channel
  gdalcolormapper.py -noG -i $current_color_table -o $new_color_table
  else
    echo $color_map
  gdalcolormapper.py -i $current_color_table -o $new_color_table -csv $color_map
fi

# Apply the new color look up table
gdal_translate $new_color_table $new_tiff

# Alternatively, check the new color table actually took by inspecting a VRT
gdal_translate -of VRT $new_tiff $new_color_table_CHECK

# Expand the data to four bands, rgba, and assign NODATA for transparency over land masses
gdal_translate -of vrt -expand rgba -a_nodata 0 $new_tiff $final_vrt

# Prepare temp.vrt for "slippy" map tiles, one step closer to Mapbox
#  Zoom level 0 (whole earth) to a reasonalbe zoom level of 6.
# if $mapbox_account is NOT null, then upload to Mapbox.com/Studio
if [ ! -z "$format" ]
  then
    gdal2tilesp.py -z 0-$zoom -f $format $final_vrt $final_tiles_folder
    if [ $zoom -gt 2 ]
    then
      echo "Due to an (unexplained) issue with the tile cutter, we need to rerun the tile cutter at lower zooms "
      #  -e 'resumes' the the tilecutter and
      gdal2tilesp.py -z 5 -w all -e -f $format $final_vrt $final_tiles_folder
      gdal2tilesp.py -z 4 -w all -e -f $format $final_vrt $final_tiles_folder
      gdal2tilesp.py -z 3 -w all -e -f $format $final_vrt $final_tiles_folder
      gdal2tilesp.py -z 2 -w all -e -f $format $final_vrt $final_tiles_folder
      gdal2tilesp.py -z 1 -w all -e -f $format $final_vrt $final_tiles_folder
      gdal2tilesp.py -z 0 -w all -e -f $format $final_vrt $final_tiles_folder
    fi

    # Update the metadata for attribution
    # attribution for NASA NEO
    json -I -f $final_tiles_folder/metadata.json -e 'this.name="'$file_name_no_ext'"'
    json -I -f $final_tiles_folder/metadata.json -e 'this.description="'$input_tiff' + '$color_map'"'
    json -I -f $final_tiles_folder/metadata.json -e 'this.attribution="<a href=\"http://neo.sci.gsfc.nasa.gov\" target=\"_blank\">© NASA NEO</a>"'

    # pack the cut tiles into an mbtile, https://github.com/mapbox/mbtiles-spec
    # creates a file called
    #    $file_name_no_ext.mbtiles
    echo "mb-util --image_format=$format_lower $final_tiles_folder $mbtiles"
    mb-util --image_format=$format_lower $final_tiles_folder $mbtiles
fi


#  Upload to Mapbox
# Be sure to set the environment variable
# export MAPBOX_SUPER_TOKEN=<token from mapbox>

# if $mapbox_account is NOT null, then upload to Mapbox.com/Studio
if [ ! -z "$mapbox_account" ]
  then
    echo "mapbox --access-token=\$MAPBOX_SUPER_TOKEN upload $file_name_no_ext.mbtiles $mapbox_account.$file_name_no_ext"
    mapbox --access-token=$MAPBOX_SUPER_TOKEN upload $file_name_no_ext.mbtiles $mapbox_account.$file_name_no_ext
fi


###  Cleanup by removing old files
# If $debug is null, then remove extra files.  $debug true keeps files around
if [ -z "$debug" ]
  then
    echo "deleting unused files"
    rm $current_color_table
    rm $new_color_table
    rm $new_color_table_CHECK
    rm $new_tiff
    rm $final_vrt
    rm -rf $final_tiles_folder
fi
