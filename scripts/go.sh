for f in MY1DMM_CHLORA*.TIFF; do
  echo "------"

  cmd="./OceaneosImage.sh --input $f --debug 2 --zoom 1 --mapbox_account roblabs"
  echo $cmd
  exec $cmd

  echo ""
done
