class drawTPoints extends Thread
{
//================================Fields================================
  private ArrayList<tPoint> tPoints;
  private arm robotArm;
  public volatile boolean drawing;
//================================Constructors================================
  drawTPoints(ArrayList<tPoint> _tPoints, arm _robotArm)
  {
    tPoints = _tPoints;
    robotArm = _robotArm;
    drawing = false;
  }
  
  drawTPoints(ArrayList<tPoint> _tPoints)
  {
    this(_tPoints, null);
  }
//================================Methods================================
  void start()
  {
    drawing = true;
    background(0);
    super.start();
  }
  
  void run()
  {
    if (robotArm != null)
    {
      robotArm.goTo(tPoints.get(0).x, tPoints.get(0).y);
      robotArm.down();
    }
    for (int i = 1; i < tPoints.size(); i++)
    {
      if (!drawing)
      {
        break;
      }
      if (robotArm != null)
      {
        robotArm.goTo(tPoints.get(i).x, tPoints.get(i).y);
      }
      line(tPoints.get(i-1).x,tPoints.get(i-1).y,tPoints.get(i).x,tPoints.get(i).y);
      try
      {
        sleep(tPoints.get(i).dTime - tPoints.get(i-1).dTime);
      }
      catch (Exception e)
      {
      }
    }
    if (robotArm != null)
    {
      robotArm.up();
    }
    drawing = false;
  }
  
  void kill()
  {
    drawing = false;
  }
}
