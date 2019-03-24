class Particle 
{
  PVector components;
  float R, G, B;
  int centroidIndex;
  
  Particle (PVector components)
  {
    this.components = new PVector(components.x, components.y, components.z);
  }
  
  void FindClosestCentroid(ArrayList centroids)
  {
    float minDist = 10000;
    int index     = 0;  

    for(int i = 0; i < centroids.size(); i++)
    {
      Centroid c = (Centroid) centroids.get(i);
      float dist = components.dist(c.components);
      
      if(dist < minDist)
      {
        minDist = dist;
        index   = i;
      }
    }
    
    centroidIndex = index;
    Centroid c    = (Centroid) centroids.get(centroidIndex);
    
    R = c.R;
    G = c.G;
    B = c.B;
  }
  
  void DrawParticle()
  {
    fill(R, G, B);
   
    ellipse(components.x, components.y, 5, 5);
  }
}
