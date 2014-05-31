class drawTPoints extends Thread
{
//================================Fields================================
  private ArrayList<tPoint> tPoints;
  private inverseKinematics arm;
  private communication comm;
  public volatile boolean drawing;
//================================Constructors================================
  drawTPoints(ArrayList<tPoint> _tPoints, inverseKinematics _arm, communication _comm)
  {
    tPoints = _tPoints;
    arm = _arm;
    comm = _comm;
    drawing = false;
  }
  
  drawTPoints(ArrayList<tPoint> _tPoints)
  {
    this(_tPoints, null, null);
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
    if (comm != null)
    {
      arm.setPosition(tPoints.get(0).x, tPoints.get(0).y);
      comm.sendCommand(comm.MOUSE, arm.getAngle1(), arm.getAngle2());
      comm.sendCommand(comm.MOUSEDOWN);
    }
    for (int i = 1; i < tPoints.size(); i++)
    {
      if (!drawing)
      {
        break;
      }
      if (comm != null)
      {
        arm.setPosition(tPoints.get(i).x, tPoints.get(i).y);
        comm.sendCommand(comm.MOUSE, arm.getAngle1(), arm.getAngle2());
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
    if (comm != null)
    {
      comm.sendCommand(comm.MOUSEUP);
    }
    drawing = false;
  }
  
  void kill()
  {
    drawing = false;
  }
}
