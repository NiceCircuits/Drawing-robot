class debug
{
//================================Fields================================
  public int level;
//================================Constructors================================
  public debug(int _level)
  {
    level = _level;
  }
//================================Methods================================
  public void write(int _level, String text)
  {
    if(_level <= level)
    {
      println(text);
    }
  }
  public void write(String text)
  {
    this.write(1, text);
  }
  public void drawText(int _level, String text)
  {
    if(_level <= level)
    {
      fill(0);
      rect(0, height-20, width, 20);
      fill(128,128,0);
      text(text, 5, height-5);
    }
  }
}
