class Centroid 
{
  PVector components;
  float R, G, B;
  int internalIndex;
  int numParticles;
  
  Centroid (PVector components, int index, float r, float g, float b)
  {
    this.components = new PVector(components.x, components.y, components.z);    
    internalIndex = index;
    
    R = r;
    G = g;
    B = b;        
  }
  
  void Tick(ArrayList particles)
  {
    PVector newComponents = new PVector();

    numParticles = 0;

    for (int i = 0; i < particles.size(); i++)
    {
      Particle p = (Particle) particles.get(i);

      if (p.centroidIndex == internalIndex)
      {
        newComponents.add(p.components); 
        numParticles++;
      }
    }

    if(numParticles != 0)
    {
      newComponents.div(numParticles);
      components = newComponents;
    }    
  }
  
  void DrawCentroid()
  {
    fill(R, G, B);
    
    float radius = 10 + numParticles/2;
    ellipse(components.x, components.y, radius, radius);
  }
}
