import java.util.*;
//PVector GRAV=new PVector(0,0.01);
//int SPEED=1;

//int NUMTYPES=9;

//float[] ACTRAD;//{100,100,100};
//float[][] FORCES;//={{0,1,-1},{-1,0,1},{1,-1,0}};//;//
//int[] COLORS= {color(255,0,0),color(0,255,0),color(0,0,255),color(255,255,0),color(255,0,255),color(0,255,255),color(120,120,255),color(120,225,120),color(255,120,120)};
//float FRICT=0.7;

//ArrayList<Particle> Particles;
////float energy=0;

//PVector EField(PVector Pos){
//  PVector field= new PVector(0,0);
//  for( Particle P: Particles){
//    field= PVadd(field,P.Field(Pos));
//  }
//  return field;
//}

//float TotEnergy(){
//  float totEnergy=0;
//  for(int i=0;i<Particles.size();i++){
//   totEnergy+=Particles.get(i).energy(); 
//  }
//  return totEnergy;
//}
//float TotPotential(){
//  float totPot=0;
//  for(int i=0;i<Particles.size();i++){
//   totPot+=Particles.get(i).potential(); 
//  }
//  return totPot;
//}
//float TotKinetic(){
//  float totKin=0;
//  for(int i=0;i<Particles.size();i++){
//   totKin+=Particles.get(i).kinetic(); 
//  }
//  return totKin;
//}
//void RescaleVel(){
//    //Collections.sort(Particles);
//    //float pow=0;
//    //float skew=1;
//    float actualKinetic= TotKinetic();
//    float targetKinetic= energy-TotPotential();
    
//    //float integ=(pow(skew+1,pow+1)-pow(skew,pow+1))/(pow+1);
//    for(int i=0;i<Particles.size();i++){//Fix velocities to conserve energy
//      //float rank=((float) i)/(Particles.size()-1);
//      float scale=max(targetKinetic/actualKinetic,0);//*pow(rank+skew,pow)/integ;
//      scale=sqrt(scale);
      
//      Particles.get(i).vel=PVscale(Particles.get(i).vel,scale);
//      Particles.get(i).angVel*=scale;
//    }
//}

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

ChemSys System;
Cam Camera= new Cam(new PVector(0,0),1);
ArrayList<PartType> Types;
PartType Hydro= new PartType(/*Type*/0,/*radius*/8,/*mass*/5,/*charge*/10,/*mom inert*/20,/*bond length*/30,/*Bond angle*/0,/*Bond K*/0.5,/*Bond ang K*/2);
PartType Oxy=   new PartType(/*Type*/1,/*radius*/15,/*mass*/16,/*charge*/-20,/*mom inert*/20,/*bond length*/30,/*Bond angle*/1.4,/*Bond K*/0.5,/*Bond ang K*/2);
//PartType Sodi=  new PartType(/*Type*/2,/*radius*/50,/*mass*/45,/*charge*/100,/*mom inert*/40,/*bond length*/80,/*Bond angle*/0,/*Bond K*/0.1,/*Bond ang K*/2);
//PartType Chlori= new PartType(/*Type*/3,/*radius*/50*(1.415-1),/*mass*/45,/*charge*/-100,/*mom inert*/30,/*bond length*/80,/*Bond angle*/0,/*Bond K*/0.1,/*Bond ang K*/2);
PartType Adi= new PartType(/*Type*/2,/*radius*/45,/*mass*/80,/*charge*/0,/*mom inert*/60,/*bond length*/100,/*Bond angle*/0,/*Bond K*/0.7,/*Bond ang K*/8.0);
PartType Thymo= new PartType(/*Type*/3,/*radius*/45,/*mass*/80,/*charge*/0,/*mom inert*/60,/*bond length*/100,/*Bond angle*/0,/*Bond K*/0.7,/*Bond ang K*/8.0);
PartType Cyto= new PartType(/*Type*/4,/*radius*/45,/*mass*/80,/*charge*/0,/*mom inert*/60,/*bond length*/100,/*Bond angle*/0,/*Bond K*/0.7,/*Bond ang K*/8.0);
PartType Guani= new PartType(/*Type*/5,/*radius*/45,/*mass*/80,/*charge*/0,/*mom inert*/60,/*bond length*/100,/*Bond angle*/0,/*Bond K*/0.7,/*Bond ang K*/8.0);

