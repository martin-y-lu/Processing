import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ChemSim_1 extends PApplet {



// FORKED FOR IONIC EFFECTS TESTING
// TODO: 1) Fix Covaalent bonding- issues: fixed                                                | CHECK
          // 1.5)/ Add double/triple/quadruple bondi : done                                     | CHECK
          // 1.6) Make functional way to set bond parameters without messing with array values  | CHECK
  
      //    2) HBonding limited in number, to fix the nucleotide problem                        | CHECK
          // 2.3) Fix hbonding bugs                                                             | CHECK (?) 
          // 2.4) Strict HBonding angles                                                        
          // 2.5) Make a bonding parent class (polymorphise bonds) LATER
//          3) Coment code                                                                      | CHECK (KINDA)
          
  //        4)  Add ionic bonding/ charge and stuff                                             | CHECK  
      //     4.01) Ionisation reaction (Na + Cl -> Na+ + Cl- )                                  | CHECK
  //         4.1) Dipole moment                                                                 | CHECK
       //    4.3) Autoionisation (Polarazation during bond breakdown)                           | CHECK
         //  4.4) Electron uneven sourcing( so that OH- and H+ can react )                      | CHECK
        //   4.5) Acid base reactions: Strong acid, weak acid simulation
      //     4.6) Acidic/basic salts                                                            |
      
    //      5) Polar and nonpolar effects                                                       | CHECK
      //     5.1) soluble/insoluble salts
          // 5.1) Lipid bilayer
          //
    
    //       
             
    //      6) Run chemical evolution enviroment 
    

// DEFINE SYSTEM VARIABLES
ChemSys System;
Cam Camera= new Cam(new PVector(-15,-20),0.5f);

// DEFINE ALL THE PARTICLE TYPES
ArrayList<PartType> Types;
PartType Hydro=   new PartType(/*Type*/0, /*Color*/ new int[]{255,10,30} ,/*radius*/8,/*mass*/10,/*electrons*/1,/*max electrons*/2,/*e neutral*/1,/*electron energy*/0,/*mom inert*/15,/*Bond angles*/new float[]{0},/*Bond ang K*/new float[]{0.2f},/*Num HBonds*/1);
PartType Oxy=     new PartType(/*Type*/1,/*Color*/ new int[]{10,30,255},/*radius*/15,/*mass*/20,/*electrons*/2,/*max electrons*/2,/*e neutral*/2,/*electron energy*/0,/*mom inert*/15,/*Bond angles*/new float[]{3.14f,1.8f},/*Bond ang K*/new float[]{0.2f,0.2f},/*Num HBonds*/2);
PartType Sodi=    new PartType(/*Type*/2,/*Color*/ new int[]{10,30,255},/*radius*/40,/*mass*/35,/*electrons*/1,/*max electrons*/1,/*e neutral*/1,/*electron energy*/-20,/*mom inert*/40,/*Bond angle*/new float[]{0},/*Bond K*/new float[]{2},0);
PartType Chlori=  new PartType(/*Type*/3,/*Color*/ new int[]{10,30,255},/*radius*/60,/*mass*/35,/*electrons*/0,/*max electrons*/1,/*e neutral*/0,/*electron energy*/20,/*mom inert*/30,/*Bond angle*/new float[]{0},/*Bond K*/new float[]{2},0);
 
public void setup(){
  
  Types= new ArrayList<PartType> ();
  Types.add(Hydro);  
  Types.add(Oxy);
  Types.add(Sodi);
  Types.add(Chlori);
  
  String[] Symbols= new String[]{"H","O","Na","Cl","C","Adi","Ura","Cyt","Gua","Ribo","PO4"};// Particle names

  //System= new ChemSys(Types,Symbols,new PVector(1000,800));
  System= new ChemSys(Types,Symbols,new PVector(500,400));
  
  //SET ALL THE BONDING CHARACTERISTICS
  /* H <-> H */System.SetCovalentBond(0,0,/*bond length*/20.0f,/*bond k*/0.06f,/*bond energy*/10.0f,/*bond extra*/0.0f,/*Activation*/3.0f,/*Dipole*/ 0, /*Brakedown distribution*/ 0);
  /* H <-> O */System.SetCovalentBond(0,1,/*bond length*/30.0f,/*bond k*/0.25f,/*bond energy*/55,/*bond extra*/0.0f,/*Activation*/20.0f,/*Dipole*/ 0.2f,/*Brakedown distribution*/1); // Give electron to oxygen
  /* O <-> O */System.SetCovalentBond(1,1,/*bond length*/30.0f,/*bond k*/0.1f,/*bond energy*/25,/*bond extra*/10,/*Activation*/3.0f,/*Dipole*/ 0,/*Brakedown distribution*/0);
  
  //ADD WATER
  PVector Pos;
  for(int i=0; i<0;i++){
    Pos= new PVector(random(System.Size.x),random(System.Size.y));
    Particle A=Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01f),-2,0.0f,1.0f);
    Particle B=Oxy.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01f),-2,0,1); 
    Particle C=Hydro.Gen(System,new PVector(Pos.x-60,Pos.y),new PVector(0,0.01f),-2,0,1);
    System.AddBondBetween(A,0,B,0);
    System.AddBondBetween(C,0,B,1);
    
    System.AddParticle(A);
    System.AddParticle(B);
    System.AddParticle(C);
  }
  System.ENERGY=100;
  //System.FixEnergy();
}
public void draw(){
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
      if(System.TEMP>0.01f){
        System.TEMP-=0.01f;
      }
    }
    if(key=='s'){
        //System.ENERGY+=5;
        System.TEMP+=0.01f;
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
  text("T:"+ (kinetic/PApplet.parseFloat(System.Particles.size())),10,60);
  //System.ENERGY=Temp*System.Particles.size()+potential;
  text(potential,200,40);
  text("->"+System.ENERGY,130,20);
  text("Bonds:"+System.Bonds.size(),width-300,20);
  text("HBonds:"+System.HBonds.size(),width-300,80);
  //for(int h=0; h<System.HBonds.size();h++){
  //  HBond H=System.HBonds.get(h);
  //  text("HBond:"+H.A+"  "+ H.B+"  "+H.potential(),width-900,100+h*40);
  //  text("     :"+H.A.type+"  "+ H.B.type,width-900,100+h*40+20);
  //}
  for(int p=System.Particles.size()-1; p>=0 ;p--){
    Particle P= System.Particles.get(p);
    PVector mouse=new PVector(mouseX,mouseY);
    if(PVmag(PVadd(Camera.ScreenToReal(mouse),PVneg(P.pos)))<P.radius){
      fill(0);
      stroke(255);
      strokeWeight(4);
      rect(mouse.x,mouse.y,200,200,20);
      fill(255);
      text("Type:"+ System.Symbols[P.type], mouse.x+10,mouse.y+25);
      text("Free Electrons:"+ P.electrons, mouse.x+10,mouse.y+45);
      text("Captive Electrons:"+ P.numBonds(), mouse.x+10,mouse.y+65);
      text("Max electrons:"+ P.emax, mouse.x+10,mouse.y+85);
      text("Ecount neutral:"+ P.eneutral, mouse.x+10,mouse.y+105);
      text("Charge:"+ P.charge, mouse.x+10,mouse.y+125);
    }
  }
  
  
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

public void keyPressed(){// Keypress interaction
   PVector Pos= Camera.ScreenToReal(new PVector(mouseX,mouseY));
   if(key=='q'){// Create O2
      Particle A=Oxy.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01f),-2,0.0f,1.0f);
      Particle B=Oxy.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01f),-2,0,1); 
      System.AddBondBetween(A,0,B,0);
      System.AddBondBetween(A,1,B,1);
      
      System.AddParticle(A);
      System.AddParticle(B);
      System.FixEnergy();
    }
    if(key=='w'){// Create H2
      
      Particle A=Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01f),-2,0.0f,1.0f);
      Particle B=Hydro.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01f),-2,0,1); 
      System.AddBondBetween(A,0,B,0);
      
      System.AddParticle(A);
      System.AddParticle(B);
      System.FixEnergy();
      //System.AddParticle(Thymo.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0));
      //System.FixEnergy();
    }
    if(key=='e'){ //Create monatomic H
      System.AddParticle(Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,2),-2,0.0f,1.0f,/* electrons */1));
      System.FixEnergy();
    }
    if(key=='r'){// Create monatomic O
      System.AddParticle(Oxy.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,2),-2,0.0f,1.0f,/* electrons */2));
      System.FixEnergy();
    }
    if(key=='t'){// Create water
      Particle A=Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01f),-2,0.0f,1.0f);
      Particle B=Oxy.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01f),-2,0,1); 
      Particle C=Hydro.Gen(System,new PVector(Pos.x-60,Pos.y),new PVector(0,0.01f),-2,0,1);
      System.AddBondBetween(A,0,B,0);
      System.AddBondBetween(C,0,B,1);
      
      System.AddParticle(A);
      System.AddParticle(B);
      System.AddParticle(C);
      System.FixEnergy();
    }
    if(key=='y'){ //Add sodium
      System.AddParticle(Sodi.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0f,1.0f));
      System.FixEnergy();
    }
    if(key=='u'){// Add chlorine
      System.AddParticle(Chlori.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0f,1.0f));
      System.FixEnergy();
      
    }
    //if(key=='i'){ //Add carbon
    //  System.AddParticle(Carbo.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,10),-2,0.0,1.0));
    //  System.FixEnergy();
    //}
    if(key=='='){ //Increase speed
      System.SPEED++;
    }
    if(key=='-'){ //Decrease speed
      System.SPEED--; 
    }
    if(key==','){ // Zoom in
      Camera.Scale/=1.2f; 
    }
    if(key=='.'){ // Zoom out
      Camera.Scale*=1.2f;
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
class Cam{ // Camera class
  PVector Pos= new PVector(0,0);
  float Scale=1;
  Cam(PVector dPos,float dScale){
    Pos=dPos; Scale=dScale;
  }
  
  public PVector RealToScreen(PVector real){ // Converting real space to screen space
   return PVscale(PVadd(real,PVneg(Pos)),1/Scale); 
  }
  public float RealToScreenX(float realX){
    return (realX-Pos.x)/Scale; 
  }
  public float RealToScreenY(float realY){
    return (realY-Pos.y)/Scale; 
  }
  public PVector ScreenToReal(PVector screen){  //Converting screen space to real space
   return PVadd(PVscale(screen,Scale),Pos); 
  } 
  public float ScreenToRealX(float screenX){
    return (screenX*Scale)+Pos.x; 
  }
  public float ScreenToRealY(float screenY){
    return (screenY*Scale)+Pos.y; 
  }
}

class ChemSys{// Class for all the chemical system
 // Types, Particles, and Bonds
 int NUMTYPES; 
 ArrayList<PartType> Types;
 String[] Symbols;
 ArrayList<Particle> Particles;
 ArrayList<Bond> Bonds;
 ArrayList<HBond> HBonds;
 
 /// Bond characteristics
 float[][] hBondLength;
 float[][] hBondForce;
 
 float[][] cBondLength;
 float[][] cBondK;
 float[][] cBondEnergy;
 float[][] cBondExtra;
 float[][] cActivation;
 float[][] cDipole;
 int[][] cBreakDistrib; // -1 = give to left(2,0), 0 = normal (1,1) , 1 equals give to right (0,2)

 // Simulation speed
 int SPEED=9;
 PVector GRAV=new PVector(0,0.00002f);// Gravitational acceleration
 float ENERGY=0;// Mechanical energy of system, to be conseverd
 float TEMP=0.6f;
 PVector Size;// Size of the reaction area
 
 ChemSys(ArrayList<PartType> dTypes,String[] dSymbols, float[][] dHBondLength,float[][] dHBondForce,float[][] dCBondLength, float[][] dCBondK, float[][] dCBondEnergy, float[][] dCBondExtra,float[][] dCActivation, PVector dSize){ // Initialise with bond arrays
    Types= dTypes;
    Symbols=dSymbols;
    //Particles= dParticles;
    Particles= new ArrayList<Particle>( );
    Bonds= new ArrayList<Bond>();
    HBonds=new ArrayList<HBond>();
    NUMTYPES=dTypes.size();
    hBondLength= dHBondLength;
    hBondForce= dHBondForce;
    cBondLength= dCBondLength;
    cBondK=dCBondK;
    cBondEnergy=dCBondEnergy;
    cBondExtra=dCBondExtra;
    cActivation= dCActivation;
    Size=dSize;
 }
 ChemSys(ArrayList<PartType> dTypes, String[] dSymbols, PVector dSize){// Initialise with null/zero bond characteristics
    Types= dTypes;
    Symbols=dSymbols;
    //Particles= dParticles;
    Particles= new ArrayList<Particle>( );
    Bonds= new ArrayList<Bond>();
    HBonds=new ArrayList<HBond>();
    NUMTYPES=dTypes.size();
    hBondLength= new float[NUMTYPES][NUMTYPES];
    hBondForce=  new float[NUMTYPES][NUMTYPES];
    cBondLength= new float[NUMTYPES][NUMTYPES];
    cBondK=      new float[NUMTYPES][NUMTYPES];
    cBondEnergy= new float[NUMTYPES][NUMTYPES];
    cBondExtra=  new float[NUMTYPES][NUMTYPES];
    cActivation= new float[NUMTYPES][NUMTYPES];
    cDipole=  new float[NUMTYPES][NUMTYPES];
    cBreakDistrib=  new int[NUMTYPES][NUMTYPES];
    Size=dSize;
 }
 public void SetHydrogenBond(int AInd,int BInd, float BondRadius, float BondForce){ // Set HBOND characteristics
   hBondLength[AInd][BInd]=BondRadius; 
   hBondLength[BInd][AInd]=BondRadius; 
   hBondForce[AInd][BInd]=BondForce; 
   hBondForce[BInd][AInd]=BondForce; 
 }
 public void SetCovalentBond(int AInd,int BInd, float BondLength, float BondK,float BondEnergy, float BondExtra, float BondActivation,float Dipole,int BreakDistrib){ // Set covalent bond characteristics
   cBondLength[AInd][BInd]=BondLength;
   cBondLength[BInd][AInd]=BondLength;
   cBondK[AInd][BInd]=BondK;
   cBondK[BInd][AInd]=BondK;
   cBondEnergy[AInd][BInd]=BondEnergy;
   cBondEnergy[BInd][AInd]=BondEnergy;
   cBondExtra[AInd][BInd]=BondExtra;
   cBondExtra[BInd][AInd]=BondExtra;
   cActivation[AInd][BInd]=BondActivation;
   cActivation[BInd][AInd]=BondActivation;
   cDipole[AInd][BInd]=Dipole;
   cDipole[BInd][AInd]= - Dipole;
   cBreakDistrib[AInd][BInd]= BreakDistrib;
   cBreakDistrib[BInd][AInd]= -BreakDistrib;
 }
 public PVector EField(PVector Pos){ // E field at point
    PVector field= new PVector(0,0);
    for( Particle P: Particles){
      field= PVadd(field,P.Field(Pos));
    }
    return field;
  }
  
  public float TotEnergy(){ //Total mechanical energy
    //float totEnergy=0;
    //for(int i=0;i<Particles.size();i++){
    // totEnergy+=Particles.get(i).energy(); 
    //}
    return TotPotential()+TotKinetic();
  }
  public float TotPotential(){// Total potential energy
    float totPot=0;
    for(int p=0;p<Particles.size();p++){
     totPot+=Particles.get(p).potential(); 
    }
    for(int b=0;b<Bonds.size();b++){
     totPot+=Bonds.get(b).potential();
    }
    for(int h=0;h<HBonds.size();h++){
     totPot+=HBonds.get(h).potential(); 
    }
    return totPot;
  }
  public float TotKinetic(){ // Total kinetic enegy
    float totKin=0;
    for(int i=0;i<Particles.size();i++){
     totKin+=Particles.get(i).kinetic(); 
    }
    return totKin;
  }
  public void RescaleVel(){// Rescales velocities, and angular velcities such that total energy is constant
      //Collections.sort(Particles);
      //float pow=0;
      //float skew=1;
      float actualKinetic= TotKinetic();
      float targetKinetic= ENERGY-TotPotential();
      
      //float integ=(pow(skew+1,pow+1)-pow(skew,pow+1))/(pow+1);
      for(int i=0;i<Particles.size();i++){//Fix velocities to conserve energy
        //float rank=((float) i)/(Particles.size()-1);
        float scale=max(targetKinetic/actualKinetic,0);//*pow(rank+skew,pow)/integ;
        scale=pow(scale,0.5f);
        
        Particles.get(i).vel=PVscale(Particles.get(i).vel,scale);
        Particles.get(i).angVel*=scale;
      }
  }
  public void DrawFieldLines(Cam Camera){ // Draws efield lines // DEFUNCT FIX LATER
    for( int x=0; x<width;x+=30){
      for( int y=0; y<height; y+=30){
         PVector F=EField(Camera.ScreenToReal(new PVector(x,y)));
         F= PVscale(F,400);
         if(PVmag(F)>20){
           F=PVsetMag(F,20);
         }
         line(x,y,x+F.x,y+F.y);
      }
    }
  }
  public void DrawParticles(Cam Camera){/// Draws all particles on screen
    for(int p=0;p<Particles.size();p++){
      Particle P= Particles.get(p);
      P.Draw(Camera);
      //for(int j=p+1;j<Particles.size();j++){
      //   Particle J= Particles.get(j);
      //   float dist= PVmag(PVadd(P.pos,PVneg(J.pos)));
      //   if(dist<hBondRadius[P.type][J.type]){
      //     strokeWeight(hBondForce[P.type][J.type]*3.0/Camera.Scale);
      //     line(Camera.RealToScreenX(P.pos.x),Camera.RealToScreenY(P.pos.y),Camera.RealToScreenX(J.pos.x),Camera.RealToScreenY(J.pos.y));
      //   }
      //}
    } 
  }
  public void Draw(Cam Camera){ // Draw the Chemical sustem
    //DrawFieldLines(Camera);
    DrawParticles(Camera);
    for( int b=0;b<Bonds.size();b++){ // Draw Bonds
      Bonds.get(b).Draw(Camera);
    }
    for( int h=0; h<HBonds.size();h++){
       HBonds.get(h).Draw(Camera); 
    }
    
    noStroke();
    fill(100);// Draw boundary
    rect(0,0,Camera.RealToScreenX(0),height);
    rect(0,0,width,Camera.RealToScreenY(0));
    rect(width,0,Camera.RealToScreenX(Size.x)-width,height);
    rect(0,height,width,Camera.RealToScreenY(Size.y)-height);
  }
  public float PotentialBondEnergy( Particle A, int AInd, Particle B, int BInd){ // Potential bond energy IF there were to be a covalent bond between Particle A, and Particle B in the specified bonding sites
    //if(A.electrons==0||B.electrons==0){
    //   return 0; 
    //}
    float bondLength= cBondLength[A.type][B.type]; 
    float bondK= cBondK[A.type][B.type];
    float bondEnergy= cBondEnergy[A.type][B.type];// Calculate bonding energy
    if(A.BondedTo(B)){ // bonding divedend
      bondEnergy+= cBondExtra[A.type][B.type]; 
    }
    float pot=-bondEnergy;// Bond energy is negativer potential
     float dist=PVmag(PVadd(A.pos,PVneg(B.pos)));
     float disp=dist-bondLength;
     pot+= 0.5f*bondK*(disp*disp); // Linear elastic potential energy
     
     float bondAngle= atan2(B.pos.x-A.pos.x,B.pos.y-A.pos.y);
     float angDisp= (A.angle+A.bondAngles[AInd]-bondAngle)%TWO_PI;
     if(angDisp>PI){
       angDisp=angDisp-TWO_PI;
     }
     pot+= 0.5f*A.bondAngKs[AInd]*(angDisp*angDisp);  // Angular EPE
     float bondDisp= (bondAngle-B.angle-B.bondAngles[BInd])%TWO_PI;
     if(bondDisp>PI){
       bondDisp=bondDisp-TWO_PI;
     }
     pot+= 0.5f*B.bondAngKs[BInd]*(bondDisp*bondDisp);
     pot+= cDipole[A.type][B.type]*(A.eenergy-B.eenergy);
     return pot;
  }
  public void Update(){// Real update function
    for(int s=0;s<SPEED;s++){
      OneUpdate();
    } 
    if(SPEED<0){
      if(frameCount%-SPEED==0){
        OneUpdate(); 
      }
    }
  }
  public void OneUpdate(){// Updates particles, energies, and bonds
      for(int i=0;i<Particles.size();i++){
        for(int j=0; j<i;j++){
          if(FLtween(Particles.get(i).pos.x-200,Particles.get(i).pos.x+200,Particles.get(j).pos.x)&&FLtween(Particles.get(i).pos.y-200,Particles.get(i).pos.y+200,Particles.get(j).pos.y)){
            //For every pair of particles, if in range, affect (E forces)
            Particles.get(i).Affect(Particles.get(j)); 
          }
        }
      }
      for(int b=0;b<Bonds.size();b++){
         Bonds.get(b).Update();  // Update bonds
      }
      for(int h=0;h<HBonds.size();h++){
         HBonds.get(h).Update();
      }
      for(int i=0;i<Particles.size();i++){
        Particles.get(i).CollideWall(); // Collide with wall
      }
      
      for(int i=Bonds.size()-1;i>=0;i--){
         Bond BOND= Bonds.get(i); // SET BONDING POTENTIALS
         BOND.SetPotential();
      }
      for(int h=0;h<HBonds.size();h++){
         HBonds.get(h).SetPotential();
      }
      
      ENERGY=TEMP*Particles.size()+TotPotential();
      for ( int i=Bonds.size()-1;i>=0;i--){
        Bond BOND= Bonds.get(i);  // IF POSITIVE POTENTIAL ENERGY, BREAK
        if(BOND.potential()>0){
          RemoveBond(i);
        }
      }
      for(int h=HBonds.size()-1;h>=0;h--){
         HBond HBOND= HBonds.get(h);
         if(HBOND.potential()>=0){
           RemoveHBond(h);
         }
      }
      for(int i=0;i<Particles.size();i++){
        for(int j=0; j<i;j++){
          Particle A=Particles.get(i);
          Particle B=Particles.get(j);
          if(FLtween(A.pos.x-200,A.pos.x+200,B.pos.x)&&FLtween(A.pos.y-200,A.pos.y+200,B.pos.y)){
            //CHECK COLLISIONS (covalent bonding) and HBonds between all pairs of particles in range
            CheckCollision(A,B);
            CheckHBond(A,B);
          }
        }
      }
      //for( int i=Bonds.size()-1;i>=0;i--){
      //   Bond BOND= Bonds.get(i);
      //   if(BOND.A.Sites[BOND.AInd]!=BOND){
      //     Bonds.remove(i);
      //     println("WRONG BOND");
      //   }else if(BOND.B.Sites[BOND.BInd]!=BOND){
      //     Bonds.remove(i);
      //     println("WRONG BOND");
      //   }
      //}
      for(int i=0; i<Particles.size(); i++){ // UPdate velocities
         Particles.get(i).UpdateVel();
      }
      RescaleVel();// FIX energy
      for(int i=0; i<Particles.size(); i++){
         Particles.get(i).UpdatePos();
      } 
  }
  public void CheckCollision(Particle A, Particle B){ // CHecks all collision dynamics between pair of particles, determines if new bond should be formed, and creates it
    if(A.Collides(B)){// If physically colliding
      // Find if any new bond should be formed, by going through every pair of bonding sites, and calculating the enpalphy of formation.
      
      float maxEnergy=0;// Stores the maximim enerhy and sites
      int etransfer=0;// A-> B
      boolean Ionic=true;
      //if(A.eenergy<B.eenergy){
      //  etransfer= min(A.electrons,B.emax-B.electrons-B.numBonds());
      //  maxEnergy=etransfer*(B.eenergy-A.eenergy);
      //}if(A.eenergy>B.eenergy){// B e's to A
      //  etransfer= -min(B.electrons,A.emax-A.electrons-A.numBonds());
      //  maxEnergy=etransfer*(B.eenergy-A.eenergy);
      //}
      println("Transfered " +etransfer);
      println("IONIC BOND ENERGY"+maxEnergy);
      
      int Asite=0;
      int Bsite=0;
      if( cBondEnergy[A.type][B.type]>0){ // If there is any bonding energy at all:             
        for(int a=0; a<A.NumSites;a++){
          for(int b=0; b<B.NumSites; b++){ // For each pair of bonding sites:
            float EnergyReleased= PotentialBondEnergy(A,a,B,b);  // Energy released is the potential energy (negative) of the new bond formed at those bonding sites
            float EnergyDepleted= 0; // Find energy depleated, if there are any bonds already existing, removing them depleats a certain amount of energy
            int Aliberated=0;
            if(A.Sites[a]!=null){
              Aliberated++;
              EnergyDepleted+= A.Sites[a].potential();
            }
            int Bliberated=0;
            if(B.Sites[b]!=null){
              if(B.Sites[b]!=A.Sites[a]){
                Bliberated++;
                EnergyDepleted+= B.Sites[b].potential();
              }
            }
            float energy=-(EnergyReleased-EnergyDepleted);// caluclateEnphaply
            if(A.electrons+Aliberated<=0){
              energy=0; 
            }
            if(A.electrons+Bliberated<=0){
              energy=0; 
            }
            if(energy>maxEnergy){ // If this is maximum yet, set the variables.
              Ionic = false;
              maxEnergy=energy;
              Asite=a;
              Bsite=b;
            }
          }
        }
      }
      if(maxEnergy>cActivation[A.type][B.type]){ // If max energy is greater than the activation energy:
        if(Ionic){
          println("IONIC BOND");
          B.electrons+=etransfer;
          A.electrons-=etransfer;
          A.charge();
          B.charge();
        }else{//Covalent
          //println("Bonds");
          if(A.Sites[Asite]!=null){ // Remove the existing bonds at sites
            //A.Sites[Asite]=null;
            RemoveBond(A.Sites[Asite]);
          }
          if(B.Sites[Bsite]!=null){
            //B.Sites[Bsite]=null;
            RemoveBond(B.Sites[Bsite]);
          }
          Bond BOND =AddBondBetween(A,Asite,B,Bsite); // Create new bond at sites
          //A.Sites[Asite]=BOND;
          //B.Sites[Bsite]=BOND;
          //Bonds.add(BOND);
          println("COvBond");
        }
        A.Collide(B,maxEnergy); // Collide,releasing extra enegry as kinetic
      }else{// 
        A.Collide(B,0);// normal collison
      }
    }
  }
  public void CheckHBond(Particle A, Particle B){ // Checks if Particles are in range for an HBOND, and if they can accept one.
    float dist=PVmag(PVadd(A.pos,PVneg(B.pos)));
    if(dist<hBondLength[A.type][B.type]){ // If distance is in the range
      if(!(A.HBondedTo(B)||B.HBondedTo(A))){ // If they are not already HBONDED
        if(!A.BondedTo(B)){
           int AInd=0;
           int BInd=0;
           boolean Bond=false; /// FIND OPEN HBOND SITES
           for(int a=0; a<A.HSites.length;a++){
             for(int b=0; b<B.HSites.length; b++){
               //print(A.HSites[a]);
               if((A.HSites[a]==null)&&(B.HSites[b]==null)){
                 AInd=a;
                 BInd=a;
                 Bond=true;
               }
             }
           }
           if(Bond){// If any hbond sites, create hbond
             //println("HBOND MADE");
             AddHBondBetween(A,AInd,B,BInd);
           }
        }
      }
    }
  }
  // Remove bonds, and clear bonding sites.
  
  public void RemoveParticle(int p){
    Particle P= Particles.get(p);
    for(int i=0; i<P.Sites.length;i++){
        Bond BOND=P.Sites[i];
        if(BOND!=null){
          BOND.A.Sites[BOND.AInd]=null;
          BOND.B.Sites[BOND.BInd]=null;
        }
        Bonds.remove(BOND);
    }
    for(int i=0; i<P.HSites.length;i++){
        HBond HBOND=P.HSites[i];
        if(HBOND!=null){
          HBOND.A.HSites[HBOND.AInd]=null;
          HBOND.B.HSites[HBOND.BInd]=null;
        }
        HBonds.remove(HBOND);
    }
    Particles.remove(p);
  }
  public void RemoveBond(int i){ 
    RemoveBond(Bonds.get(i));
  }
  public void RemoveBond(Bond BOND){ 
    BOND.A.Sites[BOND.AInd]=null;
    BOND.B.Sites[BOND.BInd]=null;
    BOND.A.electrons+= 1 - cBreakDistrib[BOND.A.type][BOND.B.type]; //Return electrons
    BOND.B.electrons+= 1 + cBreakDistrib[BOND.A.type][BOND.B.type]; //Return electrions
    BOND.A.charge();//Set charges
    BOND.B.charge();
    Bonds.remove(BOND);
  }
  public void RemoveHBond(int h){
    //println("HBOND Remove");
    HBond HBOND=HBonds.get(h);
    HBOND.A.HSites[HBOND.AInd]=null;
    HBOND.B.HSites[HBOND.BInd]=null;
    HBonds.remove(HBOND);
  }
  public void AddParticle(Particle P){
    Particles.add(P);
  }
  public void FixEnergy(){
    ENERGY= TotEnergy();
  }
  // Add new bonds, and set bonding sites.
  public Bond AddBondBetween(Particle A,int AInd,Particle B,int BInd){
    float energy=cBondEnergy[A.type][B.type];
    if(A.BondedTo(B)){
      energy+=cBondExtra[A.type][B.type];
    }
    
    Bond BOND=new Bond(cBondLength[A.type][B.type],cBondK[A.type][B.type],energy,cDipole[A.type][B.type],A,AInd,B,BInd);
    A.Sites[AInd]=BOND;
    B.Sites[BInd]=BOND;
    if(A.electrons==0){
      B.electrons-=2;
    }else if(B.electrons==0){
      A.electrons-=2; 
    }else{
       A.electrons--;
       B.electrons--;
    }
    if((A.electrons<0)||(B.electrons<0)){
      print("BOND CREATION FALED: NOT ENOUGTH ELECTRONS:"); 
    }
    
    A.charge();//Set charges
    B.charge();
    Bonds.add(BOND);
    return BOND;
  }
  public HBond AddHBondBetween(Particle A,int AInd,Particle B, int BInd){
    HBond HBOND=new HBond(hBondLength[A.type][B.type],hBondForce[A.type][B.type],A,B);
    try{
      
      A.HSites[AInd]=HBOND;
      B.HSites[BInd]=HBOND;
      HBonds.add(HBOND);
      
    }catch(Exception E){
      println("WHY");
    }
    return HBOND;
  }
}



class PartType{// Class for storing particle types
// Stores all particle parameters, and allows for easy generation
  float radius;
    float mass;
    int electrons; // number of free electrons
    int emax; // maximum number of electrons allowed
    int eneutral;  // number of electrons at neutral
    float eenergy; // amount of potential energy per electron;
    
    
    float momInert;
    
    float[] bondAngles;
    float[] bondAngKs;
    int numHBonds;
    
    int colorR;
    int colorG;
    int colorB;
    
    int type;
    PartType(int dType, int[] dColor, float dRad,float dMass,
    int dElectrons, int dEmax, int dEneutral, float dEenergy,
    float dMomInert,float[] dBondAngles,float[] dBondAngKs,int dNumHBonds){
       colorR=dColor[0]; colorG=dColor[1]; colorB= dColor[2];
       radius= dRad; mass= dMass; 
       electrons= dElectrons; emax=dEmax; eneutral=dEneutral; eenergy= dEenergy;
       momInert=dMomInert;  bondAngles=dBondAngles;  bondAngKs=dBondAngKs; numHBonds=dNumHBonds;
       type = dType;
    }
    public Particle Gen(ChemSys dSys,PVector dPos,PVector dVel,float dAngle, float dAngVel, float dAngAcc){
      return new Particle(dSys,type,colorR,colorG,colorB,dPos,dVel,radius,mass,
      electrons,emax, eneutral,eenergy,
      dAngle, dAngVel, dAngAcc,momInert,
      bondAngles,bondAngKs,numHBonds); 
    }
    public Particle Gen(ChemSys dSys,PVector dPos,PVector dVel,float dAngle, float dAngVel, float dAngAcc,int setElectrons){
      return new Particle(dSys,type,colorR,colorG,colorB,dPos,dVel,radius,mass,
      setElectrons,emax, eneutral,eenergy,
      dAngle, dAngVel, dAngAcc,momInert,
      bondAngles,bondAngKs,numHBonds); 
    }
    public Particle Gen(ChemSys dSys,PVector dPos,PVector dVel,float dAngle, float dAngVel, float dAngAcc, Particle dB,int AInd,int BInd){
      Particle P= new Particle(dSys,type,colorR,colorG,colorB,dPos,dVel,radius,mass,
      electrons,emax, eneutral,eenergy,
      dAngle, dAngVel, dAngAcc,momInert,
      bondAngles,bondAngKs,numHBonds);
      dSys.AddBondBetween(P,AInd,dB,BInd);
      return P; 
    }
}
/* Bunch a unbelivably useful functions */

public PVector PVadd(PVector A,PVector B){
  return new PVector(A.x+B.x,A.y+B.y);
}
public PVector PVscale(PVector A,float B){
  return new PVector(A.x*B,A.y*B);
}

public PVector PVlerp(PVector A, PVector B, float l){
 return new PVector(A.x*(1-l)+B.x*l, A.y*(1-l)+B.y*l);
}
public PVector PVsetMag(PVector P,float L){
  return PVscale(P,L/PVmag(P));
}
public PVector PVneg(PVector P){
  return PVscale(P,-1);
}
public float PVmag(PVector P){
  return dist(0,0,P.x,P.y);
}
public PVector PVmult(PVector A,PVector B){
  return new PVector(A.x*B.x-A.y*B.y,A.x*B.y+A.y*B.x);
}
public PVector PVdivide(PVector P,PVector C){
  return new PVector((C.x*P.x+C.y*P.y)/((C.x*C.x)+(C.y*C.y)),
  (C.x*P.y-C.y*P.x)/((C.x*C.x)+(C.y*C.y)));
}

public String PVstring(PVector P){
  return " X:"+ P.x+" Y:"+P.y;
}

public Boolean FLtween(float A,float B,float M){
  return ((M>=A)&&(M<=B))||((M<=A)&&(M>=B));
}

public int randomInt(int l,int h){
  int Answer=0;
  float Rand= random(l,h+1);
  if(Rand==h+1){
    Answer=h;
  }else{
    Answer=floor(Rand);
  }
  return Answer;
}
class Particle implements Comparable{ // Class for the paricles (atoms or functional groups)
    ChemSys Sys;// Chemical system it is in
    PVector pos;// Particle physical parameters
    PVector vel;
    PVector acc= new PVector(0,0);
    float radius;
    float mass;
    float charge; // Charge on particle
    int electrons; // number of free electrons
    int emax; // maximum number of electrons allowed
    int eneutral;  // number of electrons at neutral
    float eenergy; // amount of potential energy per electron;
    
    float angle;
    float angVel;
    float angAcc;
    float momInert;
    private float SavedPotential=0;// Variable for potential (so it doesn't have to be calculated every time.
    
    int NumSites; // Bonding parameters
    float[] bondAngles;
    float[] bondAngKs;
    Bond[] Sites;
    HBond[] HSites;
    
    int ColorR; // color
    int ColorG;
    int ColorB;
    
    int type; //Particle type
    
    Particle(ChemSys dSys, int dType, int dColorR,int dColorG, int dColorB, PVector dPos,PVector dVel,float dRad,float dMass
    , int dElectrons, int dEmax, int dEneutral, float dEenergy,   // Initialise all particel paramaters
    float dAngle, float dAngVel, float dAngAcc,float dMomInert,
    float[] dBondAngles ,float[] dBondAngKs,int NumHBonds){
      ColorR=dColorR; ColorG=dColorG; ColorB=dColorB;
      Sys=dSys;
      type=dType;
      pos=dPos; vel= dVel; radius= dRad; mass= dMass;
      electrons= dElectrons; emax= dEmax; eneutral= dEneutral; eenergy= dEenergy;
      angle= dAngle; angVel=dAngVel;angAcc=dAngAcc; momInert=dMomInert;
      bondAngles=dBondAngles;  bondAngKs=dBondAngKs;
      NumSites=bondAngles.length;
      Sites= new Bond[NumSites];
      HSites= new HBond[NumHBonds];
      charge= charge();
    }
    //Particle(ChemSys dSys,int dType,PVector dPos,PVector dVel,float dRad,float dMass,float dCharge,
    //float dAngle, float dAngVel, float dAngAcc,float dMomInert,
    //float[] dBondAngles,float[] dBondAngKs,Particle dP){
    //  Sys=dSys;
    //  type=dType;
    //  pos=dPos; vel= dVel; radius= dRad; mass= dMass; charge= dCharge; angle= dAngle; angVel=dAngVel;angAcc=dAngAcc; momInert=dMomInert; bondAngles=dBondAngles;  bondAngKs=dBondAngKs;
    //  //Bond B=Sys.BondBetween(this,dP,);
    //  //Sys.Bonds.add();
    //  //bondP=Sys.BondBetween(this,dP);
    //}
    
    
    public void Draw(Cam Camera){// Draw particel
      //fill(60,20,220);
      strokeWeight(4/Camera.Scale);
      if(charge<0){
        stroke(10,30,255) ;
      }else if(charge>0){
        stroke(255,10,30) ;
      }else{
        stroke(10,255,30) ;
      }
      fill(ColorR,ColorG,ColorB);
      //stroke(255);
      //strokeWeight(5.0/Camera.Scale);
      //if(bonded){
      //   bondP.Draw(Camera);
      //   //line(Camera.RealToScreenX(pos.x),Camera.RealToScreenY(pos.y),Camera.RealToScreenX(bondP.pos.x),Camera.RealToScreenY(bondP.pos.y));
      //}
      //noStroke();
      ellipse(Camera.RealToScreenX(pos.x),Camera.RealToScreenY(pos.y),radius*2/Camera.Scale,radius*2/Camera.Scale); 
      stroke(255);
      strokeWeight(2.0f/Camera.Scale);
      line(Camera.RealToScreenX(pos.x),Camera.RealToScreenY(pos.y),Camera.RealToScreenX(pos.x)+radius*sin(angle)/Camera.Scale,Camera.RealToScreenY(pos.y)+radius*cos(angle)/Camera.Scale);
      strokeWeight(1.3f/Camera.Scale);
      for(int i=0; i<bondAngles.length;i++){
        line(Camera.RealToScreenX(pos.x),Camera.RealToScreenY(pos.y),Camera.RealToScreenX(pos.x)+radius*sin(angle+bondAngles[i])/Camera.Scale,Camera.RealToScreenY(pos.y)+radius*cos(angle+bondAngles[i])/Camera.Scale);
      }
      
      fill(255);
      textSize(18.0f/Camera.Scale);
      text(Sys.Symbols[type],Camera.RealToScreenX(pos.x)-5/Camera.Scale,Camera.RealToScreenY(pos.y)+5/Camera.Scale);
      

    }
    public float potential(){// Calculate potential energy of particle (Electric potenetial energy)
       float pot=0;
       pot-=mass*(pos.x*Sys.GRAV.x+pos.y*Sys.GRAV.y);
       for(int i=0;i<Sys.Particles.size();i++){
         Particle other =Sys.Particles.get(i);
         if(other != this){
           float dist=PVmag(PVadd(pos,PVneg(other.pos)));
           pot+= charge*other.charge/max(radius+other.radius,dist);
           //if( dist<Sys.hBondLength[type][other.type]){
           //  pot-= (Sys.hBondLength[type][other.type]- dist)*Sys.hBondForce[type][other.type];
           //}
         }
       }
       //if(bonded){
       //  pot+=bondP.Potential();
       //}
       pot+=electrons*eenergy;// Ionic componetnt of energy
       SavedPotential=pot;
       return pot;
    }
    public float kinetic(){// KE
      return 0.5f*mass*PVmag(vel)*PVmag(vel)+0.5f*momInert*angVel*angVel;
    }
    public float energy(){
       return kinetic()+SavedPotential;
    }
    public int numBonds(){
      int num=0;
      for(int i=0; i<Sites.length;i++){
         if(Sites[i]!=null){
            num+=1;//Or charge distrib *LATER 
         }
      }
      return num;
    }
    public float charge(){
      charge= eneutral-electrons;
      for(int i=0; i<Sites.length;i++){
         if(Sites[i]!=null){
            charge-=Sites[i].electronsOn(this);//Or charge distrib *LATER 
         }
      }
      return charge;
    }
    public void UpdatePos(){// Update pstion and angle
      pos=PVadd(pos,vel);
      //PVadd(pos,PVadd(vel,PVscale(acc,0.5)));
      angle+=angVel;
      //angle+=angVel+0.5*angAcc;
    }
    public void UpdateVel(){
      vel=PVadd(vel,acc);
      acc=Sys.GRAV;

      angle%=TWO_PI;
      angVel+=angAcc;
      angVel*=0.45f;
      angAcc=0;
    }
    public void Update(){
      UpdatePos();
      UpdateVel();
    }
    public float ForceMag(float d,float f){ // Maginitude of electric force given distance and charge
       if(d>radius){
         return 0; 
       }
       return f*(radius*radius/(d*d));
    }
    public void ApplyForce(PVector force){
       acc=PVadd(acc,PVscale(force,1.0f/mass));
    }
    public void ApplyTorque(float torque){
      angAcc+=torque/momInert;
    }
    public PVector Field(PVector otherPos){
      PVector AxisX=PVadd(pos,PVneg(otherPos));  
      float dist2=max(pow(radius,2),AxisX.x*AxisX.x+AxisX.y*AxisX.y);
      return PVsetMag(AxisX,charge/dist2);
    }
    public void Affect(Particle other){ /// Affect other particles electirically
      PVector AxisX=PVadd(pos,PVneg(other.pos));  
      
       //EM
       float dist2=max(pow(radius+other.radius,2),AxisX.x*AxisX.x+AxisX.y*AxisX.y);
       if(dist2>0){
         ApplyForce(PVsetMag(AxisX,charge*other.charge/dist2));
         other.ApplyForce(PVsetMag(PVneg(AxisX),charge*other.charge/dist2));
       }
       //if(dist2<pow(Sys.hBondRadius[type][other.type],2)){
       //  PVector dir=PVadd(other.pos,PVneg(pos));
       //  ApplyForce(PVsetMag(dir,Sys.hBondForce[type][other.type]));
       //  other.ApplyForce(PVneg(PVsetMag(dir,Sys.hBondForce[type][other.type])));
       //}
    }
    // Checks if bondend to othe partiles
    public boolean BondedTo(Particle other){ 
      for( int b=0; b<Sites.length;b++){
        if(Sites[b]!=null){
          if(Sites[b].Connects(other)){
            return true;
          }
        }
      }
      return false;
    }
    public boolean HBondedTo(Particle other){
      for( int b=0; b<HSites.length;b++){
        if(HSites[b]!=null){
          if(HSites[b].Connects(other)){
            return true;
          }
        }
      }
      return false;
    }
    // Checks if colliding
    public boolean Collides(Particle other){
      PVector AxisX=PVadd(pos,PVneg(other.pos));  
      PVector RelV1=PVdivide(vel,AxisX);
      PVector RelV2=PVdivide(other.vel,AxisX);
      return  (PVmag(AxisX)<(radius+other.radius))&&(RelV1.x<RelV2.x);
    }
    public float EnergyOfCollision(Particle other){// maximum energy u can remove without breaking physics
       PVector AxisX=PVsetMag(PVadd(pos,PVneg(other.pos)),1);  
       if(PVmag(PVadd(pos,PVneg(other.pos)))<(radius+other.radius)){
         PVector RelV1=PVdivide(vel,AxisX);
         PVector RelV2=PVdivide(other.vel,AxisX);
         if(RelV1.x<RelV2.x){//Collides
             float m1= mass;
             float m2= other.mass;
             float v1x= RelV1.x;
             float v2x= RelV2.x;
             return 0.5f*(v1x-v2x)*(v1x-v2x)*m1*m2/(m1+m2);
         }
       }
       return 0;
    }
    // Collides particle, and adds specified amount of enegry
    public void Collide(Particle other, float energyadded){
      //Collide
      float k=energyadded*2;
      PVector AxisX=PVsetMag(PVadd(pos,PVneg(other.pos)),1);  
       if( PVmag(PVadd(pos,PVneg(other.pos)))<(radius+other.radius) ){
          //PVector AxisY=new PVector(-AxisX.y,AxisX.x);
          PVector RelV1=PVdivide(vel,AxisX);
          PVector RelV2=PVdivide(other.vel,AxisX);
          if(RelV1.x<RelV2.x){//Collides
             float m1= mass;
             float m2= other.mass;
             float v1x= RelV1.x;
             float v1y= RelV1.y;
             float v2x= RelV2.x;
             float v2y= RelV2.y;
             float f1x= (m2*m1*v2x+m1*m1*v1x+sqrt(m2*m2*m1*m1*(v2x-v1x)*(v2x-v1x)+m2*m1*(m2+m1)*k))/(m1*(m2+m1));
             float f2x= (m1*m2*v1x+m2*m2*v2x-sqrt(m1*m1*m2*m2*(v1x-v2x)*(v1x-v2x)+m1*m2*(m1+m2)*k))/(m2*(m1+m2));
             
             //float f1x= ((m1-m2)*v1x+2*m2*v2x)/(m1+m2);
             //float f2x= (2*m1*v1x+(m2-m1)*v2x)/(m1+m2);
             PVector f1= new PVector(f1x,v1y);
             PVector f2= new PVector(f2x,v2y);
             vel= PVmult(f1,AxisX);
             other.vel=PVmult(f2,AxisX);
          }
       }
        
    }
    
    //Colllide wall
    public void CollideWall(){
      if(pos.x<radius){
        vel=new PVector(abs(vel.x),vel.y);
      }
      if(pos.x>Sys.Size.x-radius){
        vel=new PVector(-abs(vel.x),vel.y);
      }
      //if(pos.x>mouseX-radius){
      //  vel=new PVector(-abs(vel.x),vel.y);
      //}
      if(pos.y<radius){
        vel=new PVector(vel.x,abs(vel.y));
      }
      if(pos.y>Sys.Size.y-radius){
         vel=new PVector(vel.x,-abs(vel.y));
      }
    }
    
    public int compareTo(Object P) { //DEFUNCT
      return Float.compare(((Particle)P).kinetic(),kinetic());
    }
}
class Bond{// Class for covalent bonds
    //Physical parameters
   float bondLength;
   float bondK;
   float bondEnergy;
   float dipole;// Extra charge transferred from A to B, A charge = -1 + dipole, B charge = -1 - dipole 
   
   //Particels and bonding sites
   Particle A;
   int AInd;
   Particle B;
   int BInd;
   private float Potential;
   
   Bond(float dBondLength, float dBondK,float dBondEnergy,float dDipole, Particle dA,int dAInd,Particle dB,int dBInd){ /// Initialise bonds
    bondLength=dBondLength; bondK=dBondK; bondEnergy= dBondEnergy; dipole= dDipole; A=dA; AInd=dAInd; B=dB; BInd=dBInd;
   }
   
   public boolean Connects(Particle other){ // Check if bond connects to a certain particel
      return (A==other)||(B==other); 
   }
   public void Update(){ /// Update particles attactched to bond
      PVector dir=PVadd(A.pos,PVneg(B.pos));
       float dist= PVmag(dir);
       float disp=bondLength-dist;
       float fMag=disp*bondK;
       PVector force=PVsetMag(dir,fMag);
       A.ApplyForce(force);
       B.ApplyForce(PVneg(force));
       
       //Angular
       if(dist>0){
         float bondedAngle= atan2(B.pos.x-A.pos.x,B.pos.y-A.pos.y);
         float angDisp= (A.angle+A.bondAngles[AInd]-bondedAngle)%TWO_PI;
         if(angDisp>PI){
           angDisp=angDisp-TWO_PI;
         }
         float tMag= angDisp*A.bondAngKs[AInd];
         A.ApplyTorque(-tMag);
         float ftMag= 2*tMag/dist;
         //println("ftMag: "+ftMag);
         PVector tforce= PVsetMag(new PVector(dir.y,-dir.x),-ftMag);
         B.ApplyForce(tforce);
         //ApplyForce(PVneg(tforce));
         float bondDisp= (B.angle-bondedAngle+B.bondAngles[BInd])%TWO_PI;// B Bonding site angle here
         if(bondDisp>PI){
           bondDisp=bondDisp-TWO_PI;
         }
         float bondTMag= bondDisp*B.bondAngKs[BInd];
         B.ApplyTorque(bondTMag);
         float bondFTMag= 2*bondTMag/dist;
         PVector bondTForce= PVsetMag(new PVector(-dir.y,dir.x),bondFTMag);
         A.ApplyForce(bondTForce);    
       }
   }
   public float SetPotential(){ //Calculate potential energy of  abond , and store it
     float pot=-bondEnergy;
     float dist=PVmag(PVadd(A.pos,PVneg(B.pos)));
     float disp=dist-bondLength;
     pot+= 0.5f*bondK*(disp*disp); // linear EPE
     
     float bondAngle= atan2(B.pos.x-A.pos.x,B.pos.y-A.pos.y);
     float angDisp= (A.angle-bondAngle+A.bondAngles[AInd])%TWO_PI;
     if(angDisp>PI){
       angDisp=angDisp-TWO_PI;
     }
     pot+= 0.5f*A.bondAngKs[AInd]*(angDisp*angDisp);  // Angular EPE
     float bondDisp= (B.angle-bondAngle+B.bondAngles[BInd])%TWO_PI;
     if(bondDisp>PI){
       bondDisp=bondDisp-TWO_PI;
     }
     pot+= 0.5f*B.bondAngKs[BInd]*(bondDisp*bondDisp);
     
     // Dipole factor.
     pot+= dipole*(A.eenergy-B.eenergy);
     Potential=pot;
     return pot;
   }
   public float potential(){
     return Potential;
   }
   public float electronsOn(Particle P){
     if(P==A){
       return 1-dipole;
     }if(P==B){
        return 1+dipole; 
     }
     return 1;
   }
   public void Draw(Cam Camera){// Draw Bond
      stroke(255);
      strokeWeight(5.0f/Camera.Scale);
      //line(Camera.RealToScreenX(A.pos.x),Camera.RealToScreenY(A.pos.y),Camera.RealToScreenX(B.pos.x),Camera.RealToScreenY(B.pos.y));
                   //strokeWeight(2/Camera.Scale);
       PVector AScreen=new PVector( Camera.RealToScreenX(A.pos.x)+0.5f*A.radius*sin(A.angle+A.bondAngles[AInd])/Camera.Scale,Camera.RealToScreenY(A.pos.y)+0.5f*A.radius*cos(A.angle+A.bondAngles[AInd])/Camera.Scale);
       PVector BScreen=new PVector(Camera.RealToScreenX(B.pos.x)+0.5f*B.radius*sin(B.angle+B.bondAngles[BInd])/Camera.Scale,Camera.RealToScreenY(B.pos.y)+0.5f*B.radius*cos(B.angle+B.bondAngles[BInd])/Camera.Scale);
       PVector Mid= PVlerp(AScreen,BScreen,0.5f);
       if(dipole<0){
         stroke(255-140*abs(dipole),255-140*abs(dipole),255);
       }else{
         stroke(255,255-140*abs(dipole),255-140*abs(dipole));
       }
       line(AScreen.x,AScreen.y,Mid.x,Mid.y);
       if(dipole>0){
         stroke(255-140*abs(dipole),255-140*abs(dipole),255);
       }else{
         stroke(255,255-140*abs(dipole),255-140*abs(dipole));
       }
       line(Mid.x,Mid.y,BScreen.x,BScreen.y);
      PVector mid = new PVector((A.pos.x+B.pos.x)/2,(A.pos.y+B.pos.y)/2);
      fill(255,0,0);
      textSize(4.0f/Camera.Scale);
      text("BOND:"+nf(Potential,3,2),Camera.RealToScreenX(mid.x),Camera.RealToScreenY(mid.y));
 
   }
}
class HBond{// Class for HBOND
// Physical parameters
  float bondLength;
  float bondForce;
  Particle A;
  int AInd;
  Particle B;
  int BInd;
  private float Potential; // potential energy
  HBond(float dBondLength, float dBondForce, Particle dA, Particle dB){// Initialise
   bondLength= dBondLength; bondForce=dBondForce; A=dA; B=dB; 
  }
   public boolean Connects(Particle other){
      return (A==other)||(B==other); 
   }
  public void Update(){// Update particle s
      PVector AxisX=PVadd(A.pos,PVneg(B.pos));  
      float dist2=max(pow(A.radius+B.radius,2),AxisX.x*AxisX.x+AxisX.y*AxisX.y);
      if(dist2<pow(bondLength,2)){
         PVector dir=PVadd(B.pos,PVneg(A.pos));
         A.ApplyForce(PVsetMag(dir,bondForce));
         B.ApplyForce(PVneg(PVsetMag(dir,bondForce)));
      }
  }
  public float SetPotential(){ // Calculate and set potential enegry
     float pot=0;
     float dist=PVmag(PVadd(A.pos,PVneg(B.pos)));
     if( dist<bondLength){
       pot-= (bondLength- dist)*bondForce;
     }
     Potential=pot;
     return pot;
  }
  public float potential(){
    return Potential;  
  }
  public void Draw(Cam Camera){ // Draw particle
     //float dist= PVmag(PVadd(P.pos,PVneg(J.pos)));
     //if(dist<hBondRadius[P.type][J.type]){
       strokeWeight(bondForce*3.0f/Camera.Scale);
              //strokeWeight(2/Camera.Scale);
       PVector AScreen=Camera.RealToScreen(A.pos);
       PVector BScreen=Camera.RealToScreen(B.pos);
       line(AScreen.x,AScreen.y,BScreen.x,BScreen.y);
       //PVector Mid= PVlerp(AScreen,BScreen,0.5);
       //stroke(255-50,255-50,255);
       //line(AScreen.x,AScreen.y,Mid.x,Mid.y);
       //stroke(255,255-50,255-50);
       //line(Mid.x,Mid.y,BScreen.x,BScreen.y);
     //}
  }
  
}
  public void settings() {  size(1300,850,P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ChemSim_1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
