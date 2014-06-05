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
    if (_portName == "")
    {
      if (Serial.list().length>0)
      {
        _portName = Serial.list()[0];
      }
    }
    try
    {
      port = new Serial(applet, _portName, 115200);
      println("Connected to", _portName);
    } 
    catch(Exception e)
    {
      println("### Cannot connect to serial port!");
    }
  }

  public communication(PApplet applet)
  {
    this(applet, "");
  } 
  
//================================Methods================================
  public void sendCommand(char command)
  {
    sendCommand(command, 0, 0);
  } 
  
  public void sendCommand(char command, float angle1Deg, float angle2Deg)
  {
    try
    {
      port.write(HEADER); 
      port.write(command);
      port.write((int)angle1Deg); 
      port.write((int)angle2Deg);
      debugg.write(3, String.format("send: %c, %d, %d", command, (int)angle1Deg, (int)angle2Deg));
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
    debugg.write(1, "ARDUINO ECHO ### " + inString);
  }
}

