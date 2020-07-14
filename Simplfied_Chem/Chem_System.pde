class System{
  ArrayList<Particle> particleList = new ArrayList<Particle>();
  void addParticle(Particle P){
    particleList.add(P);
    P.system=this;
  }
  void draw(){
     for(Particle p:particleList){
        p.draw(); 
     }
  }
  void update(){
    for(Particle p:particleList){
       p.update(); 
    }
  }  
}
