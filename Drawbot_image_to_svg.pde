import java.util.Map;
import processing.pdf.*;

// Every good program should have a shit pile of badly named globals.
Class cl = null;
pfm ocl;
int current_pfm = 0;
String[] pfms = { "PFM_spiral2", "PFM_squares", "PFM_original", "PFM_triangle", "PFM_original2","PFM_squiggle"}; 

int     state = 1;
int     display_line_count;
PImage  img_orginal;               // The original image
PImage  img_reference;             // After pre_processing, croped, scaled, boarder, etc.  This is what we will try to draw. 
PImage  img;                       // Used during drawing for current brightness levels.  Gets damaged during drawing.
float   gcode_offset_x;
float   gcode_offset_y;
float   screen_scale;
int     screen_rotate = 0;
float   old_x = 0;
float   old_y = 0;
int     mx = 0;
int     my = 0;
int     morgx = 0;
int     morgy = 0;
boolean is_pen_down;
String  path_selected = "";
String  file_selected = "";
String  basefile_selected = "";
int     startTime = 0;
boolean ctrl_down = false;

PrintWriter OUTPUT;
botDrawing d1;

float pen_distribution;

///////////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  size(1600, 900,P3D);
  frame.setLocation(200, 200);
  surface.setResizable(true);
  surface.setTitle("Drawbot_image_to_svg, version 1.0");
  colorMode(RGB);
  frameRate(999);
  randomSeed(3);
  d1 = new botDrawing();
  loadInClass(pfms[current_pfm]);
  String url=null;//"/home/anadi/Programs/pico/sketch/rawImages/done/peaky-blinders-haircut-tommy-shelby.jpg";
    // Check if a command-line argument was provided
  if (args != null && args.length > 0) {
    url = args[0];  // Take the first argument as the URL
    println("URL from command line: " + url);
  } else {
    println("\n\nNo command-line argument found. Exiting.\n\n");
    exit();  // Exit if no argument is provided
  }

  if (url != null && match(url.toLowerCase(), ".*\\.(png|svg|jpeg|jpg)$") != null) {
    path_selected = url;
    state++;
  } else {
    println("Invalid image: " + url);
    exit();
  }
  File imgFile = new File(path_selected);

  // Check if file exists
  if (!imgFile.exists() || !imgFile.isFile()) {
    println("Error: File does not exist or is not valid.");
    exit();
    return;
  }

  file_selected = imgFile.getName().replace(" ", "_");  // Extract filename from path
  String[] fileparts = split(file_selected, '.');
  basefile_selected = fileparts[0];
}

void draw() {
  if (state != 3) {
    background(255, 255, 255); 
  }
  scale(screen_scale);
  translate(mx, my);
  rotate(HALF_PI*screen_rotate);
  
  switch(state) {
  case 2:
    loop();
    setup_squiggles();
    startTime = millis();
    break;
  case 3: 
    if (display_line_count <= 1) {
      background(255);
    } 
    ocl.find_path();
    display_line_count = d1.line_count;
    break;
  case 4: 
    ocl.post_processing();
    pen_distribution = display_line_count;
    display_line_count = d1.line_count;
  
    state++;
    break;
  case 5: 
    d1.render_some(display_line_count);
    blendMode(MULTIPLY);  
    noLoop();
    break;
  default:
    break;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
void setup_squiggles() {
  d1.lines.clear();
  d1.line_count = 0;
  img = loadImage(path_selected, "jpeg");  // Load the image into the program  

  image_rotate();

  img_orginal = createImage(img.width, img.height, RGB);
  img_orginal.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);

  ocl.pre_processing();
  img.loadPixels();
  img_reference = createImage(img.width, img.height, RGB);
  img_reference.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);
  gcode_offset_x = (img.width / 2.0);  
  gcode_offset_y = img.height / 2.0;

  screen_scale = 1;
  ocl.output_parameters();

  state++;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void keyReleased() {
  if (keyCode == CONTROL) { ctrl_down = false; }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void keyPressed() {
  
  if (key == 'p') {
    current_pfm ++;
    if (current_pfm >= pfms.length) { current_pfm = 0; }
    loadInClass(pfms[current_pfm]); 
    state = 2;
  }
  
  else if (key >= '1' && key <= '6') {
    current_pfm =key-48-1;
    loadInClass(pfms[current_pfm]); 
    state = 2;
  }
  
  else if (key == ']') { screen_scale *= 1.05; }
  else if (key == '[') { screen_scale *= 1 / 1.05; }
  else if (key == 's') { if (state == 3) { state++; } }
  else if (key == 'i') {
    create_svg_file(display_line_count);
  }
  else if (key == '<') {
    int delta = -5000;
    display_line_count = int(display_line_count + delta);
    display_line_count = constrain(display_line_count, 0, d1.line_count);
    
  }
  else if (key == '>') {
    int delta = 5000;
    display_line_count = int(display_line_count + delta);
    display_line_count = constrain(display_line_count, 0, d1.line_count);
    
  }
  else if (key == ',') {
    int delta = -50;
    display_line_count = int(display_line_count + delta);
    display_line_count = constrain(display_line_count, 0, d1.line_count);
    
  }
  else if (key == '.') {
    int delta = 50;
    display_line_count = int(display_line_count + delta);
    display_line_count = constrain(display_line_count, 0, d1.line_count);
    
  }
  else if (key == 'r') { 
    screen_rotate ++;
    if (screen_rotate == 4) { screen_rotate = 0; }
    
    switch(screen_rotate) {
      case 0: 
        my -= img.height;
        break;
      case 1: 
        mx += img.height;
        break;
      case 2: 
        my += img.height;
        break;
      case 3: 
        mx -= img.height;
        break;
     }
  }
  
  pen_distribution = display_line_count; 
  //d1.distribute_pen_changes_according_to_percentages(display_line_count);
  redraw();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
public void loadInClass(String pfm_name){
  String className = this.getClass().getName() + "$" + pfm_name;
  try {
    cl = Class.forName(className);
  } catch (ClassNotFoundException e) { 
    println("\nError unknown PFM: " + className); 
  }
  
  ocl = null;
  if (cl != null) {
    try {
      // Get the constructor(s)
      java.lang.reflect.Constructor[] ctors = cl.getDeclaredConstructors();
      // Create an instance with the parent object as parameter (needed for inner classes)
      ocl = (pfm) ctors[0].newInstance(new Object[] { this });
    } catch (InstantiationException e) {
      println("Cannot create an instance of " + className);
    } catch (IllegalAccessException e) {
      println("Cannot access " + className + ": " + e.getMessage());
    } catch (Exception e) {
       // Lot of stuff can go wrong...
       e.printStackTrace();
    }
  }
  //println("\nloaded PFM: " + className); 
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void mousePressed() {
  morgx = mouseX - mx; 
  morgy = mouseY - my; 
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void mouseDragged() {
  mx = mouseX-morgx; 
  my = mouseY-morgy; 
  redraw();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
// This is the pfm interface, it contains the only methods the main code can call.
// As well as any variables that all pfm modules must have.
interface pfm {
  public void pre_processing();
  public void find_path();
  public void post_processing();
  public void output_parameters();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
