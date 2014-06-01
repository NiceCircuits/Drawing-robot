class arm
{
//================================Fields================================
  private communication comm;
  private inverseKinematics kinem;
//================================Constructors================================
  public arm(PApplet applet, float length1, float length2, int startX, int startY)
  {
    kinem = new inverseKinematics(length1, length2, startX, startY);
    comm = new communication(applet);
  }
//================================Methods================================
  public void goTo(int x, int y) 
  {
    kinem.setPosition(x,y);
    float angle1 = constrain(360-kinem.getAngle1Deg(), 0, 180);
    float angle2 = constrain(-180+kinem.getAngle1Deg()-kinem.getAngle2Deg(), 0, 180);
    comm.sendCommand(comm.MOUSE, angle1, angle2);
  }
  public void up()
  {
     comm.sendCommand(comm.MOUSEUP);
  }
  public void down()
  {
     comm.sendCommand(comm.MOUSEDOWN);
  }
  public void drawArm()
  {
    stroke(0,255,0);
    line(kinem.startX, kinem.startY, kinem.getArm1Position()[0], kinem.getArm1Position()[1]);
    line(kinem.getArm1Position()[0], kinem.getArm1Position()[1], kinem.getArm2Position()[0], kinem.getArm2Position()[1]);
    stroke(255);  
  }
}

