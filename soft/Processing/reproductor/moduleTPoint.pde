class tPoint
{
//================================Fields================================
  public int x,y,dTime;
//================================Constructors================================
  public tPoint(int x1,int y1,int dTime1)
  {
    x=x1;
    y=y1;
    dTime=dTime1;
  }
  public tPoint()
  {
  }
//================================Methods================================
  public String toString()
  {
    return "(" + nf(x,1) + ";" + nf(y,1) + ";" + nf(dTime,1) + ")";
  }
  public void translate(float scale, int moveX, int moveY)
  {
    x = (int)(x*scale)+moveX;
    y = (int)(y*scale)+moveY;
  }
}

class tPointWithId extends tPoint
{
//================================Fields================================
  public int id;
//================================Constructors================================
  public tPointWithId(int x1,int y1,int dTime1)
  {
    super(x1,y1,dTime1);
  }
  public tPointWithId()
  {
    super();
  }  
//================================Methods================================
  
}
