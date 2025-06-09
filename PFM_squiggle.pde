class PFM_squiggle implements pfm {
  public void pre_processing() {
    image_desaturate();
    image_blur((int)random(2));
  }
  public void find_path() {
    color c;
    float b;
    float dist = random(2, 6);            // Distance between scanlines
    float step = 0.3;                     // Step size horizontally
    float density = 220;       // Frequency of squiggle
    float ampScale = dist * 0.7;         // Amplitude of squiggle
    color mask = computeBorderAverage(img);

    for (float y = 0; y < img.height; y += dist) {
      pen_up();
      move_abs(0, y);
      for (float x = 0; x < img.width; x += step) {
        c = img.get(int(x), int(y));
        b = brightness(c);
        b = map(b, 0, 255, ampScale, 0);
        float offset = sin(radians(x * density)) * b;
        // Mask check
        if (brightness(mask) <= brightness(c)) {
          pen_up();
        } else {
          pen_down();
        }

        move_abs(x, y + offset);
      }
      pen_up();
    }

    state++;
  }


  //computes the average color of the image border
  color computeBorderAverage(PImage img) {
    int step = 10+(int)random(0, 5); // Sample every N pixels
    int count = 0;
    float r = 0, g = 0, b = 0;

    for (int x = 0; x < img.width; x += step) {
      color c1 = img.get(x, 0);
      color c2 = img.get(x, img.height - 1);
      r += red(c1) + red(c2);
      g += green(c1) + green(c2);
      b += blue(c1) + blue(c2);
      count += 2;
    }

    for (int y = 0; y < img.height; y += step) {
      color c1 = img.get(0, y);
      color c2 = img.get(img.width - 1, y);
      r += red(c1) + red(c2);
      g += green(c1) + green(c2);
      b += blue(c1) + blue(c2);
      count += 2;
    }

    return color(r / count, g / count, b / count);
  }

  public void post_processing() {
  }

  public void output_parameters() {
  }
}
