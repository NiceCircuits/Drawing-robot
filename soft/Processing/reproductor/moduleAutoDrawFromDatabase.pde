class autoDraw extends Thread
{
//================================Fields================================
  private arm robotArm;
  private database db;
  private ArrayList<tPoint> tPoints;
  private drawTPoints drawer;
//================================Constructors================================
  public autoDraw(arm _robotArm, database _db)
  {
    robotArm = _robotArm;
    db = _db;
  }
//================================Methods================================
  void start()
  {
   super.start();
  } 
  void run()
  {
    for (int group = 1; group<=4; group++)
    {
      int len = db.getCount(group);
      int moveX, moveY;
      switch (group)
      {
        case 1:
          moveX=0;
          moveY=0;
          break;
        case 2:
          moveX=width/2;
          moveY=0;
          break;
        case 3:
          moveX=0;
          moveY=height/2;
          break;
        case 4:
        default:
          moveX=width/2;
          moveY=height/2;
          break;
      }
      for (int i=0; i<4 && i<len; i++)
      {
        tPoints = db.getTPoints((int)random(len), group);
        for (int t=0; t<tPoints.size(); t++)
        {
          tPoints.get(t).translate(0.5, moveX, moveY);
        }
        drawer = new drawTPoints(tPoints, robotArm, fastAutoDraw);
        if (i!=0 || group!=1)
        {
          drawer.clearBeforeDraw=false;
        }
        drawer.start();
        do
        {
          try
          {
            sleep(100);
          }
          catch (Exception e)
          {
          }
        } while (drawer.drawing);
          try
          {
            if(fastAutoDraw) 
            {
              sleep(300);
            }
            else
            {
              sleep(3000);
            }
          }
          catch (Exception e)
          {
          }
      }
    }
  }
  void kill()
  {
  }
}
