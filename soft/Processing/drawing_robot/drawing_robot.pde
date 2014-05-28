//processing CODE

float sx, sy, ex, ey, hx, hy, hxo, hyo;
float armLength;
float a, b;
int mouseX_buf;
int mouseY_buf;
boolean mousePressed_buf;

// i due angoli della cinematica inversa
float theta, beta;
// i due angoli da mandare ad USB_WIREDino
int atheta, abeta;
int debug_atheta, debug_abeta, debug_pen=0;

int px=0, py=0;
PGraphics drawLayer;

import processing.serial.*;
Serial myPort;

public static final char HEADER = '|'; 
public static final char MOUSE = 'M';
public static final char MOUSEUP = 'U';
public static final char MOUSEDOWN = 'D';
public static final char DEBUG = 'N';
public static final char MEMORY_DATA = 'A';

boolean premouse = false;
boolean  correct_of_workspace = false;

PrintWriter outputFile = null;
int num_written_message = 0;

//import java.util.HashSet;
//HashSet points_set;

boolean sketchFullScreen() { // this code enables full screen mode
  return true;
}

void setup() {
  size(displayWidth, displayHeight, P2D); // size of the display window
  background(255, 224, 150); // R,G,B

  //sx = width/2; // width, height - of the display window. system variables
  //sy = height/2;
  sx =  width / 2;
  sy = height / 2;
  armLength = int(sqrt(sq(6.0 / 5.0 * height) + sq(6.0 / 5.0 * width))) / 5 / 1.6;
  a = armLength;
  b = armLength;

  drawLayer = createGraphics(width, height, P2D);

  try {
    String portName = Serial.list()[0]; 
    myPort = new Serial(this, portName, 115200);
    println(portName);
  } 
  catch(Exception e) {
    println("### USB NOT WIRED");
  }
}

//---------------------------------------------------------------------------------- draw
//---------------------------------------------------------------------------------- draw
//---------------------------------------------------------------------------------- draw

void draw() {
  background(255);
  mouseX_buf = mouseX;
  mouseY_buf = mouseY;
  mousePressed_buf = mousePressed;
  inverseKinematics(mouseX_buf-sx, mouseY_buf-sy );

drawLayer.beginDraw();
  drawArms();
  drawText();
  drawHelp();

  updateDrawLayer();

  image(drawLayer, 0, 0);

  px = mouseX_buf;
  py = mouseY_buf;
  if (mousePressed_buf) sendMessage(MOUSE, atheta, abeta);

  // detect mouse change state and send message
  if (mousePressed_buf && !premouse) {
    //println("----------------------------------------------UP");
    sendMessage(MOUSEUP, 0, 0);
  }
  if (!mousePressed_buf && premouse) {
    //println("----------------------------------------------DOWN");
    sendMessage(MOUSEDOWN, 0, 0);
  }
  premouse=mousePressed_buf;
}

void drawHelp() {
  fill(0);
  String s = "Press:\n"+
    "\t space : clear current draw\n"+
    "\n"+
    "\t 0    \t: both servos to zero\n"+
    "\t T-t  \t: increment-decrement servo theta\n"+
    "\t B-b \t: increment-decrement servo beta\n"+
    "\t N-n  \t: increment-decrement servo pen\n"+
    "\n"+
    "\t o \t: open file"+"design.txt" +"\n"+
    "\t c \t: close file\n"+
    "\t l \t: load and send all file content"+
    "\n"+
    "\t m \t: test PROGMEM avr memory";
  text(s, 10, 300);

  if (outputFile!=null) {
    fill(255, 0, 0);
    text("### RECORDING ###", 50, 50);
  }
}

void drawArms() {
  stroke(255, 0, 0, 100); // set line color (R,G,B,Alpha)
  fill(240, 0, 0, 200); // set fill color (R,G,B,Alpha)
  ellipse(sx, sy, 10, 10);
  ellipse(ex, ey, 8, 8);
  ellipse(hx, hy, 6, 6);
  stroke(0);
  line(sx, sy, ex, ey);
  line(ex, ey, hx, hy);
}

