convert -size 300x30 xc:white -pointsize 10 -stroke black -fill black -draw 'text 2,20 "0.01"'  kindlmann-legend.png
convert kindlmann-legend.png -fill black -stroke black  -draw 'rectangle 2,10 3,0'  kindlmann-legend.png

convert kindlmann-legend.png -pointsize 10 -fill black -stroke black  -draw 'text 33,20 "0.03"'  kindlmann-legend.png
convert kindlmann-legend.png -fill black -stroke black  -draw 'rectangle 33,10 34,0'  kindlmann-legend.png

convert kindlmann-legend.png -pointsize 10 -fill black -stroke black  -draw 'text 68,20 "0.1"'  kindlmann-legend.png
convert kindlmann-legend.png -fill black -stroke black  -draw 'rectangle 68,10 69,0'  kindlmann-legend.png

convert kindlmann-legend.png -pointsize 10 -fill black -stroke black  -draw 'text 100,20 "0.3"'  kindlmann-legend.png
convert kindlmann-legend.png -fill black -stroke black  -draw 'rectangle 100,10 101,0'  kindlmann-legend.png

convert kindlmann-legend.png -pointsize 10 -fill black -stroke black  -draw 'text 135,20 "1.0"'  kindlmann-legend.png
convert kindlmann-legend.png -fill black -stroke black  -draw 'rectangle 135,10 136,0'  kindlmann-legend.png

convert kindlmann-legend.png -pointsize 10 -fill black -stroke black  -draw 'text 166,20 "3.0"'  kindlmann-legend.png
convert kindlmann-legend.png -fill black -stroke black  -draw 'rectangle 166,10 167,0'  kindlmann-legend.png

convert kindlmann-legend.png -pointsize 10 -fill black -stroke black  -draw 'text 201,20 "10.0"'  kindlmann-legend.png
convert kindlmann-legend.png -fill black -stroke black  -draw 'rectangle 201,10 202,0'  kindlmann-legend.png

convert kindlmann-legend.png -pointsize 10 -fill black -stroke black  -draw 'text 233,20 "30.0 (mg/m^3)"'  kindlmann-legend.png
convert kindlmann-legend.png -fill black -stroke black  -draw 'rectangle 233,10 234,0'  kindlmann-legend.png


convert -append kindlmann.png kindlmann-legend.png out.png

# 2	0.01
# 33	0.03
# 68	0.10
# 100	0.30
# 135	1.00
# 166	3.00
# 201	10.00
# 233	30.00
# 253	60.00
