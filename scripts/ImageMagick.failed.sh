#Image Magick way to do it.
convert -channel rgba -alpha set -size 1x1 xc:black -size 1x255 gradient:red-blue -rotate 90 +append gradient_levels.png
convert -channel rgba -alpha set MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.TIFF  gradient_levels.png  -clut  color_gray_levels.tif
#
gdal_translate -of vrt -expand rgba MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.TIFF temp.vrt
gdal2tilesp.py -z 0-2 temp.vrt
mb-util temp blue-red-image-magick.mbtiles

convert gray_levels.png -unique-colors -scale 1000 swatch.png
