# Drawbot_image_to_gcode_v2
<img src="pics/github1.png" height="411" alt="Drawbot_image_to_gcode_v2 example output"/>

This code is used to generate gcode for drawbots, polargraphs or other vertical drawing machines. \
It takes an original image, manipulates it and generates a drawing path that kinda sorta looks like the original image. \
This code was specifically written to work with multiple Copic markers. \
The code was intended to be heavily modified to generate different and unique drawing styles.

If your clipboard contains a URL to an image, the code will download it.  This makes finding usable images easy and straight forword.
If your clipboard contains a URL to a web site, the code will crash and burn in a spectacular fashion.

## Key Bindings:
| Key | Description |
| ------------- |:-------------|
| p | Load next "Path Finding Module" (PFM) |
| r | Rotate drawing |
| [ | Zoom in |
| ] | Zoom out |
| \ | Reset drawing zoom, offset and rotation |
| O | Display original image (capital letter) |
| o | Display image to be drawn after pre-processing (lower case letter) |
| l | Display image after the path finding module has manipulated it |
| d | Display drawing with all pens |
| S | Stop path finding prematurely |
| Esc | Exit running program |
| < | Decrease the total number of lines drawn |
| > | Increase the total number of lines drawn |
| i | export it as svg |
| G | Toggle grid |
| t | Redistribute percentage of lines drawn by each pen evenly |
| { | Change Copic marker sets, increment |
| } | Change Copic marker sets, decrement |


Examples of drawings made with this software:  http://dullbits.com/drawbot/gallery
