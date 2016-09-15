
# Oceaneos Image Pipeline
#   Usage
#     ./OceaneosImage.sh INPUT_TIFF
#
#   Example
#     ./OceaneosImage.sh MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.TIFF

# Convenience variables
ZOOM=6

INPUT_TIFF=$1
echo "Running Oceaneos Image Pipeline"
echo $INPUT_TIFF

# Assume the date stamp is the third field of the file name
#   Example,
#       IFS='_' read -r -a array <<< "MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.TIFF"
#       echo "${array[2]}"
#     will create the substring
#       2016-07-01
IFS='_' read -r -a array <<< "$INPUT_TIFF"
INPUT_DATE="${array[2]}"
echo $INPUT_DATE

IFS='.' read -r -a fileName <<< "$INPUT_TIFF"
FILE_NAME_NO_EXT="${fileName[0]}"
echo $FILE_NAME_NO_EXT

# Several steps implies several file names in Pipeline
#   These are all the files that will be generated from the input
# VRT files, used for color tables
BLUEYELLOW_COLOR_TABLE=$INPUT_DATE.blue-yellow.colortable.vrt
BLUERED_COLOR_TABLE=$INPUT_DATE.blue-red.colortable.vrt
BLUERED_COLOR_TABLE_CHECK=check.$INPUT_DATE.blue-red.colortable.vrt

# Final VRT, ready to be cut up into layers for Mapbox.
FINAL_VRT=$FILE_NAME_NO_EXT.vrt

#TIFF files
BLUERED_TIFF=$FILE_NAME_NO_EXT.blue2red.TIFF

# Mbtile
MBTILES=$FILE_NAME_NO_EXT.mbtiles

# ----------------
# make sure to remove any existing folders or .mbtiles so we know we have a fresh file
rm -rf $FILE_NAME_NO_EXT
rm $MBTILES


#  This makes a file that has the look up table
#    with no modification it is the Blue to Yellow color ramp.
gdal_translate -of VRT $INPUT_TIFF $BLUEYELLOW_COLOR_TABLE

#  In order to make a Blue to Red color ramp, remove the green channel
gdalNoGreen.py $BLUEYELLOW_COLOR_TABLE $BLUERED_COLOR_TABLE

# Apply the blue to red color look up table
gdal_translate $BLUERED_COLOR_TABLE $BLUERED_TIFF

# Alternatively, check the red2blue color table actually took by inspecting a VRT
gdal_translate -of VRT $BLUERED_TIFF $BLUERED_COLOR_TABLE_CHECK

# Expand the data to four bands, rgba, and assign NODATA for transparency over land masses
gdal_translate -of vrt -expand rgba -a_nodata 0 $BLUERED_TIFF $FINAL_VRT

# Prepare temp.vrt for "slippy" map tiles, one step closer to Mapbox
#  Zoom level 0 (whole earth) to a reasonalbe zoom level of 6.
gdal2tilesp.py -z 0-$ZOOM $FINAL_VRT

# pack the cut tiles into an mbtile, https://github.com/mapbox/mbtiles-spec
mb-util $FILE_NAME_NO_EXT $MBTILES
