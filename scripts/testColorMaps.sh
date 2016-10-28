# Blue to red
# ./OceaneosImage.sh --input MY1DMM_CHLORA_2002-07.TIFF --output_folder ../../output --zoom 6 --color_map noG --debug yarp

# Original http://www.kennethmoreland.com/color-advice/
./OceaneosImage.sh --input MY1DMM_CHLORA_2002-07.TIFF --output_folder ../../output --zoom 6 --color_map black-body-table-byte-0256.csv --debug yarp --format WEBP --mapbox_account mriedijk
./OceaneosImage.sh --input MY1DMM_CHLORA_2002-07.TIFF --output_folder ../../output --zoom 6 --color_map extended-black-body-table-byte-0256.csv --debug yarp --format WEBP --mapbox_account mriedijk
./OceaneosImage.sh --input MY1DMM_CHLORA_2002-07.TIFF --output_folder ../../output --zoom 6 --color_map kindlmann-table-byte-0256.csv --debug yarp --format WEBP --mapbox_account mriedijk

# Inverted maps from http://www.kennethmoreland.com/color-advice/
# ./OceaneosImage.sh --input MY1DMM_CHLORA_2002-07.TIFF --output_folder ../../output --zoom 6 --color_map black-body-table-byte-0256.csv --debug yarp
# ./OceaneosImage.sh --input MY1DMM_CHLORA_2002-07.TIFF --output_folder ../../output --zoom 6 --color_map extended-black-body-table-byte-0256.csv --debug yarp
# ./OceaneosImage.sh --input MY1DMM_CHLORA_2002-07.TIFF --output_folder ../../output --zoom 6 --color_map kindlmann-table-byte-0256.csv --debug yarp


./OceaneosImage.sh --input MY1DMM_CHLORA_2002-07.TIFF --output_folder ../../output --zoom 2 --color_map kindlmann-table-byte-0256.csv --debug yarp
