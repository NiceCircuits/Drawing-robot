BufferedReader reader;
drawTPoints drawer;

class tPoint
{
//================================Constructors================================
  public tPoint(int x1,int y1,int dTime1)
  {
    x=x1;
    y=y1;
    dTime=dTime1;
  }
  public tPoint(String str)
  {
  }
//================================Methods================================
  public String toString()
  {
    return "(" + nf(x,1) + ";" + nf(y,1) + ";" + nf(dTime,1) + ")";
  }
//================================Fields================================
  public int id,x,y,dTime;
}

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
}

void mouseReleased() {
}

void keyPressed()
{
  if (key == ' ')
  {
   drawer = new drawTPoints(tPoints);
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

}



