import java.util.ArrayList;


    ///////////////////////////////////////////////////////////////////////////////////////////////////////
// A class to describe all the line segments
    class botDrawing {
        private int line_count = 0;
        ArrayList<botLine> lines = new ArrayList<botLine>();


        void render_last () {
            lines.get(lines.size()-1).render_with_copic();
        }


        void render_some (int line_count) {
            for (int i=1; i<line_count; i++) {
                lines.get(i).render_with_copic();
            }
        }

        void set_pen_continuation_flags () {
            float prev_x = 123456.0;
            float prev_y = 654321.0;
            boolean prev_pen_down = false;
            //int prev_pen_number = 123456;

            for (int i=1; i<line_count; i++) {
              botLine line= lines.get(i);
                if (prev_x != line.x1 || prev_y != line.y1 || prev_pen_down != line.pen_down) {
                    line.pen_continuation = false;
                } else {
                    line.pen_continuation = true;
                }

                prev_x = line.x2;
                prev_y = line.y2;
                prev_pen_down = line.pen_down;
                //prev_pen_number = lines[i].pen_number;
                lines.add(line);
            }
        }

        void addline(boolean pen_down_, float x1_, float y1_, float x2_, float y2_) {
            lines.add(new botLine(pen_down_, x1_, y1_, x2_, y2_));
            line_count++;
        }

        public int get_line_count() {
            return line_count;
        }
    }
