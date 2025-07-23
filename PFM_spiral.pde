class PFM_spiral implements pfm {
  public void pre_processing() {
    image_desaturate();
    image_blur((int)random(2));
  }
  
  public void find_path() {
    color c;                               // Sampled color
    float b;                                   // Sampled brightness
    float dist = line_length/10;//random(2, 5);               // Distance between rings
    float radius = 1;                      // Current radius
    float aradius;                         // Radius with brighness applied up
    float bradius;                         // Radius with brighness applied down
    float alpha;                               // Initial rotation
    float density = random(50, 100);          // Density
    float ampScale = 0.7*dist;            // Controls the amplitude
    float x, y, xa, ya, xb, yb;                // Current X and Y + jittered X and Y 
    float k;                                   // Current radius
    float endRadius;                           // Largest value the spiral needs to cover the image
    //color mask = computeBorderAverage(img);

    k = density/radius;
    alpha = k;
    radius += dist/(360/k);
    endRadius = sqrt(pow((img.width/2), 2)+pow((img.height/2), 2));
    pen_up();
    x =  radius*cos(radians(alpha))+img.width/2;
    y = -radius*sin(radians(alpha))+img.height/2;
    move_abs(x, y);
    xa = 0;
    xb = 0;
    ya = 0;
    yb = 0;

    // Have we reached the far corner of the image?
    while (radius < endRadius) {
      k = (density/2)/radius;
      alpha += k;
      radius += dist/(360/k);
      x =  radius*cos(radians(alpha))+img.width/2;
      y = -radius*sin(radians(alpha))+img.height/2;

      // Are we within the the image?
      // If so check if the shape is open. If not, open it
      if ((x>=0) && (x<img.width) && (y>0) && (y<img.height)) {

        // Get the color and brightness of the sampled pixel
        c = img.get (int(x), int(y));
        b = brightness(c);
        b = map (b, 0, 255, dist*ampScale, 0);

        // Move up according to sampled brightness
        aradius = radius+(b/dist);
        xa =  aradius*cos(radians(alpha))+img.width/2;
        ya = -aradius*sin(radians(alpha))+img.height/2;

        // Move down according to sampled brightness
        k = (density/2)/radius;
        alpha += k;
        radius += dist/(360/k);
        bradius = radius-(b/dist);
        xb =  bradius*cos(radians(alpha))+img.width/2;
        yb = -bradius*sin(radians(alpha))+img.height/2;

        // If the sampled color is the mask color do not write to the shape
        if (/*brightness(mask)*/global_cutoff <= brightness(c)) {
          pen_up();
        } else {
          pen_down();
        }
      } else {
        // We are outside of the image
        pen_up();
      }

      move_abs(xa, ya);
      move_abs(xb, yb);
    }

    pen_up();
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
