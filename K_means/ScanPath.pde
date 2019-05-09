ArrayList<Particle> particles;
Table table;

void setup()
{ 
  table = loadTable("Data/Task.csv", "header");

  fullScreen();
  textAlign(CENTER, CENTER);

  CreateParticles();
}

void draw()
{ 
  background(0);
}

void CreateParticles()
{  
  for (TableRow row : table.rows())
  {
    PVector components = new PVector(row.getFloat("x0"), row.getFloat("x1"), row.getFloat("x2"));  
    particles.add(new Particle(components));
  }
}