void drawText() {
  fill(0);
  text("theta = "+int(atheta), 10, 20);
  text("beta = "+int(abeta), 10, 35);
  fill(100);
  text("debug theta = "+int(debug_atheta), 10, 55);
  text("debug beta = "+int(debug_abeta), 10, 70);
  text("armLength = "+armLength, 10, 85); 
}

void updateDrawLayer() {
  // if mouse is out of arm
  boolean f1 = (mouseX_buf>=(hx-5)) && (mouseX_buf<=(hx+5)) && (mouseY_buf>=(hy-5)) && (mouseY_buf<=(hy+5));
  // if angles are in [0-180]
  boolean f2 = (atheta>=0) && (atheta<=180)   &&   (abeta>=0) && (abeta<=180);
  // limit position
  int margin = 10;
  boolean f3 = (hx >= margin) && (hx <= width - margin) && (hy >= margin) && (hy <= height - margin);

  if (f1 && f2 && f3) {
    correct_of_workspace = true;

    //drawLayer.beginDraw();
    if (mousePressed_buf) drawLayer.stroke(255, 0, 0);
    else drawLayer.noStroke();
    drawLayer.line(px, py, mouseX_buf, mouseY_buf);
    drawLayer.endDraw();
  } 
  else {
    correct_of_workspace = false;

    fill(100, 100);
    rect(0, 0, width, height);
  }
}

//---------------------------------------------------------------------------------- computations
//---------------------------------------------------------------------------------- computations
//---------------------------------------------------------------------------------- computations

void inverseKinematics(float x, float y) {
  /*
 take x and y in sx-sy centered coordinate
   and set global vars:
   - ex, ey : first joing
   - hx, hy : second joint
   - atheta, btheta
   */

  doInverseKinematicsTrigonometry(x, y);
  computeArms();
  getDataToSend();
}

void doInverseKinematicsTrigonometry(float x, float y) {
  // http://www.openprocessing.org/visuals/?visualID=553

  float D, E, B, C;

  float dx = x;
  float dy = y;
  float distance = sqrt(dx*dx+dy*dy);

  float c = min(distance, a + b);

  B = acos((b*b-a*a-c*c)/(-2*a*c));
  C = acos((c*c-a*a-b*b)/(-2*a*b));

  D = atan2(dy, dx);
  E = D + B + PI + C;

  // hei, trigonometria, che cosa vuoi dirmi?

  theta = E;
  beta = D+B;

  //  // http://www.alvarolopes.com/resources/USB_WIREDino-arm-inverse-kinematics.png
  //  float d, beta, sigma, mu, fi;
  //  y *= -1;
  //
  //  println("x " + x);
  //  println("y " + y);
  //  d = sqrt(x*x + y*y);
  //
  //  beta = acos((a*a + b*b - d*d)/(2*a*b));
  //  println("beta "+beta);
  //
  //  sigma = acos((a*a + d*d -b*b)/(2*d*a));
  //  println("sigma "+sigma);
  //
  //  mu = acos((d*d + y*y - x*x)/(2*d*y));
  //  println("mu "+mu);
  //
  //  fi = (PI/2) - mu - sigma;
  //  println("fi "+fi);
  //
  //  this.theta = fi;
  //  this.beta = beta;
}

void computeArms() {
  ex = cos(theta)*a + sx;
  ey = sin(theta)*a + sy;

  hx = cos(beta)*b + ex; // ? perchè funziona sta cosa?
  hy = sin(beta)*b + ey;
}

//---------------------------------------------------------------------------------- arduino
//---------------------------------------------------------------------------------- arduino
//---------------------------------------------------------------------------------- arduino

void serialEvent(Serial p) { 
  // handle incoming serial data 
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    print("ARDUINO ECHO ### ");
    println( inString );    // echo text string from arduino
  }
}

