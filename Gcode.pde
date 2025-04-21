///////////////////////////////////////////////////////////////////////////////////////////////////////
// No, it's not a fancy dancy class like the snot nosed kids are doing these days.
// Now get the hell off my lawn.

///////////////////////////////////////////////////////////////////////////////////////////////////////
void pen_up() {
  is_pen_down = false;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void pen_down() {
  is_pen_down = true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void move_abs(int pen_number, float x, float y) {
  
  d1.addline(pen_number, is_pen_down, old_x, old_y, x, y);
  if (is_pen_down) {
    d1.render_last();
  }
  
  old_x = x;
  old_y = y;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Thanks to Vladimir Bochkov for helping me debug the SVG international decimal separators problem.
String svg_format (Float n) {
  final char regional_decimal_separator = ',';
  final char svg_decimal_seperator = '.';
  
  String s = nf(n, 0, svg_decimals);
  s = s.replace(regional_decimal_separator, svg_decimal_seperator);
  return s;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Thanks to John Cliff for getting the SVG output moving forward.
void create_svg_file (int line_count) {
  boolean drawing_polyline = false;
  
  // Inkscape versions before 0.91 used 90dpi, Today most software assumes 96dpi.
  float svgdpi = 3.6;
  String timestamp =  nf(day(), 2)+"." + nf(month(), 2)+"."+nf(year(), 4)+ "_" + 
                   nf(hour(), 2)+":" + nf(minute(), 2)+":" + nf(second(), 2);

  String gname = "/home/anadi/Programs/pico/sketch/images/" + basefile_selected + timestamp+  ".svg";
  OUTPUT = createWriter( gname);
  OUTPUT.println("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
  OUTPUT.println("<svg width=\"" + svg_format(img.width * gcode_scale) + "mm\" height=\"" + svg_format(img.height * gcode_scale) + "mm\" xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">");
  d1.set_pen_continuation_flags();
  
  // Loop over pens backwards to display dark lines last.
  // Then loop over all displayed lines.
  for (int p=pen_count-1; p>=0; p--) {    
    OUTPUT.println("<g id=\"" + copic_sets[current_copic_set][p] + "\">");
    for (int i=1; i<line_count; i++) { 
      if (d1.lines[i].pen_number == p) {

        // Do we add gcode_offsets needed by my bot, or zero based?
        //float gcode_scaled_x1 = d1.lines[i].x1 * gcode_scale * svgdpi + gcode_offset_x;
        //float gcode_scaled_y1 = d1.lines[i].y1 * gcode_scale * svgdpi + gcode_offset_y;
        //float gcode_scaled_x2 = d1.lines[i].x2 * gcode_scale * svgdpi + gcode_offset_x;
        //float gcode_scaled_y2 = d1.lines[i].y2 * gcode_scale * svgdpi + gcode_offset_y;
        
        float gcode_scaled_x1 = d1.lines[i].x1 * gcode_scale * svgdpi;
        float gcode_scaled_y1 = d1.lines[i].y1 * gcode_scale * svgdpi;
        float gcode_scaled_x2 = d1.lines[i].x2 * gcode_scale * svgdpi;
        float gcode_scaled_y2 = d1.lines[i].y2 * gcode_scale * svgdpi;

        if (d1.lines[i].pen_continuation == false && drawing_polyline) {
          OUTPUT.println("\" />");
          drawing_polyline = false;
        }

        if (d1.lines[i].pen_down) {
          if (d1.lines[i].pen_continuation) {
            String buf = svg_format(gcode_scaled_x2) + "," + svg_format(gcode_scaled_y2);
            OUTPUT.println(buf);
            drawing_polyline = true;
          } else {
            color c = copic.get_original_color(copic_sets[current_copic_set][p]);
            OUTPUT.println("<polyline fill=\"none\" stroke=\"#" + hex(c, 6) + "\" stroke-width=\"1.0\" stroke-opacity=\"1\" points=\"");
            String buf = svg_format(gcode_scaled_x1) + "," + svg_format(gcode_scaled_y1);
            OUTPUT.println(buf);
            drawing_polyline = true;
          }
        }
      }
    }
    if (drawing_polyline) {
      OUTPUT.println("\" />");
      drawing_polyline = false;
    }
    OUTPUT.println("</g>");
  }
  OUTPUT.println("</svg>");
  OUTPUT.flush();
  OUTPUT.close();
  println("SVG created:  " + gname);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
