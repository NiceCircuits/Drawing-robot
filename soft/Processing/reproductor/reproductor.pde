BufferedReader reader;
drawTPoints drawer;
arm robotArm;
debug debugg;
// Debug level
final int debugLevel = 0;

ArrayList<tPoint> tPoints;
int starttime,drawStartTime;

database db;

//=======================================================================
void setup()
{
  size(850, 600);
  clearCanvas();
  tPoints = new ArrayList<tPoint>();
  robotArm = new arm(this, 400, 400, 425, 600);
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
  drawer.kill();
  clearCanvas();
  tPoints=new ArrayList<tPoint>();
  starttime = millis();
  tPoints.add(new tPoint(mouseX,mouseY,0));
  robotArm.goTo(mouseX,mouseY); 
  robotArm.down();
  if (debugg.level > 1)
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
  if (debugg.level > 1)
  {
    robotArm.drawArm();
  }
}

void mouseReleased() {
  robotArm.up();
}

void keyPressed()
{
  if (key == ' ')
  {
   drawer = new drawTPoints(tPoints, robotArm);
   drawer.start();
  }
  if (key == 's') // save to database
  {
    if (tPoints.size()>0)
    {
      db.addTPoints(tPoints);
    }
  }
  if (key == 'c') //clear database
  {
    db.clearDatabase();
  }
  if (key == 'l') //load curves from database and draw them
  {
    tPoints = db.getTPoints((int)random(db.getCount()));
    if (drawer != null)
    {
      drawer.kill();
    }
    drawer = new drawTPoints(tPoints, robotArm);
    drawer.start();
  }

}

void clearCanvas()
{
  background(0);
  stroke(255);
  // print manual
  fill(128,128,0);
  text("Draw with mouse.\n"+
    "Key functions:\n"+
    "  space - redraw last curve\n"+
    "  s - save curve to database\n"+
    "  l - load random curve from database\n"+
    "  c - clear whole database", 10,20);
}