void setup() {
  
  size(850,850,P2D);
  //fullScreen();
  //ACTRAD= new float[NUMTYPES];

  //FORCES=new float[NUMTYPES][NUMTYPES];
  //Set();
  Types= new ArrayList<PartType> ();
  Types.add(Hydro);  
  Types.add(Oxy);
  Types.add(Adi);
  Types.add(Thymo);
  Types.add(Cyto);
  Types.add(Guani);
  
  float[][] hBondRadius= {{0,40,70,70,70,70}
                         ,{40,0,0,0,0,0}
                         ,{70, 0,0,130,0,0}
                         ,{70,0,130,0,0,0}
                         ,{70,0,0,0,0,130}
                         ,{70,0,0,0,130,0}};
  float[][] hBondForce=  {{0,0.6,0.3,0.3,0.3,0.3}
                         ,{0.6,0,0,0,0,0}
                         ,{0.3, 0,0,0.9,0,0}
                         ,{ 0.3,0,0.9,0,0,0}
                         ,{ 0.3,0,0,0,0,0.9}
                         ,{ 0.3,0,0,0,0.9,0}};
  System= new ChemSys(Types,hBondRadius,hBondForce,new PVector(1200,1000));
  
  //ArrayList<Particle> Particles=new ArrayList<Particle>();
  Particle A1=Adi.Gen(System,new PVector(100,100),new PVector(0,0.01),-2,0.0,1.0);
  Particle A2=Guani.Gen(System,new PVector(100+50,100),new PVector(0,0.01),-2,0.0,1.0,A1);
  Particle A3=Thymo.Gen(System,new PVector(100+50+50,100),new PVector(0,0.01),-2,0.0,1.0,A2);
  Particle A4=Cyto.Gen(System,new PVector(100+50+50+50,100),new PVector(0,0.01),-2,0.0,1.0,A3);
  Particle A5=Adi.Gen(System,new PVector(100+50+50+50+50,100),new PVector(0,0.01),-2,0.0,1.0,A4);
  Particle A6=Guani.Gen(System,new PVector(100+50+50+50+50+50,100),new PVector(0,0.01),-2,0.0,1.0,A5);
  System.Particles.add(A1);
  System.Particles.add(A2);
  System.Particles.add(A3);
  System.Particles.add(A4);
  System.Particles.add(A5);
  System.Particles.add(A6);
    
  //for(int i=0; i<0;i++){
  //  PVector Pos= new PVector(random(0,1)*width,random(0,1)*height);
  //  Particle A=Hydro.Gen(new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0);
  //  Particle B=Oxy.Gen(new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),-2,0,1,A); 
  //  Particle C=Hydro.Gen(new PVector(Pos.x-60,Pos.y),new PVector(0,0.01),-2,0,1,B);
  //  Particles.add(A);
  //  Particles.add(B);
  //  Particles.add(C);
  //}
  //for(int i=0;i<200;i++){
  //  PVector Pos= new PVector(random(0,1)*width,random(0.5,1)*height)
  //  float charge= random(1)>0.5? 50:-50;
  //  Particles.add(new Particle(Pos,new PVector(randomGaussian()*0.01,randomGaussian()*0.01),15,5,charge,0,0.1,0.1,1));
  //}
  
  //for(int i=0; i<0;i++){
  //  PVector Pos= new PVector(random(0,1)*width,random(0,1)*height);
  //  Particle A=new Particle(new PVector(Pos.x,Pos.y),new PVector(0,0.01),10,10,25
  //  ,-2,0,1,20,
  //  30,0,0.3,2);
    
  //  Particle B=new Particle(new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),15,10,-50
  //  ,-2,0,1,20,
  //  30,1.4,0.3,2,
  //  A);
    
  //  Particle C=new Particle(new PVector(Pos.x-60,Pos.y),new PVector(0,0.01),10,10,25
  //  ,-2,0,1,20,
  //  30,0,0.3,2,
  //  B);
    
  //  Particles.add(A);
  //  Particles.add(B);
  //  Particles.add(C);
  //}
  
  //for(int i=0; i<2;i++){
  //  Particles.add(new Particle(new PVector(300-30*(i+1),100),new PVector(0,0.01),30,5,0
  //  ,-2,0,0.1,10000,
  //  80,0,0.1,100,
  //  Particles.get(i)));
  //}
  

  System.ENERGY= System.TotEnergy()+40;
  //Particles.add(new Particle(new PVector(width/2,height/2),new PVector(randomGaussian()*10,randomGaussian()*10),30,20));
  //Particles.add(new Particle(new PVector(100,100),new PVector(5,0),15,5));
  //Particles.add(new Particle(new PVector(200,100),new PVector(0,0),15,5));
}
void draw(){
  background(0);
  System.Draw(Camera);
  System.Update();
   
   
  if(keyPressed){
    if(key=='a'){
      if(System.ENERGY-100>System.TotPotential()){
        System.ENERGY-=100; 
      }
    }
    if(key=='s'){
        System.ENERGY+=100;
    }
  }
  textSize(18);
  fill(255);
  text(System.TotEnergy(),10,20);
  text("->"+System.ENERGY,130,20);
  text("SPEED:"+System.SPEED,width-100,20);
  if( keyPressed){
    if(keyCode==RIGHT){
       Camera.Pos= new PVector(Camera.Pos.x+8*Camera.Scale,Camera.Pos.y); 
    }
    if(keyCode==LEFT){
       Camera.Pos= new PVector(Camera.Pos.x-8*Camera.Scale,Camera.Pos.y); 
    }
    if(keyCode==UP){
       Camera.Pos= new PVector(Camera.Pos.x,Camera.Pos.y-8*Camera.Scale); 
    }
    if(keyCode==DOWN){
       Camera.Pos= new PVector(Camera.Pos.x,Camera.Pos.y+8*Camera.Scale); 
    }
  }
  
}

void keyPressed(){
   PVector Pos= Camera.ScreenToReal(new PVector(mouseX,mouseY));
   if(key=='q'){
      System.AddParticle(Adi.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='w'){
      System.AddParticle(Thymo.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='e'){
      System.AddParticle(Cyto.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0));
    }
    if(key=='r'){
      System.AddParticle(Guani.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0));
      
    }
    if(key=='t'){
      Particle A=Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0);
      Particle B=Oxy.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),-2,0,1,A); 
      Particle C=Hydro.Gen(System,new PVector(Pos.x-60,Pos.y),new PVector(0,0.01),-2,0,1,B);
      System.AddParticle(A);
      System.AddParticle(B);
      System.AddParticle(C);
      System.FixEnergy();
    }
    if(key=='d'){
      System.SPEED++;
    }
    if(key=='f'){
      System.SPEED--; 
    }
    if(key==','){
      Camera.Scale/=1.2; 
    }
    if(key=='.'){
      Camera.Scale*=1.2;
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