class inverseKinematics
{
//====================fields====================
  public float angle1, angle2; // angles of arms
  public float length1, length2; // length of arms
  public float startX, startY; // position of arm base
  public float min1, max1, min2, max2; // limits
//=============constructor====================
  // set lengths of arms
  public inverseKinematics(float armLength1, float armLength2, float _startX, float _startY, float _min1, float _max1, float _min2, float _max2)
  {
    length1 = armLength1;
    length2 = armLength2;
    startX = _startX;
    startY = _startY;
    min1 = _min1;
    max1 = _max1;
    min2 = _min2;
    max2 = _max2;
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
    angle1 = rad2Deg(D + B + PI + C) % 360.0;
    if (angle1<0)
    {
      angle1= angle1+360.0;
    }
    angle1 = constrain(angle1, min1, max1);
    angle2 = (rad2Deg(D+B)-angle1) % 360.0;
    if (angle2<0)
    {
      angle2= angle2+360.0;
    }
    angle2 = constrain(angle2, min2, max2);
    debugg.write(1, String.format("x=%3.0f y=%3.0f a1=%3.0f a2=%3.0f", x, y, angle1, angle2));
  }
    
  public float[] getArm1Position()
  {
    float[] pos = {cos(deg2Rad(angle1))*length1+startX, sin(deg2Rad(angle1))*length1+startY};
    return pos;
  }
  
  public float[] getArm2Position()
  {
    float[] pos1 = getArm1Position();
    float[] pos2 = {pos1[0] + cos(deg2Rad(angle2+angle1))*length2, pos1[1] + sin(deg2Rad(angle2+angle1))*length2};
    return pos2;
  }
  public float rad2Deg(float angle)
  {
    return (angle*180/PI);
  }
  
  public float deg2Rad(float angle)
  {
    return (angle*PI/180);
  }
  
}
