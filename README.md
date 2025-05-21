# Drawbot_image_to_gcode_v2
<img src="pics/github1.png" height="411" alt="Drawbot_image_to_gcode_v2 example output"/>

* This code is used to generate gcode for drawbots, polargraphs or other vertical drawing machines. \
* It takes an original image, manipulates it and generates a drawing path that kinda sorta looks like the original image. \
* The code was intended to be heavily modified to generate different and unique drawing styles.
* Apart from the original PFM modules I added another two modules.
* I also updated the original modules to increase the amount of lines (the total length would be same) to ease postprocessing of the `SVG` file.
* I also remove the multiple pen feature since I only draw with since color. 

## Key Bindings:
| Key | Description                                         |
|-----|:----------------------------------------------------|
| p   | Load next "Path Finding Module" (PFM)               |
| r   | Rotate drawing                                      |
| [   | Zoom in                                             |
| ]   | Zoom out                                            |
| s   | Stop path finding prematurely                       |
| <   | Decrease the total number of lines drawn with 20000 |
| >   | Increase the total number of lines drawn with 20000 |
| ,   | Decrease the total number of lines drawn with 1000  |
| .   | Increase the total number of lines drawn with 1000  |
| i   | export it as svg                                    |


Examples of drawings made with this software:  http://dullbits.com/drawbot/gallery

## NOTE:

The SVG output location has been hardcoded to meet specific requirements.  
If you wish to change the output path, modify the following line in `Gcode.pde`:

```java
String gname = "/home/anadi/Programs/pico/sketch/svg/" + basefile_selected + timestamp + ".svg";
