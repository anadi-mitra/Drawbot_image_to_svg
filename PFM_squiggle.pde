class PFM_squiggle implements pfm {

  public void pre_processing() {
    image_desaturate();
  }
  
  public void find_path() {
    pen_up();
  
    float density = random(260,285); // Controls how many horizontal lines are drawn (e.g., 50 = sparse, 200 = dense)
    float cutoff=200+random(0,50);
    float spacing = map(density, 10, 300, 20, 1); // More density → smaller spacing
    float amp = 3.0+density/100; // Amplitude of brightness modulation (wavy effect)
  
    for (float y = 0; y < img.height; y += spacing) {
      boolean drawing = false;
      for (int x = 0; x < img.width; x++) {
        color c = img.get(x, int(y));
        float b = brightness(c);
        
        float yOffset = map(b, 0, 255, -amp, amp);
        float yDraw = y + yOffset;
  
        if (b < cutoff) { // Skip white background
          if (!drawing) {
            move_abs(x, yDraw);
            pen_down();
            drawing = true;
          } else {
            move_abs(x, yDraw);
          }
        } else {
          if (drawing) {
            pen_up();
            drawing = false;
          }
        }
      }
      pen_up(); // End of row
    }
  
    pen_up();
    state++;
  }

  public void post_processing() {
  }

  public void output_parameters() {
  }
}
