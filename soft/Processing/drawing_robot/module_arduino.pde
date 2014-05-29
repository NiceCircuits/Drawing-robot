import processing.serial.*;
Serial myPort;

public static final char HEADER = '|'; 
public static final char MOUSE = 'M';
public static final char MOUSEUP = 'U';
public static final char MOUSEDOWN = 'D';
public static final char DEBUG = 'N';
public static final char MEMORY_DATA = 'A';


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

void getDataToSend() 
{
  atheta = (int)processing2costantinoTHETA(this.theta);

  PVector v1 = new PVector(sx - ex, sy - ey);
  PVector v2 = new PVector(ex - hx, ey - hy);

  abeta = (int)(180 - degrees(PVector.angleBetween(v1, v2)));
}


float processing2costantinoTHETA(float t) 
{
  return 180-(345-degrees(t) +45);
}
