class inverseKinematics
{
  //====================fields====================
  private float angle1, angle2; // angles of arms
  private float length1, length2; // length of arms
  public int startX, startY; // position of arm base
  //====================constructor====================
  // set lengths of arms
  public inverseKinematics(float armLength1, float armLength2, int _startX, int _startY)
  {
    length1 = armLength1;
    length2 = armLength2;
    startX = _startX;
    startY = _startY;
  }
  
  //====================methods====================
  public void setPosition(float x, float y)
  {
    x = x - startX;
    y = y - startY;
    float D, E, B, C;
    float c = sqrt(x*x+y*y);
    c = min(c, length1 + length2);
    B = acos((length2*length2-length1*length1-c*c)/(-2*length1*c));
    C = acos((c*c-length1*length1-length2*length2)/(-2*length1*length2));
    D = atan2(y, x);
    angle1 = D + B + PI + C;
    angle2 = D+B;
  }
  
  public float getAngle1()
  {
    return angle1;
  }
  
  public float getAngle2()
  {
    return angle2;
  }
  
  public float getAngle1Deg()
  {
    return rad2Deg(angle1);
  }
  
  public float getAngle2Deg()
  {
    return rad2Deg(angle2);
  }
  
  public float[] getArm1Position()
  {
    float[] pos = {cos(angle1)*length1+startX, sin(angle1)*length1+startY};
    return pos;
  }
  
  public float[] getArm2Position()
  {
    float[] pos1 = getArm1Position();
    float[] pos2 = {pos1[0] + cos(angle2)*length2, pos1[1] + sin(angle2)*length2};
    return pos2;
  }
  public float rad2Deg(float angle)
  {
    return (angle*180/PI);
  }
  
}
