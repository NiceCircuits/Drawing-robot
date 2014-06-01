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
}
