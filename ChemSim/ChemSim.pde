import java.util.*;

// TODO: 1) Fix Covaalent bonding- issues: fixed                                                |CHECK
          // 1.5)/ Add double/triple/quadruple bondi : done                                     |CHECK
          // 1.6) Make functional way to set bond parameters without messing with array values  |CHECK
  
          // 2) HBonding limited in number, to fix the nucleotide problem                       |CHECK
          // 2.3) Fix hbonding bugs
          // 2.4) Strict HBonding angles                                                        
          // 2.5) Make a bonding parent class (polymorphise bonds) LATER
//          3) Coment code                                                                      | CHECK (KINDA)
          
  //        4)  Add ionic bonding/ charge and stuff , later
  
    //      5) Polar and nonpolar effects                                                       | CHECK
    
    //      6) Run chemical evolution enviroment 
    

// DEFINE SYSTEM VARIABLES
ChemSys System;
Cam Camera= new Cam(new PVector(-15,-20),1);

// DEFINE ALL THE PARTICLE TYPES
ArrayList<PartType> Types;
PartType Hydro=   new PartType(/*Type*/0, /*Color*/ new int[]{255,10,30} ,/*radius*/8,/*mass*/10,/*charge*/1,/*mom inert*/15,/*Bond angles*/new float[]{0},/*Bond ang K*/new float[]{0.2},/*Num HBonds*/1);
PartType Oxy=     new PartType(/*Type*/1,/*Color*/ new int[]{10,30,255},/*radius*/15,/*mass*/20,/*charge*/-2,/*mom inert*/15,/*Bond angles*/new float[]{3.14,1.8},/*Bond ang K*/new float[]{0.2,0.2},/*Num HBonds*/2);
PartType Sodi=    new PartType(/*Type*/2,/*Color*/ new int[]{10,30,255},/*radius*/40,/*mass*/35,/*charge*/0,/*mom inert*/40,/*Bond angle*/new float[]{0},/*Bond K*/new float[]{2},0);
PartType Chlori=  new PartType(/*Type*/3,/*Color*/ new int[]{10,30,255},/*radius*/60,/*mass*/35,/*charge*/0,/*mom inert*/30,/*Bond angle*/new float[]{0},/*Bond K*/new float[]{2},0);
PartType Carbo=   new PartType(/*Type*/4,/*Color*/ new int[]{10,30,255},/*radius*/20,/*mass*/25,/*charge*/0,/*mom inert*/15,/*Bond angles*/new float[]{0,PI*0.5,PI,PI*1.5},/*Bond ang K*/new float[]{0.20,0.20,0.20,0.20},/*Num HBonds*/0);
PartType Adi=     new PartType(/*Type*/5,/*Color*/ new int[]{254,255,20},/*radius*/30,/*mass*/60,/*charge*/-0.1,/*mom inert*/60,/*Bond angle*/new float[]{0},/*Bond ang K*/new float[]{0.2},/*Num HBonds*/1);
PartType Ura=     new PartType(/*Type*/6,/*Color*/ new int[]{255,155,10},/*radius*/30,/*mass*/60,/*charge*/-0.1,/*mom inert*/60,/*Bond angle*/new float[]{0},/*Bond ang K*/new float[]{0.2},/*Num HBonds*/1);
PartType Cyto=    new PartType(/*Type*/7,/*Color*/ new int[]{10,85,155},/*radius*/30,/*mass*/60,/*charge*/-0.1,/*mom inert*/60,/*Bond angle*/new float[]{0},/*Bond ang K*/new float[]{0.2},/*Num HBonds*/1);
PartType Guani=   new PartType(/*Type*/8,/*Color*/ new int[]{0,245,20},/*radius*/30,/*mass*/60,/*charge*/-0.1,/*mom inert*/60,/*Bond angle*/new float[]{0},/*Bond ang K*/new float[]{0.2},/*Num HBonds*/1);
PartType Ribo=    new PartType(/*Type*/9,/*Color*/ new int[]{100,100,100},/*radius*/35,/*mass*/50,/*charge*/-0.1,/*mom inert*/60,/*Bond angle*/new float[]{0-0.6,0.5*PI,PI+0.6},/*Bond ang K*/new float[]{0.6,0.6,0.6},/*Num HBonds*/0);
PartType Phosph=  new PartType(/*Type*/10,/*Color*/ new int[]{167,250,230},/*radius*/15,/*mass*/25,/*charge*/-0.2,/*mom inert*/15,/*Bond angles*/new float[]{0,PI},/*Bond ang K*/new float[]{0.2,0.2},/*Num HBonds*/0);
void setup() {
  
  size(1300,850,P2D);
  //frameRate(1);
  // ADD ALL THE TYPES OF PARTICLES
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
  
  String[] Symbols= new String[]{"H","O","Na","Cl","C","Adi","Ura","Cyt","Gua","Ribo","PO4"};// Particle names

  //System= new ChemSys(Types,Symbols,hBondRadius,hBondForce,cBondLength,cBondK,cBondEnergy,cBondExtra,cActivation,new PVector(600,400));
  System= new ChemSys(Types,Symbols,new PVector(1000,800));
  
  //SET ALL THE BONDING CHARACTERISTICS
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
  
  /* Adi <-> Ribose*/ System.SetCovalentBond(5,9,/*bond length*/70.0,/*bond k*/0.2,/*bond energy*/120,/*bond extra*/-5,/*Activation*/9.0);
  /* Ura <-> Ribose*/ System.SetCovalentBond(6,9,/*bond length*/70.0,/*bond k*/0.2,/*bond energy*/120,/*bond extra*/-5,/*Activation*/9.0);
  /* Cyto <-> Ribose*/ System.SetCovalentBond(7,9,/*bond length*/70.0,/*bond k*/0.2,/*bond energy*/120,/*bond extra*/-5,/*Activation*/9.0);
  /* Guani <-> Ribose*/ System.SetCovalentBond(8,9,/*bond length*/70.0,/*bond k*/0.2,/*bond energy*/120,/*bond extra*/-5,/*Activation*/9.0);
  
  /*Ribose <-> Phosphate*/ System.SetCovalentBond(9,10,/*bond length*/80,/*bond k*/0.2,/*bond energy*/40,/*bond extra*/-20,/*Activation*/9.0);
  
  
  /* H <...> O */System.SetHydrogenBond(0,1,/*bond radius*/35.0,/*bond force*/0.03);
  
  /* Adi <...> Ura*/System.SetHydrogenBond(5,6,/*bond radius*/110,/*bond force*/0.07);
  /* Cyto <...> Guani */System.SetHydrogenBond(7,8,/*bond radius*/110,/*bond force*/0.07);
  ///* Ribose <...> Ribose */System.SetHydrogenBond(9,9,/*bond radius*/150,/*bond force*/0.15);
  
  
  // GENERRATE AN *RNA STRAND
  PVector Pos=new PVector(000,400); 
  //Particle P0;
  //Particle A1;
  //Particle R1=Ribo.Gen(System,/* Position */new PVector(Pos.x,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,        0.0,0.0);;
  //Particle P1;
  //int[] type= new int[]{0,2,0,2,1,3,1,3,1};
  //for( int i=0; i<6;i++){
  //  Pos=new PVector(Pos.x+160,Pos.y);
  //  P0=Phosph.Gen(System,/* Position */new PVector(Pos.x-80,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0);
  //  if( i>0){
  //    System.AddBondBetween(R1,0,P0,1); 
  //  }
  //  if(type[i]==0){
  //    A1=Adi.Gen(System,/* Position */new PVector(Pos.x,Pos.y-70),/* Velocity */new PVector(0,0.01),/* Angle */0,         0.0,0.0);
  //  }else if(type[i]==1){
  //    A1=Ura.Gen(System,/* Position */new PVector(Pos.x,Pos.y-70),/* Velocity */new PVector(0,0.01),/* Angle */0,         0.0,0.0);
  //  }else if(type[i]==2){
  //    A1=Cyto.Gen(System,/* Position */new PVector(Pos.x,Pos.y-70),/* Velocity */new PVector(0,0.01),/* Angle */0,         0.0,0.0);
  //  }else{
  //    A1=Guani.Gen(System,/* Position */new PVector(Pos.x,Pos.y-70),/* Velocity */new PVector(0,0.01),/* Angle */0,         0.0,0.0);
  //  }
    
  //  R1=Ribo.Gen(System,/* Position */new PVector(Pos.x,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,        0.0,0.0);
    
    
  //  System.AddBondBetween(P0,0,R1,2);
  //  System.AddBondBetween(A1,0,R1,1);
  //  if(i==6-1){
  //     P1=Phosph.Gen(System,/* Position */new PVector(Pos.x+80,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0); 
  //     System.AddBondBetween(R1,0,P1,1);
  //     System.Particles.add(P1);
  //  }
  //  System.Particles.add(P0);
  //  System.Particles.add(A1);
  //  System.Particles.add(R1);
    
  //}
  
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
  
  ////ADD WATER
  //for(int i=0; i<120;i++){
  //  Pos= new PVector(random(System.Size.x),random(System.Size.y));
  //  Particle A=Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0);
  //  Particle B=Oxy.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),-2,0,1); 
  //  Particle C=Hydro.Gen(System,new PVector(Pos.x-60,Pos.y),new PVector(0,0.01),-2,0,1);
  //  System.AddBondBetween(A,0,B,0);
  //  System.AddBondBetween(C,0,B,1);
    
  //  System.AddParticle(A);
  //  System.AddParticle(B);
  //  System.AddParticle(C);
  //}
  //System.ENERGY=100;
  //System.FixEnergy();
}