void sendMessage(char tag, int atheta, int abeta) {
  //println("send message "+atheta+" "+abeta);
  if (!correct_of_workspace) {
    println("OUT OF AVAIABLE WORKSPACE");
    return;
  }

  try {
    myPort.write(HEADER); 
    myPort.write(tag);
    myPort.write(180 - atheta); 
    myPort.write(180 - abeta);
  } catch(Exception e) {
    //println("###USB not wired");
  }

  if (outputFile != null) {
    num_written_message += 3;
    outputFile.print(",'"+tag +"',"+ int(atheta) + "," + int(abeta));
  }
}

void getDataToSend() {
  atheta = (int)processing2costantinoTHETA(this.theta);

  PVector v1 = new PVector(sx - ex, sy - ey);
  PVector v2 = new PVector(ex - hx, ey - hy);

  abeta = (int)(180 - degrees(PVector.angleBetween(v1, v2)));
}

//---------------------------------------------------------------------------------- utils
//---------------------------------------------------------------------------------- utils
//---------------------------------------------------------------------------------- utils

float processing2costantinoTHETA(float t) {
  return 180-(345-degrees(t) +45);
}

void keyPressed() {
  //println("keypressed "+key);

  if (key=='o' || key=='c')
    handleFile();

  if (key=='l')
    loadAndSend();

  if (key=='T' || key=='t' || key=='B' || key=='b' || key=='0' || key=='N' || key=='n')
    testAngles();

  if (key==' ')clear();
  
  if (key=='m')testMemory();
}

void clear() {
  drawLayer = createGraphics(width, height, P2D);
  if (outputFile!=null) {
    println("clear, close and open file again");
    outputFile.flush(); // Writes the remaining data to the file
    outputFile.close(); // Finishes the file
    outputFile = createWriter("design.txt");
  }
}

void handleFile() {
  if (key=='o' && outputFile==null) {
    println("open file"+ "design.txt" );
    outputFile = createWriter("design.txt");
    num_written_message = 0;
  }
  if (key=='c' && outputFile!=null) {
    outputFile.println('\n');
    outputFile.print(num_written_message);
    println("close file"+"design.txt");
    outputFile.flush(); // Writes the remaining data to the file
    outputFile.close(); // Finishes the file
    outputFile = null;
  }
}

void loadAndSend() {

  if (outputFile!=null) {
    outputFile.flush(); // Writes the remaining data to the file
    outputFile.close(); // Finishes the file
    outputFile = null;
  }

  try {
    BufferedReader reader = createReader("design.txt");
    String line=reader.readLine ();
    println(line.length());

    String cs[] = line.split(",");
    for(int i=1; i < cs.length; i+=3) {
      
      char tag = cs[i].toCharArray()[1];
      int x = Integer.parseInt( cs[i+1] );
      int y = Integer.parseInt( cs[i+2] );
      
      sendMessage(tag, x, y);

      // wait some milliseconds..
      try{Thread.sleep(20);}catch(Exception e){println(e);}
    }//endwhile
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

void testAngles() {
  if (key=='N') {
    debug_pen++;
    debug_pen = constrain(debug_pen, 0, 180);
    sendMessage(DEBUG, debug_pen, 0);
    return;
  }
  if (key=='n') {
    debug_pen--;
    debug_pen = constrain(debug_pen, 0, 180);
    sendMessage(DEBUG, debug_pen, 0);
    return;
  }

  if (key=='T') debug_atheta++;
  if (key=='t') debug_atheta--;
  if (key=='B') debug_abeta++;
  if (key=='b') debug_abeta--;
  if (key=='0') debug_abeta= debug_atheta = 0;
  debug_atheta = constrain(debug_atheta, 0, 180);
  debug_abeta = constrain(debug_abeta, 0, 180);
  sendMessage(MOUSE, debug_atheta, debug_abeta);
}

void testMemory() {
  println("test memory");
  sendMessage(MEMORY_DATA, debug_atheta, debug_abeta);
}

