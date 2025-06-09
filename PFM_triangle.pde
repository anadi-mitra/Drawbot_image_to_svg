// This path finding module makes wavy at 60 degree

class PFM_triangle implements pfm {

  final int    squiggle_length = 400;      // How often to lift the pen
  final int    adjustbrightness = 15;        // How fast it moves from dark to light, over-draw
  final float  desired_brightness = 255;    // How long to process.  You can always stop early with "s" key
 
  int          tests = 150;                  // Reasonable values:  13 for development, 720 for final
  int          line_length = int(random(10, 60));           // Reasonable values:  3 through 100
 
  int          squiggle_count;
  int          darkest_x;
  int          darkest_y;
  float        darkest_value;
  float        darkest_neighbor = 255;

  public void pre_processing() {
     image_desaturate();
  }
  
  public void find_path() {
    find_squiggle();
    if (avg_imgage_brightness() > desired_brightness ) {
      state++;
    }
  }
  
  private void find_squiggle() {
    int x, y;
  
    find_darkest_area();
    x = darkest_x;
    y = darkest_y;
    squiggle_count++;
  
    find_darkest_neighbor(x, y);
    move_abs(darkest_x, darkest_y);
    pen_down();
    
    for (int s = 0; s < squiggle_length; s++) {
      find_darkest_neighbor(x, y);
      bresenham_lighten(x, y, darkest_x, darkest_y, adjustbrightness);
      move_abs(darkest_x, darkest_y);
      x = darkest_x;
      y = darkest_y;
    }
    pen_up();
  }
   
  private void find_darkest_area() {
    // Finds the darkest square area by down sampling the img into a much smaller area then finding
    // the darkest pixel within that.  It returns a random pixel within that darkest area.
    
    int area_size = 30;
    darkest_value = millis()%1000;
    int darkest_loc = 1;
    
    PImage img2;
    img2 = createImage(img.width / area_size, img.height / area_size, RGB);
    img2.copy(img, 0, 0, img.width, img.height, 0, 0, img2.width, img2.height);

    for (int loc=0; loc < img2.width * img2.height; loc++) {
      float r = brightness(img2.pixels[loc]);
      
      if (r < darkest_value) {
        darkest_value = r + random(1);
        darkest_loc = loc;
      }
    }
    darkest_x = darkest_loc % img2.width;
    darkest_y = (darkest_loc - darkest_x) / img2.width;
    darkest_x = darkest_x * area_size + int(random(area_size));
    darkest_y = darkest_y * area_size + int(random(area_size));
  }

  private void find_darkest_neighbor(int start_x, int start_y) {
    darkest_neighbor = millis()%500;
    float start_angle;
    float delta_angle;
    
    start_angle = 0;//degrees( ( sin(radians(start_x/9+46)) + cos(radians(start_y/26+26)) ));
    delta_angle = 60.0;
    
    for (int d=0; d<tests; d++) 
      bresenham_avg_brightness(start_x, start_y, line_length, (delta_angle * d) + start_angle);
    
  }
  
  float bresenham_avg_brightness(int x0, int y0, float distance, float degree) {
    int x1, y1;
    int sum_brightness = 0;
    int count_brightness = 0;
    ArrayList <intPoint> pnts;
    
    x1 = int(cos(radians(degree))*distance) + x0;
    y1 = int(sin(radians(degree))*distance) + y0;
    x0 = constrain(x0, 0, img.width-1);
    y0 = constrain(y0, 0, img.height-1);
    x1 = constrain(x1, 0, img.width-1);
    y1 = constrain(y1, 0, img.height-1);
    
    pnts = bresenham(x0, y0, x1, y1);
    for (intPoint p : pnts) {
      int loc = p.x + p.y*img.width;
      sum_brightness += brightness(img.pixels[loc]);
      count_brightness++;
      if (sum_brightness / count_brightness < darkest_neighbor) {
        darkest_x = p.x;
        darkest_y = p.y;
        darkest_neighbor = (float)sum_brightness / (float)count_brightness;
      }
    }
    return( sum_brightness / count_brightness );
  }
  
  public void post_processing() {
  }

  public void output_parameters() {
  }

}
