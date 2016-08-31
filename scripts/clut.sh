
### gdal_translate way to do it
gdal_translate -of VRT MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.TIFF clut.vrt
# edit the lut to make blue2red
# cp clut.vrt clut.blue2red.vrt
gdal_translate clut.blue2red.vrt MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.clut.blue2red.TIFF


# check the red2blue color table actually took by inspecting the VRT
gdal_translate -of VRT MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.clut.blue2red.TIFF clut.blue2red.check.vrt
gdal_translate -of vrt -expand rgba MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.clut.blue2red.TIFF temp.vrt
rm -rf temp/
gdal2tilesp.py -z 0-6 temp.vrt
mb-util temp red2blue-clut-vert.mbtiles
