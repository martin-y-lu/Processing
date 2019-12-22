import java.util.*;
// TODO: 1) Fix Covaalent bonding- issues: fixed
          // 1)/ Add double/triple/quadruple bondi
  //        2)  Add ionic bonding/ charge and stuff 
  //         3) become god
  

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
Cam Camera= new Cam(new PVector(-15,-20),1);
ArrayList<PartType> Types;
PartType Hydro= new PartType(/*Type*/0,/*radius*/8,/*mass*/15,/*charge*/1,/*mom inert*/15,/*Bond angles*/new float[]{0},/*Bond ang K*/new float[]{0.2});
PartType Oxy=   new PartType(/*Type*/1,/*radius*/15,/*mass*/30,/*charge*/-2,/*mom inert*/15,/*Bond angles*/new float[]{3.14,1.8},/*Bond ang K*/new float[]{0.2,0.2});
PartType Sodi=  new PartType(/*Type*/2,/*radius*/40,/*mass*/45,/*charge*/0,/*mom inert*/40,/*Bond angle*/new float[]{0},/*Bond K*/new float[]{2});
PartType Chlori= new PartType(/*Type*/3,/*radius*/60,/*mass*/45,/*charge*/0,/*mom inert*/30,/*Bond angle*/new float[]{0},/*Bond K*/new float[]{2});
PartType Carbo=   new PartType(/*Type*/4,/*radius*/20,/*mass*/30,/*charge*/0,/*mom inert*/15,/*Bond angles*/new float[]{0,PI*0.5,PI,PI*1.5},/*Bond ang K*/new float[]{0.20,0.20,0.20,0.20});
PartType Adi= new PartType(/*Type*/5,/*radius*/30,/*mass*/80,/*charge*/0,/*mom inert*/60,/*Bond angle*/new float[]{0},/*Bond ang K*/new float[]{0.2});
PartType Ura= new PartType(/*Type*/6,/*radius*/30,/*mass*/80,/*charge*/0,/*mom inert*/60,/*Bond angle*/new float[]{0},/*Bond ang K*/new float[]{0.2});
PartType Cyto= new PartType(/*Type*/7,/*radius*/30,/*mass*/80,/*charge*/0,/*mom inert*/60,/*Bond angle*/new float[]{0},/*Bond ang K*/new float[]{0.2});
PartType Guani= new PartType(/*Type*/8,/*radius*/30,/*mass*/80,/*charge*/0,/*mom inert*/60,/*Bond angle*/new float[]{0},/*Bond ang K*/new float[]{0.2});
PartType Ribo= new PartType(/*Type*/9,/*radius*/35,/*mass*/80,/*charge*/0,/*mom inert*/60,/*Bond angle*/new float[]{0-0.6,0.5*PI,PI+0.6},/*Bond ang K*/new float[]{0.6,0.6,0.6});
PartType Phosph=   new PartType(/*Type*/10,/*radius*/15,/*mass*/30,/*charge*/0,/*mom inert*/15,/*Bond angles*/new float[]{0,PI},/*Bond ang K*/new float[]{0.2,0.2});

