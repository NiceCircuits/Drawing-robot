class drawTPoints extends Thread
{
//================================Fields================================
  private ArrayList<tPoint> _tPoints;
  public boolean drawing;
//================================Constructors================================
  drawTPoints(ArrayList<tPoint> tPoints)
  {
    _tPoints = tPoints;
    drawing = false;
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
    for (int i = 1; i < _tPoints.size(); i++)
    {
      line(tPoints.get(i-1).x,tPoints.get(i-1).y,tPoints.get(i).x,tPoints.get(i).y);
      try
      {
        sleep(tPoints.get(i).dTime - tPoints.get(i-1).dTime);
      }
      catch (Exception e)
      {
      }
    }
    drawing = false;
  }
}
