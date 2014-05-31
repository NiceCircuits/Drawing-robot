class drawTPoints extends Thread
{
//================================Fields================================
  private ArrayList<tPoint> _tPoints;
  public volatile boolean drawing;
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
      if (!drawing)
      {
        break;
      }
      line(_tPoints.get(i-1).x,_tPoints.get(i-1).y,_tPoints.get(i).x,_tPoints.get(i).y);
      try
      {
        sleep(_tPoints.get(i).dTime - _tPoints.get(i-1).dTime);
      }
      catch (Exception e)
      {
      }
    }
    drawing = false;
  }
  
  void kill()
  {
    drawing = false;
  }
}
