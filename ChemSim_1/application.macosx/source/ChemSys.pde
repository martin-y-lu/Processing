class Cam{ // Camera class
  PVector Pos= new PVector(0,0);
  float Scale=1;
  Cam(PVector dPos,float dScale){
    Pos=dPos; Scale=dScale;
  }
  
  PVector RealToScreen(PVector real){ // Converting real space to screen space
   return PVscale(PVadd(real,PVneg(Pos)),1/Scale); 
  }
  float RealToScreenX(float realX){
    return (realX-Pos.x)/Scale; 
  }
  float RealToScreenY(float realY){
    return (realY-Pos.y)/Scale; 
  }
  PVector ScreenToReal(PVector screen){  //Converting screen space to real space
   return PVadd(PVscale(screen,Scale),Pos); 
  } 
  float ScreenToRealX(float screenX){
    return (screenX*Scale)+Pos.x; 
  }
  float ScreenToRealY(float screenY){
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
 PVector GRAV=new PVector(0,0.00002);// Gravitational acceleration
 float ENERGY=0;// Mechanical energy of system, to be conseverd
 float TEMP=0.6;
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
 void SetHydrogenBond(int AInd,int BInd, float BondRadius, float BondForce){ // Set HBOND characteristics
   hBondLength[AInd][BInd]=BondRadius; 
   hBondLength[BInd][AInd]=BondRadius; 
   hBondForce[AInd][BInd]=BondForce; 
   hBondForce[BInd][AInd]=BondForce; 
 }
 void SetCovalentBond(int AInd,int BInd, float BondLength, float BondK,float BondEnergy, float BondExtra, float BondActivation,float Dipole,int BreakDistrib){ // Set covalent bond characteristics
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
 PVector EField(PVector Pos){ // E field at point
    PVector field= new PVector(0,0);
    for( Particle P: Particles){
      field= PVadd(field,P.Field(Pos));
    }
    return field;
  }
  
  float TotEnergy(){ //Total mechanical energy
    //float totEnergy=0;
    //for(int i=0;i<Particles.size();i++){
    // totEnergy+=Particles.get(i).energy(); 
    //}
    return TotPotential()+TotKinetic();
  }
  float TotPotential(){// Total potential energy
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
  float TotKinetic(){ // Total kinetic enegy
    float totKin=0;
    for(int i=0;i<Particles.size();i++){
     totKin+=Particles.get(i).kinetic(); 
    }
    return totKin;
  }
  void RescaleVel(){// Rescales velocities, and angular velcities such that total energy is constant
      //Collections.sort(Particles);
      //float pow=0;
      //float skew=1;
      float actualKinetic= TotKinetic();
      float targetKinetic= ENERGY-TotPotential();
      
      //float integ=(pow(skew+1,pow+1)-pow(skew,pow+1))/(pow+1);
      for(int i=0;i<Particles.size();i++){//Fix velocities to conserve energy
        //float rank=((float) i)/(Particles.size()-1);
        float scale=max(targetKinetic/actualKinetic,0);//*pow(rank+skew,pow)/integ;
        scale=pow(scale,0.5);
        
        Particles.get(i).vel=PVscale(Particles.get(i).vel,scale);
        Particles.get(i).angVel*=scale;
      }
  }
  void DrawFieldLines(Cam Camera){ // Draws efield lines // DEFUNCT FIX LATER
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
  void DrawParticles(Cam Camera){/// Draws all particles on screen
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
  void Draw(Cam Camera){ // Draw the Chemical sustem
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
  float PotentialBondEnergy( Particle A, int AInd, Particle B, int BInd){ // Potential bond energy IF there were to be a covalent bond between Particle A, and Particle B in the specified bonding sites
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
     pot+= 0.5*bondK*(disp*disp); // Linear elastic potential energy
     
     float bondAngle= atan2(B.pos.x-A.pos.x,B.pos.y-A.pos.y);
     float angDisp= (A.angle+A.bondAngles[AInd]-bondAngle)%TWO_PI;
     if(angDisp>PI){
       angDisp=angDisp-TWO_PI;
     }
     pot+= 0.5*A.bondAngKs[AInd]*(angDisp*angDisp);  // Angular EPE
     float bondDisp= (bondAngle-B.angle-B.bondAngles[BInd])%TWO_PI;
     if(bondDisp>PI){
       bondDisp=bondDisp-TWO_PI;
     }
     pot+= 0.5*B.bondAngKs[BInd]*(bondDisp*bondDisp);
     pot+= cDipole[A.type][B.type]*(A.eenergy-B.eenergy);
     return pot;
  }
  void Update(){// Real update function
    for(int s=0;s<SPEED;s++){
      OneUpdate();
    } 
    if(SPEED<0){
      if(frameCount%-SPEED==0){
        OneUpdate(); 
      }
    }
  }
  void OneUpdate(){// Updates particles, energies, and bonds
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
  void CheckCollision(Particle A, Particle B){ // CHecks all collision dynamics between pair of particles, determines if new bond should be formed, and creates it
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
  void CheckHBond(Particle A, Particle B){ // Checks if Particles are in range for an HBOND, and if they can accept one.
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
  
  void RemoveParticle(int p){
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
  void RemoveBond(int i){ 
    RemoveBond(Bonds.get(i));
  }
  void RemoveBond(Bond BOND){ 
    BOND.A.Sites[BOND.AInd]=null;
    BOND.B.Sites[BOND.BInd]=null;
    BOND.A.electrons+= 1 - cBreakDistrib[BOND.A.type][BOND.B.type]; //Return electrons
    BOND.B.electrons+= 1 + cBreakDistrib[BOND.A.type][BOND.B.type]; //Return electrions
    BOND.A.charge();//Set charges
    BOND.B.charge();
    Bonds.remove(BOND);
  }
  void RemoveHBond(int h){
    //println("HBOND Remove");
    HBond HBOND=HBonds.get(h);
    HBOND.A.HSites[HBOND.AInd]=null;
    HBOND.B.HSites[HBOND.BInd]=null;
    HBonds.remove(HBOND);
  }
  void AddParticle(Particle P){
    Particles.add(P);
  }
  void FixEnergy(){
    ENERGY= TotEnergy();
  }
  // Add new bonds, and set bonding sites.
  Bond AddBondBetween(Particle A,int AInd,Particle B,int BInd){
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
  HBond AddHBondBetween(Particle A,int AInd,Particle B, int BInd){
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
    Particle Gen(ChemSys dSys,PVector dPos,PVector dVel,float dAngle, float dAngVel, float dAngAcc){
      return new Particle(dSys,type,colorR,colorG,colorB,dPos,dVel,radius,mass,
      electrons,emax, eneutral,eenergy,
      dAngle, dAngVel, dAngAcc,momInert,
      bondAngles,bondAngKs,numHBonds); 
    }
    Particle Gen(ChemSys dSys,PVector dPos,PVector dVel,float dAngle, float dAngVel, float dAngAcc,int setElectrons){
      return new Particle(dSys,type,colorR,colorG,colorB,dPos,dVel,radius,mass,
      setElectrons,emax, eneutral,eenergy,
      dAngle, dAngVel, dAngAcc,momInert,
      bondAngles,bondAngKs,numHBonds); 
    }
    Particle Gen(ChemSys dSys,PVector dPos,PVector dVel,float dAngle, float dAngVel, float dAngAcc, Particle dB,int AInd,int BInd){
      Particle P= new Particle(dSys,type,colorR,colorG,colorB,dPos,dVel,radius,mass,
      electrons,emax, eneutral,eenergy,
      dAngle, dAngVel, dAngAcc,momInert,
      bondAngles,bondAngKs,numHBonds);
      dSys.AddBondBetween(P,AInd,dB,BInd);
      return P; 
    }
}