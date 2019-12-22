import java.util.*;
/*
FORKED FOR: DIFFERNCIAL ENERGIES
   TODO: 1) Fix Covaalent bonding- issues: fixed                                                | CHECK
             1.5)/ Add double/triple/quadruple bondi : done                                     | CHECK
             1.6) Make functional way to set bond parameters without messing with array values  | CHECK
             1.7) Make different bonding sites only accept certain bonds               
  
            2) HBonding limited in number, to fix the nucleotide problem                        | CHECK
             2.3) Fix hbonding bugs                                                             | CHECK (?) 
             2.4) Strict HBonding angles   (IDK)                                                     
             2.5) Make a bonding parent class (polymorphise bonds) LATER
             2.6) HBonding charge dependent ( For nonpolar hydrocarbons) 
            3) Coment code                                                                       | CHECK (KINDA)
          
            4)  Add ionic bonding/ charge and stuff                                             | CHECK  
             4.01) Ionisation reaction (Na + Cl -> Na+ + Cl- )                                  | CHECK
             4.02) Semiionisation reaction (2Na + 2H20 -> 2NaOH + H2 ) (semi reduced H+ )       | CHECK
             4.1) Dipole moment                                                                 | CHECK
             4.3) Autoionisation (Polarazation during bond breakdown)                           | CHECK
             4.4) Electron uneven sourcing( so that OH- and H+ can react )                      | CHECK
             4.5) Differencial electron energires(energy tables) (so semiionisation can occur)  | CHECK
             4.6) Acid base reactions: Strong acid, weak acid simulation
             4.7) Acidic/basic salts                                                            
      
            5) Polar and nonpolar effects                                                       | CHECK
             5.1) soluble/insoluble salts                                                       
             5.2) Lipid bilayer
          
            6) Run chemical evolution enviroment 
             6.1) Overview of different chemical species
             6.2) Classify seperate molecules, and determine chemical species
             6.3) Evolutionary Heuristics: ?
                 # of species, conc of unique species, Special catalysis
            
            7) Advanced biological RXN's
              7.1) Kinases
              7.2) Nucleic acid synthesis/ nucleotide synthesis
              7.3) Basic protien synthesis
*/

// DEFINE SYSTEM VARIABLES
ChemSys System;
Cam Camera= new Cam(new PVector(-15,-20),0.5);
// DEFINE ALL THE PARTICLE TYPES
ArrayList<PartType> Types;
PartType Hydro=   new PartType(/*Type*/0, /*Color*/ new int[]{255,10,30}, /*radius*/8 ,/*mass*/10,/*electrons*/1,/*max electrons*/2,/*e neutral*/1,/*electron energy*/new float[]{0,0,-20},/*mom inert*/15,/*Bond angles*/new float[]{0},/*Bond ang K*/new float[]{0.2},/*Num HBonds*/1);
PartType Oxy=     new PartType(/*Type*/1, /*Color*/ new int[]{10,30,255}, /*radius*/15,/*mass*/20,/*electrons*/2,/*max electrons*/4,/*e neutral*/2,/*electron energy*/new float[]{0,0,0},/*mom inert*/15,/*Bond angles*/new float[]{3.14,1.8},/*Bond ang K*/new float[]{0.2,0.2},/*Num HBonds*/2);
PartType Sodi=    new PartType(/*Type*/2, /*Color*/ new int[]{10,30,255}, /*radius*/25,/*mass*/35,/*electrons*/1,/*max electrons*/1,/*e neutral*/1,/*electron energy*/new float[]{0,-20},/*mom inert*/40,/*Bond angle*/new float[]{0},/*Bond K*/new float[]{2},0);
PartType Chlori=  new PartType(/*Type*/3, /*Color*/ new int[]{10,30,255}, /*radius*/25,/*mass*/35,/*electrons*/0,/*max electrons*/1,/*e neutral*/0,/*electron energy*/new float[]{0,20},/*mom inert*/30,/*Bond angle*/new float[]{0},/*Bond K*/new float[]{2},0);
 
void setup(){
  size(1300,850,P2D);
  Types= new ArrayList<PartType> ();
  Types.add(Hydro);  
  Types.add(Oxy);
  Types.add(Sodi);
  Types.add(Chlori);
  
  String[] Symbols= new String[]{"H","O","Na","Cl","C","Adi","Ura","Cyt","Gua","Ribo","PO4"};// Particle names

  //System= new ChemSys(Types,Symbols,new PVector(1000,800));
  System= new ChemSys(Types,Symbols,new PVector(500,400));
  
  //SET ALL THE BONDING CHARACTERISTICS
  /* H <-> H */System.SetCovalentBond(0,0,/*bond length*/20.0,/*bond k*/0.06,/*bond energy*/10.0,/*bond extra*/0.0,/*Activation*/3.0,/*Dipole*/ 0, /*Brakedown distribution*/ 0);
  /* H <-> O */System.SetCovalentBond(0,1,/*bond length*/30.0,/*bond k*/0.25,/*bond energy*/55,/*bond extra*/0.0,/*Activation*/20.0,/*Dipole*/ 0.2,/*Brakedown distribution*/1); // Give electron to oxygen
  /* O <-> O */System.SetCovalentBond(1,1,/*bond length*/30.0,/*bond k*/0.1,/*bond energy*/25,/*bond extra*/10,/*Activation*/3.0,/*Dipole*/ 0,/*Brakedown distribution*/0);
  
  //ADD WATER
  PVector Pos;
  for(int i=0; i<0;i++){
    Pos= new PVector(random(System.Size.x),random(System.Size.y));
    Particle A=Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,0.01),-2,0.0,1.0);
    Particle B=Oxy.Gen(System,new PVector(Pos.x-30,Pos.y),new PVector(0,0.01),-2,0,1); 
    Particle C=Hydro.Gen(System,new PVector(Pos.x-60,Pos.y),new PVector(0,0.01),-2,0,1);
    System.AddBondBetween(A,0,B,0);
    System.AddBondBetween(C,0,B,1);
    
    System.AddParticle(A);
    System.AddParticle(B);
    System.AddParticle(C);
  }
  System.ENERGY=100;
  //System.FixEnergy();
}
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
      if(System.TEMP>0.01){
        System.TEMP-=0.01;
      }
    }
    if(key=='s'){
        //System.ENERGY+=5;
        System.TEMP+=0.01;
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
    if(key=='e'){ //Create monatomic H
      System.AddParticle(Hydro.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,2),-2,0.0,1.0,/* electrons */0));
      System.FixEnergy();
    }
    if(key=='r'){// Create monatomic O
      System.AddParticle(Oxy.Gen(System,new PVector(Pos.x,Pos.y),new PVector(0,2),-2,0.0,1.0,/* electrons */2));
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