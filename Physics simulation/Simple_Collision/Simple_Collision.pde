class Particle{
  PVector Pos;
  PVector Vel;
  PVector Acc;
  float Mass;
  Particle(PVector dPos,PVector dVel,float dMass){
    Pos=dPos; Vel=dVel; Mass=dMass; Acc=PV();
  }
  PVector NextPos(){// returns the next position of particle
    return PVadd(Pos,PVadd(Vel,PVextend(Acc,.5)));
  }
  void UpdatePart(){
    Pos=NextPos();
    Vel=PVadd(Vel,Acc);
    Acc=new PVector(0,0);
  }
  void ApplyForce(PVector F){
    Acc=PVadd(Acc,PVextend(F,1/Mass));
  }
  boolean InFrame(){// CHecks if particle is in the frame.
    return (Pos.x>=0)&&(Pos.x<=width)&&(Pos.y<height);
  }
  void DrawPart(){
    fill(255);
    ellipse(Pos.x,Pos.y,7,7);
  }
}
class Barrier{
  PVector Corner;
  PVector Base;
  float Bounce;
  float Slide;
  Barrier(PVector DCorner,PVector DBase,float DBounce,float DSlide){
    Corner=DCorner; Base=DBase; Bounce= DBounce; Slide = DSlide;
  }
  boolean Collides(Particle Po){// Checks if a particle is going to collide this frame.
    PVector Posr=PVDivide(PVadd(Po.Pos,PVextend(Corner,-1)),Base);
    PVector Nextr=PVDivide(PVadd(Po.NextPos(),PVextend(Corner,-1)),Base);
    return (((Posr.y>0)&&(Nextr.y<0))||((Posr.y<0)&&(Nextr.y>0))
    ||((Posr.y==0)&&(Nextr.y>0))||((Nextr.y==0)&&(Posr.y>0))
    ||((Posr.y==0)&&(Nextr.y==0)))&&
    (BetweenBarrier(Po));
  }
  boolean BetweenBarrier(Particle Po){// checks if the particle is in the middle
    PVector Posr=PVDivide(PVadd(Po.Pos,PVextend(Corner,-1)),Base);
    PVector Nextr=PVDivide(PVadd(Po.NextPos(),PVextend(Corner,-1)),Base);
    return ((Posr.x>=0)&&(Posr.x<=1))||((Nextr.x>=0)&&(Nextr.x<=1));
  }
  
  boolean Rests(Particle Po){ // Checks if a paricle has stopped bouncing and is stable
    Particle PoS= new Particle(Po.Pos,Po.Vel,Po.Mass);
    PoS.Acc=Po.Acc;
    boolean Rest=false;
    if(Collides(PoS)){
      BouncePart(PoS);
      if(Collides(PoS)){
        Rest=true;
      }
    }
    return Rest;
  }
  
  void BouncePart(Particle Po){// Applies bouncy physics
    PVector Rvel=PVDivide(Po.Vel,Base);
    PVector RAcc=PVDivide(Po.Acc,Base);
    RAcc.x*=1+Slide*(Rvel.y+RAcc.y); 
    Rvel.y*=-Bounce;
    Rvel.x*=Slide;
    Po.Vel=PVMult(Rvel,Base);
    Po.Acc=PVMult(RAcc,Base); 
  }
  void StablisePart(Particle Po){// Stableises particle, stops fallthrough
    PVector RVel=PVDivide(Po.Vel,Base);
    RVel.y=0;
    Po.Vel=PVMult(RVel,Base); 
    
    PVector RACc=PVDivide(Po.Acc,Base);
    RACc.y=0;
    Po.Acc=PVMult(RACc,Base); 
  }
  void CheckColl(Particle Po){// Checks and updates particle according to bouncy.
    if(Collides(Po)){
      BouncePart(Po);
      if(Collides(Po)){
        StablisePart(Po);
      }
    }
  }
  void DrawB(){
    line(Corner.x,Corner.y,Corner.x+Base.x,Corner.y+Base.y);
  }
}

ArrayList<Particle> PList=new ArrayList<Particle>();
ArrayList<Barrier> BList=new ArrayList<Barrier>();
void setup(){
    frameRate(60);
    fullScreen();
}
boolean MoreCalc(Particle P){// Sees if any particles are colliding
  Boolean more=false;
  for(int o=0;o<BList.size();o++){
    Barrier B=BList.get(o);
    more=more||B.Collides(P);
  }
  return more;
}
int NumColliding(Particle P){//number of particles colliding
  int coll=0;
  for(int o=0;o<BList.size();o++){
    Barrier B=BList.get(o);
    if(B.Collides(P)){
      coll++;
    }
  }
  return coll;
}

int num=0;
boolean Creating=false;
void draw(){
  PList.add(new Particle(new PVector(10,10),new PVector(0,0),1));
  background(0); 
  fill(255);
  strokeWeight(1);
  text(frameCount,width-50,30);
  text(PList.size(),width-50,40);

  for(int n=0;n<PList.size();n++){// Run through each particle in reverse, so deleting doesn't cause problems
    Particle P=PList.get(PList.size()-n-1);
    P.ApplyForce(new PVector(0,.5*P.Mass));// apply grav
    if((P.InFrame()==false)||(P.Acc==PV())){//delete particle if necicarry
      PList.remove(PList.size()-n-1);
    }
    for(int num=0;(NumColliding(P)>0)&&(num<=NumColliding(P)+2);num++){// RUNS THROU BARRIERS, checks if any is colliding or too many are colliding
      //if(num>NumColliding(P)+1){
      //  PList.remove(PList.size()-n-1);
      //  P.Acc=new PVector(0,0);//STABLEISE
      //  P.Vel=new PVector(0,0);
      //}
      for(int o=0;o<BList.size();o++){
        Barrier B=BList.get(o);
        B.CheckColl(P);// CALC COLL
      }
    }
    P.UpdatePart();// update
    P.DrawPart();
  }
  strokeWeight(10);
  stroke(255);
  for(int n=0;n<PList.size()-1;n++){// DRAW LINES
    Particle P=PList.get(n);
    Particle O=PList.get(n+1);
    if(dist(P.Pos.x,P.Pos.y,O.Pos.x,O.Pos.y)<150){
    line(P.Pos.x,P.Pos.y,O.Pos.x,O.Pos.y);
    }
  }
  strokeWeight(1);
  for(int n=0;n<BList.size();n++){ // DRAW BARRIERS
    Barrier B=BList.get(n);
    B.DrawB();
  }
 
  if(Creating==false){
    if(mousePressed){
      BList.add(new Barrier(new PVector(mouseX,mouseY),new PVector(),1,1));
      Creating=true;
    }
  }else{
    if(mousePressed){
      BList.get(BList.size()-1).Base=PVadd(new PVector(mouseX,mouseY),PVneg(BList.get(BList.size()-1).Corner));
    }else{
      Creating=false;
    }
  }
}
//void mousePressed(){
//  BList.get(0).Base=new PVector(mouseX-BList.get(0).Corner.x,mouseY-BList.get(0).Corner.y);
//  BList.get(1).Base=new PVector(mouseX-BList.get(1).Corner.x,mouseY-BList.get(1).Corner.y);
//}