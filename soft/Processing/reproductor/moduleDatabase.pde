import de.bezier.data.sql.*;


class database
{
//================================Fields================================
  private MySQL sql;
//================================Constructors================================
  public database(PApplet applet, String server, String sqlDatabase, String sqlUser, String sqlPassword) 
  {
    if (server != "")
    {
      sql = new MySQL(applet, server, sqlDatabase, sqlUser, sqlPassword);
      if ( sql.connect() )
      {
        println("Connected to database " + sqlDatabase);
      }
      else
      {
        println("Cannot connect to database " + sqlDatabase);
      }
    } // end if (server != "")
    else
    {
      sql = null;
      println("No database specified");
    }
  }
  public database()
  {
    this(null, "", "", "", "");
  }
//================================Methods================================
  public int getCount(int group)
  {
    sql.query("SELECT listCount%d FROM summary", group);
    sql.next();
    return sql.getInt(1);
  }
  
  public void addTPoints(ArrayList<tPoint> _tPoints, int group)
  {
    if (tPoints.size()>0)
    {
      int number = getCount(group);
      tPoint _tPoint;
      println("Saving to database...");
      sql.query("DROP TABLE IF EXISTS tPoints%d_%d", group, number);
      sql.query("CREATE TABLE tPoints%d_%d (id int NOT NULL AUTO_INCREMENT, x int NOT NULL, y int NOT NULL, dTime int NOT NULL, PRIMARY KEY (id))ENGINE=InnoDB", group, number);
      String query= String.format("INSERT INTO tPoints%d_%d (id, x, y, dTime) VALUES ", group, number);
      for (int i=0; i<_tPoints.size(); i++)
      {
        _tPoint = tPoints.get(i);
        query = query + String.format("(%d, %d, %d, %d),", i+1, _tPoint.x, _tPoint.y, _tPoint.dTime);
      }
      query = query.substring(0, query.length()-1); // remove last ","
      sql.query(query);
      sql.query("UPDATE summary SET listCount%d=%d;", group, number+1);
      println("Saved " + nf(_tPoints.size(),1) + " tPoints to database");
    }
    else
    {
      print("Trying to save empty tPoints ArrayList!");
    }
  }
  
  public ArrayList<tPoint> getTPoints(int number, int group)
  {
    if (number >=  getCount(group))
    {
      return null; 
    }
    ArrayList<tPoint> ret = new ArrayList<tPoint>();
    sql.query( "SELECT * FROM tPoints%d_%d", group, number);
    while (sql.next())
    {
      tPointWithId p = new tPointWithId();
      sql.setFromRow(p);
      ret.add((tPoint)p);
     }
     return ret;
  }
  
  public void clearDatabase(int group)
  {
    int number = getCount(group);
    println("Clearing database...");
    for (int i=0; i<number; i++)
    {
      sql.query("DROP TABLE IF EXISTS tPoints%d_%d", group, i);
    }
     sql.query("UPDATE summary SET listCount%d=0;", group);
     println("Database cleared");
  }
}


