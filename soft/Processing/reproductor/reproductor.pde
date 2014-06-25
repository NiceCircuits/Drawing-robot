BufferedReader reader;
drawTPoints drawer;
arm robotArm;
debug debugg;
// Debug level
final int debugLevel = 1;

ArrayList<tPoint> tPoints;
int starttime,drawStartTime;
volatile String infoText = ""; 
int mode = -1;
int group = 0, curveNumber=0;
final int curveNumberMin = 16;
String groupNames[] = {"", "lines", "circles", "triangles", "rectangles"};

database db;

//=======================================================================
void setup()
{
  if (debugLevel == 0)
  {
    size(920, 500);
  }
  else
  {
    // debug - 20px higher 
    size(920, 520);
  }
  changeMode(0);
  tPoints = new ArrayList<tPoint>();
  robotArm = new arm(this, 400, 400, 440, -136);
  debugg = new debug(debugLevel);
  String password;
  try
  {
    reader = createReader("password.txt");
    password = reader.readLine();
  }
  catch (Exception e)
  {
    password = "";
  }
  if(password != "")
  {  
    db = new database(this, "db4free.net", "rysownik", "rysownik", password);
  }
  else
  {
    db = new database();
  }
}

void draw()
{
}

void mousePressed() {
  if (drawer != null)
  {
    drawer.kill();
  }
  clearCanvas();
  tPoints=new ArrayList<tPoint>();
  starttime = millis();
  tPoints.add(new tPoint(mouseX,mouseY,0));
  robotArm.goTo(mouseX,mouseY); 
  robotArm.down();
  if (debugg.level > 0)
  {
    robotArm.drawArm();
  }
}

void mouseDragged() {
  int i;
  i = tPoints.size();
  tPoints.add(new tPoint(mouseX,mouseY,millis()-starttime));
  line(tPoints.get(i-1).x,tPoints.get(i-1).y,tPoints.get(i).x,tPoints.get(i).y);
  robotArm.goTo(mouseX,mouseY);
  if (debugg.level > 0)
  {
    robotArm.drawArm();
  }
}

void mouseReleased() {
  robotArm.up();
  if (mode == 1)
  {
    curveNumber++;
    changeMode(1);
  }
}

void keyPressed()
{
  if (key == ' ')
  {
   drawer = new drawTPoints(tPoints, robotArm);
   drawer.start();
  }
  if (mode == 0)
  {
    if (key == 'u')
    {
      changeMode(11);
    }
    if (key == 'r')
    {
      changeMode(2);
    }
  }
  if (mode == 11)
  {
    if (key >= '1' && key <= '4')
    {
      group = key - '0';
      changeMode(1);
    }
  }
// old functions
//  if (key == 's') // save to database
//  {
//    if (tPoints.size()>0)
//    {
//      db.addTPoints(tPoints);
//    }
//  }
//  if (key == 'c') //clear database
//  {
//    db.clearDatabase();
//  }
//  if (key == 'l') //load curves from database and draw them
//  {
//    tPoints = db.getTPoints((int)random(db.getCount()));
//    if (drawer != null)
//    {
//      drawer.kill();
//    }
//    drawer = new drawTPoints(tPoints, robotArm);
//    drawer.start();
//  }
//  if (key == 'd' && debugg.level>0) //draw arm limits
//  {
//    robotArm.drawLimits();
//  }
//  if (key == 'g' && debugg.level>0) //draw arm resolution grid
//  {
//    robotArm.drawResolutionGrid();
//  }
}

void mouseMoved()
{
  debugg.drawText(1, String.format("x=%4d y=%4d", mouseX, mouseY));
}

void changeMode(int _mode)
{
  if (_mode == 11)
  {
    infoText = "Phase 1 start.\n"+
      "Press:\n"+
      "  space - redraw last curve\n"+
      "  1 - start drawing lines\n"+
      "  2 - start drawing circles\n"+
      "  3 - start drawing triangles\n"+
      "  4 - start drawing rectangles\n";
     mode = 11;
  }
  else if (_mode == 1)
  {
    infoText = String.format("Draw %s.\n"+
      "  %d/%d ready\n", groupNames[group], curveNumber, curveNumberMin);
     mode = 1;
  }
  else if (_mode == 2)
  {
    mode = 2;
  }
  else
  {
    infoText = "Draw with mouse.\n"+
      "Press:\n"+
      "  space - redraw last curve\n"+
      "  u - start phase 1 - user\n"+
      "  r - start phase 2 - robot";
     mode = 0;
  }
  clearCanvas();
}

void clearCanvas()
{
  background(0);
  stroke(255);
  // print manual
  fill(128,128,0);
  text(infoText, 10, 20);
}


