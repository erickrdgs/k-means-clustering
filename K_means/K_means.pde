import java.util.Collections;

// ----------- VARIABLES ----------- //
int numCentroids = 6;
float  threshold = 0.1;

ArrayList<Centroid> oldCentroids = new ArrayList<Centroid>();
ArrayList<Centroid> centroids    = new ArrayList<Centroid>();
ArrayList<Particle> particles    = new ArrayList<Particle>();

Table table;
PFont f;

int     counter;
boolean isDrawn;

// ------------ VOID METHODS ------------ //
void setup() 
{    
  f     = createFont("Verdana", 12, true);    
  table = loadTable("Data/Task.csv", "header");
          
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
  randomSeed(0);
  for(int i = 0; i < numCentroids; i++)
  {
    int index = (int) random(0, particles.size()); 
    centroids.add(new Centroid(particles.get(index).components, i, random(255), random(255), random(255)));
  }  
}

// ------------ NOT SO VOID METHODS ------------ //

boolean Equals(ArrayList<Centroid> otherCentroids, ArrayList<Centroid> centroids)
{
  if(otherCentroids.size() != centroids.size()) return false;
  
  for(int i = 0; i < centroids.size(); i++)
  {
    if(abs(otherCentroids.get(i).components.x - centroids.get(i).components.x) > threshold ||
       abs(otherCentroids.get(i).components.y - centroids.get(i).components.y) > threshold ||
       abs(otherCentroids.get(i).components.z - centroids.get(i).components.z) > threshold)
    {
      return false;
    }
  }
  return true;
}
