int numCentroids = 6;
int clicks       = 0;

ArrayList centroids, particles;
Table     table;

void setup() 
{  
  fullScreen();
  
  table = loadTable("Data/Task.csv", "header");
  
  particles = new ArrayList();
  centroids = new ArrayList();

  for(TableRow row: table.rows())
  {
    PVector components = new PVector(row.getFloat("x0"), row.getFloat("x1"), row.getFloat("x2"));  
    particles.add(new Particle(components));
  }
    
  PVector max = MaxAllowed();
  
  for(int i = 0; i < numCentroids; i++)
  {
    PVector components = new PVector(random(max.x), random(max.y), random(max.z));    
    centroids.add(new Centroid(components, i, random(255), random(255), random(255)));
  }  
}

void draw()
{
  background(0); 
  
  for (int i = 0; i < particles.size(); i++) {
    Particle p = (Particle) particles.get(i);
    p.FindClosestCentroid(centroids);
  }    
    
  for (int i = 0; i < particles.size(); i++) {
    Particle p = (Particle) particles.get(i);
    p.DrawParticle();
  }
  
  for (int i = 0; i < centroids.size(); i++) {
    Centroid c = (Centroid) centroids.get(i);
    c.DrawCentroid();
  }  
}

void mouseClicked()
{ 
  clicks++;
  println(clicks + "° interation");
      
  for (int i = 0; i < centroids.size(); i++) {
    Centroid c = (Centroid) centroids.get(i);
    c.Tick(particles);
    
    println("X: " + c.components.x +
            " Y: " + c.components.y +
            " T: " + c.components.z +
            " N° Particles: " + c.numParticles);
  }
}

PVector MaxAllowed()
{
  PVector max = new PVector();
  
  for(TableRow row: table.rows())
  {
    if(row.getFloat("x0") > max.x) max.x = row.getFloat("x0");
    if(row.getFloat("x1") > max.y) max.y = row.getFloat("x1");
    if(row.getFloat("x2") > max.z) max.z = row.getFloat("x2");
  }
  
  return max;
}
