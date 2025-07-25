/*
 A class to describe one line segment

 Because of a bug in processing.org the MULTIPLY blendMode does not take into account the alpha of
 either source or destination.  If this gets corrected, tweaks to the stroke alpha might be more
 representative of a Copic marker.  Right now it over emphasizes the darkening when overlaps
 of the same pen occur.
*/

class botLine {
  boolean pen_down;
  boolean pen_continuation;
  float x1;
  float y1;
  float x2;
  float y2;  
  
  botLine(boolean pen_down_, float x1_, float y1_, float x2_, float y2_) {
    pen_down = pen_down_;
    pen_continuation = false;
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
   }

  void render_with_copic() {
    if (pen_down) {
      blendMode(MULTIPLY);
      line(x1, y1, x2, y2);
    }
  }
}
