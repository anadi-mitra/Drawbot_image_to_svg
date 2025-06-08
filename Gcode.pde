///////////////////////////////////////////////////////////////////////////////////////////////////////
void pen_up() {
  is_pen_down = false;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void pen_down() {
  is_pen_down = true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void move_abs(float x, float y) {
  
  d1.addline(is_pen_down, old_x, old_y, x, y);
  if (is_pen_down) 
    d1.render_last();
  
  
  old_x = x;
  old_y = y;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Thanks to Vladimir Bochkov for helping me debug the SVG international decimal separators problem.
String svg_format (Float n) {
  final char regional_decimal_separator = ',';
  final char svg_decimal_seperator = '.';
  
  String s = nf(n, 0, 1);
  s = s.replace(regional_decimal_separator, svg_decimal_seperator);
  return s;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Thanks to John Cliff for getting the SVG output moving forward.
void create_svg_file (int line_count) {
  boolean drawing_polyline = false;
  
  // Inkscape versions before 0.91 used 90dpi, Today most software assumes 96dpi.
  float svgdpi = 1.0;//3.6;
  String timestamp =  nf(day(), 2)+"." + nf(month(), 2)+"."+nf(year(), 4)+ "_" + 
                   nf(hour(), 2)+":" + nf(minute(), 2)+":" + nf(second(), 2);

  String gname = "/home/anadi/Programs/pico/sketch/svg/" + basefile_selected + timestamp+  ".svg";
  OUTPUT = createWriter( gname);
  OUTPUT.println("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
  OUTPUT.println("<svg width=\"" + svg_format((float)img.width) + "px\" height=\"" + svg_format((float)img.height) + "px\" xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">");
  d1.set_pen_continuation_flags();
  
  // Loop over pens backwards to display dark lines last.
  // Then loop over all displayed lines.
  OUTPUT.println("<g id=\"" + "100" + "\">");
  for (int i=1; i<line_count; i++) { 
      botLine line= d1.lines.get(i);
      float gcode_scaled_x1 = line.x1;
      float gcode_scaled_y1 = line.y1;
      float gcode_scaled_x2 = line.x2;
      float gcode_scaled_y2 = line.y2;

      if (line.pen_continuation == false && drawing_polyline) {
        OUTPUT.println("\" />");
        drawing_polyline = false;
      }

      if (line.pen_down) {
        if (line.pen_continuation) {
          String buf = svg_format(gcode_scaled_x2) + "," + svg_format(gcode_scaled_y2);
          OUTPUT.println(buf);
          drawing_polyline = true;
        } 
        else {
          color c = color(#312b2b);
          OUTPUT.println("<polyline fill=\"none\" stroke=\"#" + hex(c, 6) + "\" stroke-width=\"0.7\" stroke-opacity=\"0.9\" points=\"");
          String buf = svg_format(gcode_scaled_x1) + "," + svg_format(gcode_scaled_y1);
          OUTPUT.println(buf);
          drawing_polyline = true;
        }
      }
  }
  if (drawing_polyline) {
    OUTPUT.println("\" />");
    drawing_polyline = false;
  }
  OUTPUT.println("</g>");
  OUTPUT.println("</svg>");
  OUTPUT.flush();
  OUTPUT.close();
  println("SVG created:  " + gname);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
