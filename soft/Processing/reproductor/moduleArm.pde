class arm
{
//================================Fields================================
  private communication comm;
  private inverseKinematics kinem;
//================================Constructors================================
  public arm(PApplet applet, float length1, float length2, int startX, int startY)
  {
    kinem = new inverseKinematics(length1, length2, (float)startX, (float)startY, -70.0, 110.0, 0.0, 162.00);
    comm = new communication(applet);
  }
//================================Methods================================
  public void goTo(int x, int y) 
  {
    kinem.setPosition(x,y);
    // TODO: fix dirty hack (+60)
    float angle1 = kinem.angle1 +60;
    angle1 = constrain(angle1, 0, 180);
    if (invert1)
    {
      angle1 = 180 - angle1;
    }
    float angle2 = constrain(kinem.angle2, 0, 180);
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
  public void drawLimits()
  {
    ArrayList<tPoint> tPoints = new ArrayList<tPoint>();
    float step=2;
    // draw "rectangle" from angle limits
    kinem.angle2=kinem.min2;
    for (float a=kinem.min1; a<=kinem.max1; a+=step)
    {
      kinem.angle1=a;
      tPoints.add(new tPoint((int)kinem.getArm2Position()[0], (int)kinem.getArm2Position()[1], 0));
    } 
    kinem.angle1=kinem.max1;
    for (float a=kinem.min2; a<=kinem.max2; a+=step)
    {
      kinem.angle2=a;
      tPoints.add(new tPoint((int)kinem.getArm2Position()[0], (int)kinem.getArm2Position()[1], 0));
    } 
    kinem.angle2=kinem.max2;
    for (float a=kinem.max1; a>=kinem.min1; a-=step)
    {
      kinem.angle1=a;
      tPoints.add(new tPoint((int)kinem.getArm2Position()[0], (int)kinem.getArm2Position()[1], 0));
    } 
    kinem.angle1=kinem.min1;
    for (float a=kinem.max2; a>=kinem.min2; a-=step)
    {
      kinem.angle2=a;
      tPoints.add(new tPoint((int)kinem.getArm2Position()[0], (int)kinem.getArm2Position()[1], 0));
    } 
    if (drawer != null)
    {
      drawer.kill();
    }
    for(tPoint p: tPoints)
    {
      p.translate(0.5,width/4,height/4);
    }
    drawer = new drawTPoints(tPoints, robotArm);
    drawer.start(255,0,0);
    ArrayList<tPoint> tPoints2 = new ArrayList<tPoint>();
    int xMin=(int)(kinem.startX-1.1*(kinem.length1));
    int xMax=(int)(kinem.startX+1.2*(kinem.length1));
    int yMin=(int)(kinem.startY+0.34*(kinem.length1));
    int yMax=(int)(kinem.startY+1.59*(kinem.length1));
    tPoints2.add(new tPoint(xMin, yMin, 0));
    tPoints2.add(new tPoint(xMax, yMin, 0));
    tPoints2.add(new tPoint(xMax, yMax, 0));
    tPoints2.add(new tPoint(xMin, yMax, 0));
    tPoints2.add(new tPoint(xMin, yMin, 0));
    for(tPoint p: tPoints2)
    {
      p.translate(0.5,width/4,height/4);
    }
    drawer.drawAlso(tPoints2,0,0,255);
  }
  public void drawResolutionGrid()
  {
    for (float a1=kinem.min1; a1<=kinem.max1; a1+=1.0)
    {
      kinem.angle1=a1;
      for (float a2=kinem.min2; a2<=kinem.max2; a2+=1.0)
      {
        kinem.angle2=a2;
        point((int)kinem.getArm2Position()[0], (int)kinem.getArm2Position()[1]);
      }
    }
  }
}

