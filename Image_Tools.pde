void image_desaturate() {
  img.filter(GRAY);
}

void image_posterize(int amount) {
  img.filter(POSTERIZE, amount);
}
  
void image_blur(int amount) {
  img.filter(BLUR, amount);
}

void image_rotate() {
  //image[y][x]                                     // assuming this is the original orientation
  //image[x][original_width - y]                    // rotated 90 degrees ccw
  //image[original_height - x][y]                   // 90 degrees cw
  //image[original_height - y][original_width - x]  // 180 degrees

  if (img.width > img.height) {
    PImage img2 = createImage(img.height, img.width, RGB);
    img.loadPixels();
    for (int x=1; x<img.width; x++) {
      for (int y=1; y<img.height; y++) {
        int loc1 = x + y*img.width;
        int loc2 = y + (img.width - x) * img2.width;
        img2.pixels[loc2] = img.pixels[loc1];
      }
    }
    img = img2;
    updatePixels();
  } else {
  }
}

void lighten_one_pixel(int adjustbrightness, int x, int y) {
  int loc = (y)*img.width + x;
  float r = brightness (img.pixels[loc]);
  //r += adjustbrightness;
  r += adjustbrightness + random(0, 0.01);
  r = constrain(r,0,255);
  color c = color(r);
  img.pixels[loc] = c;
}

float avg_imgage_brightness() {
  float b = 0.0;

  for (int p=0; p < img.width * img.height; p++) {
    b += brightness(img.pixels[p]);
  }
  
  return(b / (img.width * img.height));
}
