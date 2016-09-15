for f in MY1DMM_CHLORA*.TIFF; do
  echo "------"

  echo "./OceaneosImage.sh $f"

  # Actually run it!!
  ./OceaneosImage.sh $f

  echo ""
done
