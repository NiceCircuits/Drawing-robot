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
      for (int i=0; i<4 && i<len; i++)
      {
        tPoints = db.getTPoints((int)random(len), group);
        drawer = new drawTPoints(tPoints, robotArm);
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
            sleep(3000);
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
