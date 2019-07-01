import java.util.*;
PVector GRAV=new PVector(0,0.01);
int SPEED=1;

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
    //Collections.sort(Particles);
    //float pow=0;
    //float skew=1;
    float actualKinetic= TotKinetic();
    float targetKinetic= energy-TotPotential();
    
    //float integ=(pow(skew+1,pow+1)-pow(skew,pow+1))/(pow+1);
    for(int i=0;i<Particles.size();i++){//Fix velocities to conserve energy
      //float rank=((float) i)/(Particles.size()-1);
      float scale=max(targetKinetic/actualKinetic,0);//*pow(rank+skew,pow)/integ;
      scale=sqrt(scale);
      
      Particles.get(i).vel=PVscale(Particles.get(i).vel,scale);
      Particles.get(i).angVel*=scale;
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
  size(850,850,P2D);
  //fullScreen();
  //ACTRAD= new float[NUMTYPES];

  //FORCES=new float[NUMTYPES][NUMTYPES];
  //Set();

  
  Particles=new ArrayList<Particle>();
  //for(int i=0;i<200;i++){
  //  PVector Pos= new PVector(random(0,1)*width,random(0.5,1)*height)
  //  float charge= random(1)>0.5? 50:-50;
  //  Particles.add(new Particle(Pos,new PVector(randomGaussian()*0.01,randomGaussian()*0.01),15,5,charge,0,0.1,0.1,1));
  //}
  
  for(int i=0; i<0;i++){
    PVector Pos= new PVector(random(0,1)*width,random(0,1)*height);
    Particle A=new Particle(new PVector(Pos.x,Pos.y),new PVector(0,0.01),10,10,25
    ,-2,0,1,20,
    30,0,0.3,2);
    
    Particle B=new Particle(new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),15,10,-50
    ,-2,0,1,20,
    30,1.4,0.3,2,
    A);
    
    Particle C=new Particle(new PVector(Pos.x-60,Pos.y),new PVector(0,0.01),10,10,25
    ,-2,0,1,20,
    30,0,0.3,2,
    B);
    
    Particles.add(A);
    Particles.add(B);
    Particles.add(C);
  }
  
  //for(int i=0; i<2;i++){
  //  Particles.add(new Particle(new PVector(300-30*(i+1),100),new PVector(0,0.01),30,5,0
  //  ,-2,0,0.1,10000,
  //  80,0,0.1,100,
  //  Particles.get(i)));
  //}
  

  energy= TotEnergy()+40;
  //Particles.add(new Particle(new PVector(width/2,height/2),new PVector(randomGaussian()*10,randomGaussian()*10),30,20));
  //Particles.add(new Particle(new PVector(100,100),new PVector(5,0),15,5));
  //Particles.add(new Particle(new PVector(200,100),new PVector(0,0),15,5));
}
void draw(){
  background(0);

  for(Particle P:Particles){
    P.Draw();
  }
  for(int s=0;s<SPEED;s++){
    for(int i=0;i<Particles.size();i++){
      for(int j=0; j<i;j++){
        Particles.get(i).Affect(Particles.get(j)); 
      }
      Particles.get(i).CollideWall();
    }
    
  
    for(int i=0; i<Particles.size(); i++){
       Particles.get(i).UpdateVel();
    }
    for(int i=0;i<Particles.size();i++){
      for(int j=0; j<i;j++){
        Particles.get(i).Collide(Particles.get(j)); 
      }
    }
    
    RescaleVel();
    for(int i=0; i<Particles.size(); i++){
       Particles.get(i).UpdatePos();
    }
  }
   
   
  if(keyPressed){
    if(key=='a'){
      if(energy-100>TotPotential()){
        energy-=100; 
      }
    }
    if(key=='s'){
        energy+=100;
    }
  }
  
  fill(255);
  text(TotEnergy(),10,10);
  text("->"+energy,130,10);
  text("SPEED:"+SPEED,width-80,10);
  
}

void keyPressed(){
   PVector Pos= new PVector(mouseX,mouseY);
   if(key=='q'){
        Particles.add(new Particle(Pos,new PVector(randomGaussian()*2,randomGaussian()*2),50,45,70
      ,random(0,TWO_PI),random(-0.2,0.2),0.1,40,
      80,0,0.1,2));
      energy=TotEnergy();
    }
    if(key=='w'){
        Particles.add(new Particle(Pos,new PVector(randomGaussian()*2,randomGaussian()*2),50*(1.415-1),45,-70
      ,random(0,TWO_PI),random(-0.2,0.2),0.1,30,
      80,0,0.1,2)); 
      energy=TotEnergy();
    }
    if(key=='e'){
       Particle A=new Particle(new PVector(Pos.x,Pos.y),new PVector(0,0.01),10,10,25
      ,-2,0,1,20,
      30,0,0.3,2);
      
      Particle B=new Particle(new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),15,10,-50
      ,-2,0,1,20,
      30,1.4,0.3,2,
      A);
      
      Particle C=new Particle(new PVector(Pos.x-60,Pos.y),new PVector(0,0.01),10,10,25
      ,-2,0,1,20,
      30,0,0.3,2,
      B);
      
      Particles.add(A);
      Particles.add(B);
      Particles.add(C);
      energy=TotEnergy();
    }
    if(keyCode==RIGHT){
      SPEED++;
    }
    if(keyCode==LEFT){
      SPEED--; 
    }
}
void mousePressed(){
   
   //if(keyPressed){
   // float charge= random(1)>0.6? 60:-60;
   // if(charge>0){
   //   Particles.add(new Particle(Pos,new PVector(randomGaussian()*2,randomGaussian()*2),30,50,charge
   //   ,random(0,TWO_PI),random(-0.2,0.2),0.1,40,
   //   80,0,0.1,2));
   // }else{
   //   Particles.add(new Particle(Pos,new PVector(randomGaussian()*2,randomGaussian()*2),15,50,charge
   //   ,random(0,TWO_PI),random(-0.2,0.2),0.1,30,
   //   80,0,0.1,2)); 
   // } 
   //}else{
   // Particle A=new Particle(new PVector(Pos.x,Pos.y),new PVector(0,0.01),10,10,25
   // ,-2,0,1,20,
   // 30,0,0.3,2);
    
   // Particle B=new Particle(new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),15,10,-50
   // ,-2,0,1,20,
   // 30,1.4,0.3,2,
   // A);
    
   // Particle C=new Particle(new PVector(Pos.x-60,Pos.y),new PVector(0,0.01),10,10,25
   // ,-2,0,1,20,
   // 30,0,0.3,2,
   // B);
    
   // Particles.add(A);
   // Particles.add(B);
   // Particles.add(C);
   //}
   //energy=TotEnergy();
 //22Set(); 
 //Particles.add(new Particle(new PVector(mouseX,mouseY),new PVector(randomGaussian()*10,randomGaussian()*10),30,20));
}