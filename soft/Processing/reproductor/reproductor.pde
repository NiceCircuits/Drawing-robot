BufferedReader reader;
drawTPoints drawer;
inverseKinematics arm;
communication comm;

ArrayList<tPoint> tPoints;
int starttime,drawStartTime;

database db;

//=======================================================================
void setup()
{
  size(850, 600);
  background(0);
  stroke(255);
  tPoints = new ArrayList<tPoint>();
  arm = new inverseKinematics(600, 600, 425, 600);
  comm = new communication(this);
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
  background(0);
  tPoints=new ArrayList<tPoint>();
  starttime = millis();
  tPoints.add(new tPoint(mouseX,mouseY,0));
}

void mouseDragged() {
  int i;
  i = tPoints.size();
  tPoints.add(new tPoint(mouseX,mouseY,millis()-starttime));
  line(tPoints.get(i-1).x,tPoints.get(i-1).y,tPoints.get(i).x,tPoints.get(i).y);
  arm.setPosition(mouseX,mouseY);
//  line(arm.startX, arm.startY, arm.getArm1Position()[0], arm.getArm1Position()[1]); 
//  line(arm.getArm1Position()[0], arm.getArm1Position()[1], arm.getArm2Position()[0], arm.getArm2Position()[1]);
}

void mouseReleased() {
}

void keyPressed()
{
  if (key == ' ')
  {
   drawer = new drawTPoints(tPoints, arm, comm);
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
    drawer = new drawTPoints(tPoints, arm, comm);
    drawer.start();
  }

}



