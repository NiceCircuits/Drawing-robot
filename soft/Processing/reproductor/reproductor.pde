BufferedReader reader;
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
ArrayList<ArrayList<tPoint>> warehouse;
int starttime,drawStartTime;

int startdraw=0;
int drawcount=0;
int warehousecount=0;
database db;

//=======================================================================
void setup()
{
  size(600, 600);
  tPoints = new ArrayList<tPoint>();
  warehouse = new ArrayList<ArrayList<tPoint>>();
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
  background(0);
  stroke(255);
}

void draw()
{
  if(startdraw>0)
  {
    startdraw=0;
    background(0);
    drawcount=1;
    drawStartTime=millis();
    tPoints=warehouse.get(warehousecount);
  }
  if(drawcount>0)
  {
    if(drawcount >= tPoints.size())
    {
       drawcount=0;
       warehousecount++;
       if (warehousecount<warehouse.size())
       {
         startdraw=1;
       }
    }
    else
    {
      int i = drawcount;
      if(tPoints.get(i).dTime <= millis() - drawStartTime)
      {
        line(tPoints.get(i-1).x,tPoints.get(i-1).y,tPoints.get(i).x,tPoints.get(i).y);
        drawcount++;
      }
    }
  }  
}

void mousePressed() {
  background(0);
  tPoints=new ArrayList<tPoint>();
  starttime = millis();
  tPoints.add(new tPoint(mouseX,mouseY,0));
  startdraw=0;
  drawcount=0;
}

void mouseDragged() {
  int i;
  i = tPoints.size();
  tPoints.add(new tPoint(mouseX,mouseY,millis()-starttime));
  line(tPoints.get(i-1).x,tPoints.get(i-1).y,tPoints.get(i).x,tPoints.get(i).y);
}

void mouseReleased() {
  warehouse.add(new ArrayList<tPoint>(tPoints));
}

//boolean sketchFullScreen() {
//  return false;
//}

void keyPressed()
{
  if (key == ' ')
  {
    startdraw=1;
    warehousecount=0;
    drawcount=0;
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