//PartType Thymo= new PartType(/*Type*/3,/*radius*/45,/*mass*/80,/*charge*/0,/*mom inert*/60,/*bond length*/100,/*Bond angle*/0,/*Bond K*/0.7,/*Bond ang K*/8.0);
//PartType Cyto= new PartType(/*Type*/4,/*radius*/45,/*mass*/80,/*charge*/0,/*mom inert*/60,/*bond length*/100,/*Bond angle*/0,/*Bond K*/0.7,/*Bond ang K*/8.0);
//PartType Guani= new PartType(/*Type*/5,/*radius*/45,/*mass*/80,/*charge*/0,/*mom inert*/60,/*bond length*/100,/*Bond angle*/0,/*Bond K*/0.7,/*Bond ang K*/8.0);
void setup() {
  
  size(1300,850,P2D);
  //fullScreen();
  //ACTRAD= new float[NUMTYPES];

  //FORCES=new float[NUMTYPES][NUMTYPES];
  //Set();
    
  //HYDRO OXY ADI THYMO CYTO GUANI
  //float[][] hBondRadius= {{0,40,70,70,70,70}
  //                       ,{40,0,0,0,0,0}
  //                       ,{70, 0,0,130,0,0}
  //                       ,{70,0,130,0,0,0}
  //                       ,{70,0,0,0,0,130}
  //                       ,{70,0,0,0,130,0}};
  //float[][] hBondForce=  {{0,0.6,0.3,0.3,0.3,0.3}
  //                       ,{0.6,0,0,0,0,0}
  //                       ,{0.3, 0,0,0.9,0,0}
  //                       ,{ 0.3,0,0.9,0,0,0}
  //                       ,{ 0.3,0,0,0,0,0.9}
  //                       ,{ 0.3,0,0,0,0.9,0}};                  
  
  //HYDRO OOXY SODI CHLORI CARBO
  //float[][] hBondRadius= {{0,35,0,0,0}
  //                       ,{35,0,0,0,0}
  //                       ,{0 ,0,0,0,0}
  //                       ,{0 ,0,0,0,0}
  //                       ,{0 ,0,0,0,0}};
  //float[][] hBondForce=  {{0,0.04,0,0,0}
  //                       ,{0.04,0,0,0,0}
  //                       ,{0   ,0,0,0,0}
  //                       ,{0   ,0,0,0,0}
  //                       ,{0   ,0,0,0,0}};
  //float[][] cBondLength= {{20,30,0,0,30}
  //                       ,{30,30,0,0,30}
  //                       ,{0 ,0,0,60,0}
  //                       ,{0 ,0,60,0,0}
  //                       ,{30 ,30,0 ,0,0}};
  //float[][] cBondK     = {{0.06,0.25,0  ,0  ,0.2},
  //                        {0.25,0.1 ,0  ,0  ,0},
  //                        {0   ,0   ,0  ,0.2,0}
  //                       ,{0   ,0   ,0.2,0  ,0}
  //                       ,{0.2 ,0 ,0  ,0  ,0}};
  //float[][] cBondEnergy= {{10,60,0 ,0 ,40},
  //                        {60,25,0 ,0 ,20},
  //                        {0 ,0 ,0 ,20,0},
  //                        {0 ,0 ,20,0 ,0}
  //                       ,{40,20 ,0 ,0 ,0}};
  // float[][] cBondExtra= {{0,0,0,0,0},
  //                        {0,25,0,0,0},
  //                        {0 ,0,0,0,0},
  //                        {0 ,0,0,0,0}
  //                       ,{0 ,0,0,0,5}};
  //float[][] cActivation= {{3  ,4  ,0   ,0  ,2},
  //                        {4  ,3  ,0   ,0  ,3},
  //                        {0  ,0  ,0   ,60 ,0},
  //                        {0  ,0  ,60  ,0  ,0}
  //                       ,{2  ,3  ,0   ,0  ,0}};
  
  Types= new ArrayList<PartType> ();
  Types.add(Hydro);  
  Types.add(Oxy);
  Types.add(Sodi);
  Types.add(Chlori);
  Types.add(Carbo);
  Types.add(Adi);
  Types.add(Ura);
  Types.add(Cyto);
  Types.add(Guani);
  Types.add(Ribo);
  Types.add(Phosph);
  
  String[] Symbols= new String[]{"H","O","Na","Cl","C","Adi","Ura","Cyt","Gua","Ribo","PO4"};

  //System= new ChemSys(Types,Symbols,hBondRadius,hBondForce,cBondLength,cBondK,cBondEnergy,cBondExtra,cActivation,new PVector(600,400));
  System= new ChemSys(Types,Symbols,new PVector(800,800));
  /* H <-> H */System.SetCovalentBond(0,0,/*bond length*/20.0,/*bond k*/0.06,/*bond energy*/10.0,/*bond extra*/0.0,/*Activation*/3.0);
  /* H <-> O */System.SetCovalentBond(0,1,/*bond length*/30.0,/*bond k*/0.25,/*bond energy*/50,/*bond extra*/0.0,/*Activation*/4.0);
  /* O <-> O */System.SetCovalentBond(1,1,/*bond length*/30.0,/*bond k*/0.1,/*bond energy*/25,/*bond extra*/25,/*Activation*/3.0);
  /* O <-> C */System.SetCovalentBond(1,4,/*bond length*/35.0,/*bond k*/0.2,/*bond energy*/55,/*bond extra*/10,/*Activation*/4.0);
  /* H <-> C */System.SetCovalentBond(0,4,/*bond length*/30.0,/*bond k*/0.2,/*bond energy*/22,/*bond extra*/0,/*Activation*/5.0); 
  /* C <-> C */System.SetCovalentBond(4,4,/*bond length*/45.0,/*bond k*/0.2,/*bond energy*/22,/*bond extra*/-5,/*Activation*/9.0);
  
  ///* Adi<-> Ura */ System.SetCovalentBond(5,6,/*bond length*/100,/*bond k*/0.2,/*bond energy*/70,/*bond extra*/-20,/*Activation*/9.0);
  ///* Adi<-> Cyt */ System.SetCovalentBond(5,7,/*bond length*/100,/*bond k*/0.2,/*bond energy*/70,/*bond extra*/-20,/*Activation*/9.0);
  ///* Adi<-> Gua */ System.SetCovalentBond(5,8,/*bond length*/100,/*bond k*/0.2,/*bond energy*/70,/*bond extra*/-20,/*Activation*/9.0);
  ///* Ura<-> Cyt */ System.SetCovalentBond(6,7,/*bond length*/100,/*bond k*/0.2,/*bond energy*/70,/*bond extra*/-20,/*Activation*/9.0);
  ///* Ura<-> Gua */ System.SetCovalentBond(6,8,/*bond length*/100,/*bond k*/0.2,/*bond energy*/70,/*bond extra*/-20,/*Activation*/9.0);
  ///* Cyt<-> Gua */ System.SetCovalentBond(7,8,/*bond length*/100,/*bond k*/0.2,/*bond energy*/70,/*bond extra*/-20,/*Activation*/9.0);
  ///* Adi<-> H */ System.SetCovalentBond(5,0,/*bond length*/100,/*bond k*/0.2,/*bond energy*/20,/*bond extra*/0,/*Activation*/9.0);
  
  ///* Ura<-> H */ System.SetCovalentBond(5,0,/*bond length*/55,/*bond k*/0.2,/*bond energy*/20,/*bond extra*/0,/*Activation*/9.0);
  ///* <-> H */ System.SetCovalentBond(6,0,/*bond length*/55,/*bond k*/0.2,/*bond energy*/20,/*bond extra*/0,/*Activation*/9.0);
  ///* <-> H */ System.SetCovalentBond(7,0,/*bond length*/55,/*bond k*/0.2,/*bond energy*/20,/*bond extra*/0,/*Activation*/9.0);
  ///* <-> H */ System.SetCovalentBond(8,0,/*bond length*/55,/*bond k*/0.2,/*bond energy*/20,/*bond extra*/0,/*Activation*/9.0);
  
  /* Adi <-> Ribose*/ System.SetCovalentBond(5,9,/*bond length*/60.0,/*bond k*/0.2,/*bond energy*/120,/*bond extra*/-5,/*Activation*/9.0);
  /* Ura <-> Ribose*/ System.SetCovalentBond(6,9,/*bond length*/60.0,/*bond k*/0.2,/*bond energy*/120,/*bond extra*/-5,/*Activation*/9.0);
  /* Cyto <-> Ribose*/ System.SetCovalentBond(7,9,/*bond length*/60.0,/*bond k*/0.2,/*bond energy*/120,/*bond extra*/-5,/*Activation*/9.0);
  /* Guani <-> Ribose*/ System.SetCovalentBond(8,9,/*bond length*/60.0,/*bond k*/0.2,/*bond energy*/120,/*bond extra*/-5,/*Activation*/9.0);
  
  /*Ribose <-> Phosphate*/ System.SetCovalentBond(9,10,/*bond length*/60,/*bond k*/0.2,/*bond energy*/40,/*bond extra*/-20,/*Activation*/9.0);
  
  
  /* H <...> O */System.SetHydrogenBond(0,1,/*bond radius*/35.0,/*bond force*/0.04);
  
  /* Adi <...> Ura*/System.SetHydrogenBond(5,6,/*bond radius*/150,/*bond force*/0.15);
  /* Cyto <...> Guani */System.SetHydrogenBond(7,8,/*bond radius*/150,/*bond force*/0.15);
  ///* Ribose <...> Ribose */System.SetHydrogenBond(9,9,/*bond radius*/150,/*bond force*/0.15);
  
  
  //Particle S=Sodi.Gen(System,new PVector(100,100),new PVector(0,0.01),-2.0,0.0,1.0);
  //Particle C=Chlori.Gen(System,new PVector(200,100),new PVector(0,0.01),-2.0,0.0,1.0);
  //System.Particles.add(S);
  //System.Particles.add(C);
  //System.AddBondBetween(S,0,C,0);
  PVector Pos=new PVector(000,700); 
  Particle P0;
  Particle A1;
  Particle R1=Ribo.Gen(System,/* Position */new PVector(Pos.x,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,        0.0,0.0);;
  Particle P1;
  for( int i=0; i<6;i++){
    Pos=new PVector(Pos.x+120,Pos.y);
    
    P0=Phosph.Gen(System,/* Position */new PVector(Pos.x-60,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0);
    if( i>0){
      System.AddBondBetween(R1,0,P0,1); 
    }
    A1=Adi.Gen(System,/* Position */new PVector(Pos.x,Pos.y-60),/* Velocity */new PVector(0,0.01),/* Angle */0,         0.0,0.0);
    R1=Ribo.Gen(System,/* Position */new PVector(Pos.x,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,        0.0,0.0);
    
    
    System.AddBondBetween(P0,0,R1,2);
    System.AddBondBetween(A1,0,R1,1);
    if(i==6){
       P1=Phosph.Gen(System,/* Position */new PVector(Pos.x+60,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0); 
       System.AddBondBetween(R1,0,P1,1);
       System.Particles.add(P1);
    }
    System.Particles.add(P0);
    System.Particles.add(A1);
    System.Particles.add(R1);
    
  }
  
  //Particle A2=Guani.Gen(System,new PVector(100+100,100),new PVector(0,0.01),-2,0.0,1.0);
  //Particle A3=Ura.Gen(System,new PVector(100+200,100),new PVector(0,0.01),-2,0.0,1.0);
  //Particle A4=Cyto.Gen(System,new PVector(100+300,100),new PVector(0,0.01),-2,0.0,1.0);
  //Particle A5=Adi.Gen(System,new PVector(100+400,100),new PVector(0,0.01),-2,0.0,1.0);
  //Particle A6=Guani.Gen(System,new PVector(100+500,100),new PVector(0,0.01),-2,0.0,1.0);
  
  
  //System.Particles.add(A2);
  //System.Particles.add(A3);
  //System.Particles.add(A4);
  //System.Particles.add(A5);
  //System.Particles.add(A6);
  
  
    
  PVector[] Posits={new PVector(70,400)};
  //for(int i=0; i<Posits.length;i++){
  //  PVector Pos= Posits[i];
  //  Particle A=Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0);
  //  Particle B=Oxy.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),-2,0,1); 
  //  Particle C=Hydro.Gen(System,new PVector(Pos.x-60,Pos.y),new PVector(0,0.01),-2,0,1);
  //  System.AddBondBetween(A,0,B,0);
  //  System.AddBondBetween(C,0,B,1);
    
  //  System.AddParticle(A);
  //  System.AddParticle(B);
  //  System.AddParticle(C);
  //}
  //System.AddParticle(Hydro.Gen(System,new PVector(50,50),new PVector(0,10),-2,0.0,1.0));
  //System.AddParticle(Hydro.Gen(System,new PVector(50,20),new PVector(0,8),-2,1,1.0));
  //System.AddParticle(Hydro.Gen(System,new PVector(50,100),new PVector(0,8),-2,2,1.0));
  //System.ENERGY=100;
  //System.FixEnergy();
  
  
  
  
  
  // OUTDATE
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
  

  //System.ENERGY= 42000;
  //Particles.add(new Particle(new PVector(width/2,height/2),new PVector(randomGaussian()*10,randomGaussian()*10),30,20));
  //Particles.add(new Particle(new PVector(100,100),new PVector(5,0),15,5));
  //Particles.add(new Particle(new PVector(200,100),new PVector(0,0),15,5));
  
}
float Temp=0.6;
void draw(){
  background(0);
  System.Draw(Camera);
  System.Update();
   
  if(keyPressed){
    if(key=='a'){
      //if(System.ENERGY-5>System.TotPotential()){
        //xSystem.ENERGY-=5; 
        
      //}
      if(Temp>0.01){
        Temp-=0.01;
      }
    }
    if(key=='s'){
        //System.ENERGY+=5;
        Temp+=0.01;
    }
    if(key=='d'){
      System.FixEnergy();
    }
    if(key=='f'){
      println(Camera.Scale+"  "+Camera.Pos.x+"  "+Camera.Pos.y);
    }
  }
  float kinetic=System.TotKinetic();
  float potential=System.TotPotential();
  textSize(18);
  fill(255);
  text(kinetic+potential,10,20);
  text(kinetic,10,40);
  text("T:"+ (kinetic/float(System.Particles.size())),10,60);
  System.ENERGY=Temp*System.Particles.size()+potential;
  text(potential,200,40);
  text("->"+System.ENERGY,130,20);
  text("Bonds:"+System.Bonds.size(),width-300,20);
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
  //saveFrame("video/clip_####.png");
}

void keyPressed(){
   PVector Pos= Camera.ScreenToReal(new PVector(mouseX,mouseY));
   if(key=='q'){
      Particle A=Oxy.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0);
      Particle B=Oxy.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),-2,0,1); 
      System.AddBondBetween(A,0,B,0);
      System.AddBondBetween(A,1,B,1);
      
      System.AddParticle(A);
      System.AddParticle(B);
      System.FixEnergy();
    }
    if(key=='w'){
      
      Particle A=Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0);
      Particle B=Hydro.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),-2,0,1); 
      System.AddBondBetween(A,0,B,0);
      
      System.AddParticle(A);
      System.AddParticle(B);
      System.FixEnergy();
      //System.AddParticle(Thymo.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0));
      //System.FixEnergy();
    }
   // if(key=='e'){
   //   System.AddParticle(Cyto.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0));
   // }
   // if(key=='r'){
   //   System.AddParticle(Guani.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0));
      
   // }
    if(key=='e'){
      System.AddParticle(Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,2),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='r'){
      System.AddParticle(Oxy.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,2),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='t'){
      Particle A=Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0);
      Particle B=Oxy.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),-2,0,1); 
      Particle C=Hydro.Gen(System,new PVector(Pos.x-60,Pos.y),new PVector(0,0.01),-2,0,1);
      System.AddBondBetween(A,0,B,0);
      System.AddBondBetween(C,0,B,1);
      
      System.AddParticle(A);
      System.AddParticle(B);
      System.AddParticle(C);
      System.FixEnergy();
    }
    if(key=='y'){
      System.AddParticle(Sodi.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='u'){
      System.AddParticle(Chlori.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
      System.FixEnergy();
      
    }
    if(key=='i'){
      System.AddParticle(Carbo.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='h'){
      System.AddParticle(Adi.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='j'){
      System.AddParticle(Ura.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='k'){
      System.AddParticle(Cyto.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='l'){
      System.AddParticle(Guani.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='='){
      System.SPEED++;
    }
    if(key=='-'){
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