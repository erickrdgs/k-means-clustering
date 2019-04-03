import java.util.Collections;

// ----------- VARIABLES ----------- //
float numCentroids = 6;

ArrayList<Centroid> oldCentroids = new ArrayList<Centroid>();
ArrayList<Centroid> centroids    = new ArrayList<Centroid>();
ArrayList<Particle> particles    = new ArrayList<Particle>();

Table table;
PFont f;

int     counter;
boolean isDrawn;

// ------------ METHODS ------------ //
void setup() 
{    
  isDrawn = false;
  f       = createFont("Verdana", 12, true);    
  table   = loadTable("Data/Task.csv", "header");
          
  textFont(f);
  fullScreen();
  background(0);
  textAlign(CENTER);
  
  CreateParticles();
  CreateCentroids();
}

void draw()
{ 
  if(!isDrawn)
  {
    if(Equals(oldCentroids, centroids))
      DrawEverything();
    else
      TickSim();
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

boolean Equals(ArrayList<Centroid> otherCentroids, ArrayList<Centroid> centroids)
{
  if(otherCentroids.size() != centroids.size()) return false;
  
  for(int i = 0; i < centroids.size(); i++)
  {
    if(otherCentroids.get(i).components.x != centroids.get(i).components.x ||
       otherCentroids.get(i).components.y != centroids.get(i).components.y ||
       otherCentroids.get(i).components.z != centroids.get(i).components.z)
    {
      return false;
    }
  }
  return true;
}

void CopyCentroids(ArrayList<Centroid> otherCentroids, ArrayList<Centroid> centroids)
{  
  otherCentroids.clear();
  
  for(Centroid c: centroids)
    otherCentroids.add(c.Copy());
}

void TickSim()
{
  CopyCentroids(oldCentroids, centroids);
  
  for (int i = 0; i < particles.size(); i++)
    particles.get(i).FindClosestCentroid(centroids); 
  
  for (int i = 0; i < centroids.size(); i++)
    centroids.get(i).Tick(particles);
    
  counter++;
  println(counter + "° iteration");
}

void DrawEverything()
{  
  Collections.sort(centroids);
  Collections.sort(oldCentroids);
      
  for (int i = 0; i < particles.size(); i++)    
    particles.get(i).DrawParticle();
  
  for (int i = 0; i < centroids.size(); i++)
  {
    centroids.get(i).DrawCentroid();
    DrawLines(centroids, i);
  }
  
  isDrawn = true;
}

void DrawLines(ArrayList<Centroid> centroids, int i)
{
  fill(255);
  text(i, centroids.get(i).components.x, centroids.get(i).components.y);
    
  if(i < centroids.size() - 1)
  {
    stroke(255);
    line(centroids.get(i).components.x, centroids.get(i).components.y,
         centroids.get(i+1).components.x, centroids.get(i+1).components.y); 
  }
}

void CreateParticles()
{  
  for(TableRow row: table.rows())
  {
    PVector components = new PVector(row.getFloat("x0"), row.getFloat("x1"), row.getFloat("x2"));  
    particles.add(new Particle(components));
  }
}

void CreateCentroids()
{
  PVector max = MaxAllowed();
  
  for(int i = 0; i < numCentroids; i++)
  {
    PVector components = new PVector(random(max.x), random(max.y), random(max.z));    
    centroids.add(new Centroid(components, i, random(255), random(255), random(255)));
  }  

}