//Temperature, average KE
float Temp=0.6;
void draw(){
  background(0);
  
  //Draw and update system
  System.Draw(Camera);
  System.Update();
   
   // Interact 
  if(keyPressed){
    if(key=='a'){
      //if(System.ENERGY-5>System.TotPotential()){
        //xSystem.ENERGY-=5; 
        
      //}
      
      //Change Temperature
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
  text("HBonds:"+System.HBonds.size(),width-300,80);
  //for(int h=0; h<System.HBonds.size();h++){
  //  HBond H=System.HBonds.get(h);
  //  text("HBond:"+H.A+"  "+ H.B+"  "+H.potential(),width-900,100+h*40);
  //  text("     :"+H.A.type+"  "+ H.B.type,width-900,100+h*40+20);
  //}
  
  text("SPEED:"+System.SPEED,width-100,20);
  text(frameRate+" fps",width-200,height-100);
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
  if(frameCount %15==0){
    //saveFrame("video1/clip_####.png");
  }
}

void keyPressed(){// Keypress interaction
   PVector Pos= Camera.ScreenToReal(new PVector(mouseX,mouseY));
   if(key=='q'){// Create O2
      Particle A=Oxy.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0);
      Particle B=Oxy.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),-2,0,1); 
      System.AddBondBetween(A,0,B,0);
      System.AddBondBetween(A,1,B,1);
      
      System.AddParticle(A);
      System.AddParticle(B);
      System.FixEnergy();
    }
    if(key=='w'){// Create H2
      
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
    if(key=='e'){ //Create monatomic H
      System.AddParticle(Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,2),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='r'){// Create monatomic O
      System.AddParticle(Oxy.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,2),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='t'){// Create water
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
    if(key=='y'){ //Add sodium
      System.AddParticle(Sodi.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='u'){// Add chlorine
      System.AddParticle(Chlori.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
      System.FixEnergy();
      
    }
    if(key=='i'){ //Add carbon
      System.AddParticle(Carbo.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
      System.FixEnergy();
    }
    if(key=='h'){// Add adenine group
      Particle P0=Phosph.Gen(System,/* Position */new PVector(Pos.x-80,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0);
        Particle A1=Adi.Gen(System,/* Position */new PVector(Pos.x,Pos.y-80),/* Velocity */new PVector(0,0.01),/* Angle */0,         0.0,0.0);
        Particle R1=Ribo.Gen(System,/* Position */new PVector(Pos.x,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,        0.0,0.0);
        Particle P1=Phosph.Gen(System,/* Position */new PVector(Pos.x+80,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0); 
        System.AddBondBetween(R1,0,P1,0);
        System.AddBondBetween(R1,2,P0,0); 
        //System.AddBondBetween(P0,0,R1,2);
        System.AddBondBetween(A1,0,R1,1);
        
        System.AddParticle(P0);
        System.AddParticle(A1);
        System.AddParticle(R1);
        System.AddParticle(P1);
        System.FixEnergy();
    }
    if(key=='j'){ // add Uracil nucleotide
      Particle P0=Phosph.Gen(System,/* Position */new PVector(Pos.x-80,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0);
      Particle A1=Ura.Gen(System,/* Position */new PVector(Pos.x,Pos.y-80),/* Velocity */new PVector(0,0.01),/* Angle */0,         0.0,0.0);
      Particle R1=Ribo.Gen(System,/* Position */new PVector(Pos.x,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,        0.0,0.0);
      Particle P1=Phosph.Gen(System,/* Position */new PVector(Pos.x+80,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0); 
      System.AddBondBetween(R1,0,P1,0);
      System.AddBondBetween(R1,2,P0,0); 
      //System.AddBondBetween(P0,0,R1,2);
      System.AddBondBetween(A1,0,R1,1);
      
      System.AddParticle(P0);
      System.AddParticle(A1);
      System.AddParticle(R1);
      System.AddParticle(P1);
      System.FixEnergy();
    }
    if(key=='k'){ /// Add cytosene group
      Particle P0=Phosph.Gen(System,/* Position */new PVector(Pos.x-80,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0);
        Particle A1=Cyto.Gen(System,/* Position */new PVector(Pos.x,Pos.y-80),/* Velocity */new PVector(0,0.01),/* Angle */0,         0.0,0.0);
        Particle R1=Ribo.Gen(System,/* Position */new PVector(Pos.x,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,        0.0,0.0);
        Particle P1=Phosph.Gen(System,/* Position */new PVector(Pos.x+80,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0); 
        System.AddBondBetween(R1,0,P1,0);
        System.AddBondBetween(R1,2,P0,0); 
        //System.AddBondBetween(P0,0,R1,2);
        System.AddBondBetween(A1,0,R1,1);
        
        System.AddParticle(P0);
        System.AddParticle(A1);
        System.AddParticle(R1);
        System.AddParticle(P1);
        System.FixEnergy();
    }
    if(key=='l'){ // add guanine group
       Particle P0=Phosph.Gen(System,/* Position */new PVector(Pos.x-80,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0);
        Particle A1=Guani.Gen(System,/* Position */new PVector(Pos.x,Pos.y-80),/* Velocity */new PVector(0,0.01),/* Angle */0,         0.0,0.0);
        Particle R1=Ribo.Gen(System,/* Position */new PVector(Pos.x,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,        0.0,0.0);
        Particle P1=Phosph.Gen(System,/* Position */new PVector(Pos.x+80,Pos.y),/* Velocity */new PVector(0,0.01),/* Angle */0.5*PI,   0.0,0.0); 
        System.AddBondBetween(R1,0,P1,0);
        System.AddBondBetween(R1,2,P0,0); 
        //System.AddBondBetween(P0,0,R1,2);
        System.AddBondBetween(A1,0,R1,1);
        
        System.AddParticle(P0);
        System.AddParticle(A1);
        System.AddParticle(R1);
        System.AddParticle(P1);
        System.FixEnergy();
    }
    if(key=='='){ //Increase speed
      System.SPEED++;
    }
    if(key=='-'){ //Decrease speed
      System.SPEED--; 
    }
    if(key==','){ // Zoom in
      Camera.Scale/=1.2; 
    }
    if(key=='.'){ // Zoom out
      Camera.Scale*=1.2;
    }
    if(key=='x'){
      for(int p=System.Particles.size()-1; p>=0 ;p--){
        Particle P= System.Particles.get(p);
        if(PVmag(PVadd(Camera.ScreenToReal(new PVector(mouseX,mouseY)),PVneg(P.pos)))<P.radius){
          System.RemoveParticle(p);
        }
      }
    }
}