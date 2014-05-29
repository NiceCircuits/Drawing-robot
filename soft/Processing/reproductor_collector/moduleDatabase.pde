import de.bezier.data.sql.*;


class database
{
//================================Constructors================================
  public database(PApplet applet, String server, String sqlDatabase, String sqlUser, String sqlPassword) 
  {
    if (server != "")
    {
      sql = new MySQL(applet, server, sqlDatabase, sqlUser, sqlPassword);
      if ( sql.connect() )
      {
        println("Connected to database " + sqlDatabase);
        println( "Database has " + getCount() + " saved drawings" );
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
public int getCount()
{
  sql.query("SELECT listCount FROM summary");
  sql.next();
  return sql.getInt(1);
}

public void addTPoints(ArrayList<tPoint> _tPoints)
{
  int number = getCount();
  tPoint _tPoint;
  println("Saving to database...");
  sql.query("DROP TABLE IF EXISTS tPoints%d", number);
  sql.query("CREATE TABLE tPoints%d (id int NOT NULL AUTO_INCREMENT, x int NOT NULL, y int NOT NULL, dTime int NOT NULL, PRIMARY KEY (id))ENGINE=InnoDB", number);
  for (int i=0; i<_tPoints.size(); i++)
  {
    _tPoint = tPoints.get(i);
    sql.query("INSERT INTO tPoints%d VALUES(%d, %d, %d, %d);", number, i+1, _tPoint.x, _tPoint.y, _tPoint.dTime);
  }
  sql.query("UPDATE summary SET listCount=%d;", number+1);
  println("Saved " + nf(_tPoints.size(),1) + " tPoints to database");
}

public void clearDatabase()
{
  int number = getCount();
  println("Clearing database...");
  for (int i=0; i<number; i++)
  {
    sql.query("DROP TABLE IF EXISTS tPoints%d", i);
  }
   sql.query("UPDATE summary SET listCount=0;");
   println("Database cleared");
}
//================================Fields================================
  private MySQL sql;
}


