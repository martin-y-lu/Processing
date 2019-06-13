//int NUMTYPES=9;

//float[] ACTRAD;//{100,100,100};
//float[][] FORCES;//={{0,1,-1},{-1,0,1},{1,-1,0}};//;//
//int[] COLORS= {color(255,0,0),color(0,255,0),color(0,0,255),color(255,255,0),color(255,0,255),color(0,255,255),color(120,120,255),color(120,225,120),color(255,120,120)};
//float FRICT=0.7;

ArrayList<Particle> Particles;
float energy=0;
float TotEnergy(){
  float totEnergy=0;
  for(int i=0;i<Particles.size();i++){
   totEnergy+=Particles.get(i).energy(); 
  }
  return totEnergy;
}
float TotPotential(){
  float totPot=0;
  for(int i=0;i<Particles.size();i++){
   totPot+=Particles.get(i).potential(); 
  }
  return totPot;
}
float TotKinetic(){
  float totKin=0;
  for(int i=0;i<Particles.size();i++){
   totKin+=Particles.get(i).kinetic(); 
  }
  return totKin;
}
void RescaleVel(){
    float actualKinetic= TotKinetic();
    float targetKinetic= energy-TotPotential();
    float scale=sqrt(max(targetKinetic/actualKinetic,0));
    for(int i=0;i<Particles.size();i++){//Fix velocities to conserve energy
      Particles.get(i).vel=PVscale(Particles.get(i).vel,scale);
    }
}

void Set(){
  //for(int i=0;i<NUMTYPES;i++){
  // ACTRAD[i]=abs(80+randomGaussian()*10); 
  //}
  //for(int i=0;i<NUMTYPES;i++){
  //  for(int j=0;j<NUMTYPES;j++){
  //    if(i!=j){
  //     FORCES[i][j]=randomGaussian()*20.0; 
  //    }else{
  //      FORCES[i][j]=randomGaussian()*16.0; 
  //    }
  //  }
  //}
  
}
void setup() {
  size(600,600,P2D);
  //fullScreen();
  //ACTRAD= new float[NUMTYPES];

  //FORCES=new float[NUMTYPES][NUMTYPES];
  //Set();

  
  Particles=new ArrayList<Particle>();
  for(int i=0;i<200;i++){
    PVector Pos= new PVector(random(0,1)*width,random(0.5,1)*height);
    float charge= random(1)>0.5? 50:-50;
    Particles.add(new Particle(Pos,new PVector(randomGaussian()*0.01,randomGaussian()*0.01),15,5,charge));
  }
  energy= TotEnergy();
  //Particles.add(new Particle(new PVector(width/2,height/2),new PVector(randomGaussian()*10,randomGaussian()*10),30,20));
  //Particles.add(new Particle(new PVector(100,100),new PVector(5,0),15,5));
  //Particles.add(new Particle(new PVector(200,100),new PVector(0,0),15,5));
}
void draw(){
  background(0);

  
  for(Particle P:Particles){
    P.Draw();
  }
  for(int i=0;i<Particles.size();i++){
    for(int j=0; j<i;j++){
      Particles.get(i).Affect(Particles.get(j)); 
    }
  }
  for(int i=0; i<Particles.size(); i++){
     Particles.get(i).Update(); 
     Particles.get(i).CollideWall(); 
  }
  
  if(keyPressed){
    if(key=='a'){
      if(energy-20>TotPotential()){
        energy-=20; 
      }
    }
  }
  
  RescaleVel();
  fill(255);
  text(TotEnergy(),10,10);
  text("->"+energy,80,10);
}
void mousePressed(){
   PVector Pos= new PVector(mouseX,mouseY);
    float charge= random(1)>0.5? 100:-100;
    Particles.add(new Particle(Pos,new PVector(randomGaussian()*0.1,randomGaussian()*0.1),15,5,charge));
    energy=TotEnergy();
 //22Set(); 
 //Particles.add(new Particle(new PVector(mouseX,mouseY),new PVector(randomGaussian()*10,randomGaussian()*10),30,20));
}