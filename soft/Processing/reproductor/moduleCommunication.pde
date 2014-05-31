import processing.serial.*;

class communication
{
//================================Fields================================
  Serial port;
  private final char HEADER = '|';
  public final char MOUSE = 'M';
  public final char MOUSEUP = 'U';
  public final char MOUSEDOWN = 'D';
  public final char DEBUG = 'N';
  public final char MEMORY_DATA = 'A';
//================================Constructors================================
  public communication(PApplet applet, String _portName)
  {
    try
    {
      port = new Serial(applet, _portName, 115200);
      println(_portName);
    } 
    catch(Exception e)
    {
      println("### Cannot connect to serial port!");
    }
  }

  public communication(PApplet applet)
  {
    this(applet, Serial.list()[0]);
  } 
  
//================================Methods================================
  public void sendCommand(char command)
  {
    sendCommand(command, 0, 0);
  } 
  
  public void sendCommand(char command, float angle1, float angle2)
  {
    int atheta = (int)(180-(345-degrees(angle1) +45));
    int abeta = (int)(180 - angle2 + angle1);
  
    try
    {
      port.write(HEADER); 
      port.write(command);
      port.write(180 - atheta); 
      port.write(180 - abeta);
    }
    catch(Exception e) 
    {
    }
  } 
}

void serialEvent(Serial p) 
{ 
  // handle incoming serial data 
  String inString = p.readStringUntil('\n');
  if (inString != null) 
  {
    print("ARDUINO ECHO ### ");
    println(inString);    // echo text string from arduino
  }
}

