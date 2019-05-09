import java.util.Collections;

class Kmeans
{
  // ----------- VARIABLES ----------- //
  int numCentroids;
  float  threshold;

  ArrayList<Centroid> oldCentroids, centroids;
  ArrayList particles;

  PFont f;

  boolean isDrawn;
  boolean isVisible = true;
  
  // ------------ CONSTRUCTOR ------------ //
  Kmeans(int numCentroids, float threshold, ArrayList particles, String font, int fontSize)
  {
    this.numCentroids = numCentroids;
    this.threshold = threshold;
    this.particles = particles;
    
    CreateCentroids(numCentroids);
    
    f = createFont(font, fontSize, true);
    textFont(f);
    
  }
  
  // ------------ VOID METHODS ------------ //  
  void Draw()
  {    
    if (Equals(oldCentroids, centroids))
      DrawEverything();
    else
      TickSim();
  }
  
  void SetActive(boolean isVisible)
  {
    this.isVisible = isVisible;
  }
    
  private void CreateCentroids(int n)
  {  
    randomSeed(0);
    
    for (int i = 0; i < n; i++)
    {
      int index  = (int) random(0, particles.size());      
      Particle p = (Particle) particles.get(index);
            
      centroids.add(new Centroid(p.components, i, random(255), random(255), random(255)));
    }
  }
  
  private void CopyCentroids(ArrayList<Centroid> oldCentroids, ArrayList<Centroid> centroids)
  {  
    oldCentroids.clear();
    for (Centroid c : centroids) oldCentroids.add(c.Copy());
  }
  
  private void TickSim()
  {
    CopyCentroids(oldCentroids, centroids);

    for (int i = 0; i < particles.size(); i++)
    {
      Particle p = (Particle) particles.get(i);
      p.FindClosestCentroid(centroids); 
    }      

    for (int i = 0; i < centroids.size(); i++)
      centroids.get(i).Tick(particles);
  }
  
  private void DrawEverything()
  {  
    Collections.sort(centroids);
    Collections.sort(oldCentroids);
  
    for (int i = 0; i < centroids.size(); i++)
    {
      DrawLines(i);    
      centroids.get(i).DrawCentroid();
      DrawText(i);
    }
    
    if(isVisible) 
    {
      for (int i = 0; i < particles.size(); i++) 
      {
        Particle p = (Particle) particles.get(i); 
        p.DrawParticle();   
      } 
    } 
    
    isDrawn = true;
  }
  
  void DrawLines(int i)
  {
    if (i < centroids.size() - 1)
    {
      stroke(255);
      line(centroids.get(i).components.x, centroids.get(i).components.y, 
        centroids.get(i+1).components.x, centroids.get(i+1).components.y);
    }
  }
  
  void DrawText(int i) 
  {
    fill(255);
    text(i, centroids.get(i).components.x, centroids.get(i).components.y);
  }
  
  // ------------ NOT SO VOID METHODS ------------ //  
  private boolean Equals(ArrayList<Centroid> otherCentroids, ArrayList<Centroid> centroids)
  {
    if (otherCentroids.size() != centroids.size()) return false;
  
    for (int i = 0; i < centroids.size(); i++)
    {
      if (abs(otherCentroids.get(i).components.x - centroids.get(i).components.x) > threshold ||
        abs(otherCentroids.get(i).components.y - centroids.get(i).components.y) > threshold ||
        abs(otherCentroids.get(i).components.z - centroids.get(i).components.z) > threshold)
      {
        return false;
      }
    }
    return true;
  }
}
