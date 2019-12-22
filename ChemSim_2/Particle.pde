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
    float[] eenergy; // amount of potential energy given electron;
    
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
    , int dElectrons, int dEmax, int dEneutral, float[] dEenergy,   // Initialise all particel paramaters
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
    
    
    void Draw(Cam Camera){// Draw particel
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
      strokeWeight(2.0/Camera.Scale);
      line(Camera.RealToScreenX(pos.x),Camera.RealToScreenY(pos.y),Camera.RealToScreenX(pos.x)+radius*sin(angle)/Camera.Scale,Camera.RealToScreenY(pos.y)+radius*cos(angle)/Camera.Scale);
      strokeWeight(1.3/Camera.Scale);
      for(int i=0; i<bondAngles.length;i++){
        line(Camera.RealToScreenX(pos.x),Camera.RealToScreenY(pos.y),Camera.RealToScreenX(pos.x)+radius*sin(angle+bondAngles[i])/Camera.Scale,Camera.RealToScreenY(pos.y)+radius*cos(angle+bondAngles[i])/Camera.Scale);
      }
      
      fill(255);
      textSize(18.0/Camera.Scale);
      text(Sys.Symbols[type],Camera.RealToScreenX(pos.x)-5/Camera.Scale,Camera.RealToScreenY(pos.y)+5/Camera.Scale);
      

    }
    float potential(){// Calculate potential energy of particle (Electric potenetial energy)
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
       pot+=eenergy[electrons];// Ionic componetnt of energy
       SavedPotential=pot;
       return pot;
    }
    float kinetic(){// KE
      return 0.5*mass*PVmag(vel)*PVmag(vel)+0.5*momInert*angVel*angVel;
    }
    float energy(){
       return kinetic()+SavedPotential;
    }
    int numBonds(){
      int num=0;
      for(int i=0; i<Sites.length;i++){
         if(Sites[i]!=null){
            num+=1;//Or charge distrib *LATER 
         }
      }
      return num;
    }
    float charge(){
      charge= eneutral-electrons;
      for(int i=0; i<Sites.length;i++){
         if(Sites[i]!=null){
            charge-=Sites[i].electronsOn(this);//Or charge distrib *LATER 
         }
      }
      return charge;
    }
    float differencialE(int egain){
      if(egain>0){
        return eenergy[max(min(emax,electrons+egain),0)]-eenergy[max(min(emax,electrons),0)]; 
      }else if(egain<0){
        return eenergy[min(max(0,electrons+egain),emax)]-eenergy[max(min(emax,electrons),0)]; 
      }
      return 0;
    }
    float differencialE(int givene,int egain){
      println("Calculating differnecial e"+ givene+"  "+egain+" "+type);
      //if(egain>0){
      println("after"+eenergy[max(min(emax,givene+egain),0)]+ "before"+ eenergy[min(max(0,givene),emax)]);
      return eenergy[max(min(emax,givene+egain),0)]-eenergy[min(max(0,givene),emax)]; 
      //}else if(egain<0){
      //  println("after"+eenergy[max(min(emax-1,givene+egain),0)]+ "before"+ eenergy[min(max(0,givene),emax-1)]
      //  return eenergy[min(max(0,givene+egain),emax-1)]-eenergy[min(max(0,givene),emax-1)]; 
      //}
      //return 0;
    }
    void UpdatePos(){// Update pstion and angle
      pos=PVadd(pos,vel);
      //PVadd(pos,PVadd(vel,PVscale(acc,0.5)));
      angle+=angVel;
      //angle+=angVel+0.5*angAcc;
    }
    void UpdateVel(){
      vel=PVadd(vel,acc);
      acc=Sys.GRAV;

      angle%=TWO_PI;
      angVel+=angAcc;
      angVel*=0.45;
      angAcc=0;
    }
    void Update(){
      UpdatePos();
      UpdateVel();
    }
    float ForceMag(float d,float f){ // Maginitude of electric force given distance and charge
       if(d>radius){
         return 0; 
       }
       return f*(radius*radius/(d*d));
    }
    void ApplyForce(PVector force){
       acc=PVadd(acc,PVscale(force,1.0/mass));
    }
    void ApplyTorque(float torque){
      angAcc+=torque/momInert;
    }
    PVector Field(PVector otherPos){
      PVector AxisX=PVadd(pos,PVneg(otherPos));  
      float dist2=max(pow(radius,2),AxisX.x*AxisX.x+AxisX.y*AxisX.y);
      return PVsetMag(AxisX,charge/dist2);
    }
    void Affect(Particle other){ /// Affect other particles electirically
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
    boolean BondedTo(Particle other){ 
      for( int b=0; b<Sites.length;b++){
        if(Sites[b]!=null){
          if(Sites[b].Connects(other)){
            return true;
          }
        }
      }
      return false;
    }
    boolean HBondedTo(Particle other){
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
    boolean Collides(Particle other){
      PVector AxisX=PVadd(pos,PVneg(other.pos));  
      PVector RelV1=PVdivide(vel,AxisX);
      PVector RelV2=PVdivide(other.vel,AxisX);
      return  (PVmag(AxisX)<(radius+other.radius))&&(RelV1.x<RelV2.x);
    }
    float EnergyOfCollision(Particle other){// maximum energy u can remove without breaking physics
       PVector AxisX=PVsetMag(PVadd(pos,PVneg(other.pos)),1);  
       if(PVmag(PVadd(pos,PVneg(other.pos)))<(radius+other.radius)){
         PVector RelV1=PVdivide(vel,AxisX);
         PVector RelV2=PVdivide(other.vel,AxisX);
         if(RelV1.x<RelV2.x){//Collides
             float m1= mass;
             float m2= other.mass;
             float v1x= RelV1.x;
             float v2x= RelV2.x;
             return 0.5*(v1x-v2x)*(v1x-v2x)*m1*m2/(m1+m2);
         }
       }
       return 0;
    }
    // Collides particle, and adds specified amount of enegry
    void Collide(Particle other, float energyadded){
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
    void CollideWall(){
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
    
    int compareTo(Object P) { //DEFUNCT
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
   
   boolean Connects(Particle other){ // Check if bond connects to a certain particel
      return (A==other)||(B==other); 
   }
   void Update(){ /// Update particles attactched to bond
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
   float SetPotential(){ //Calculate potential energy of  abond , and store it
     float pot=-bondEnergy;
     float dist=PVmag(PVadd(A.pos,PVneg(B.pos)));
     float disp=dist-bondLength;
     pot+= 0.5*bondK*(disp*disp); // linear EPE
     
     float bondAngle= atan2(B.pos.x-A.pos.x,B.pos.y-A.pos.y);
     float angDisp= (A.angle-bondAngle+A.bondAngles[AInd])%TWO_PI;
     if(angDisp>PI){
       angDisp=angDisp-TWO_PI;
     }
     pot+= 0.5*A.bondAngKs[AInd]*(angDisp*angDisp);  // Angular EPE
     float bondDisp= (B.angle-bondAngle+B.bondAngles[BInd])%TWO_PI;
     if(bondDisp>PI){
       bondDisp=bondDisp-TWO_PI;
     }
     pot+= 0.5*B.bondAngKs[BInd]*(bondDisp*bondDisp);
     
     // Dipole factor.
     if(dipole>0){
       pot+= dipole*(A.differencialE(-1)+B.differencialE(1));
     }else{
       pot+= -dipole*(A.differencialE(1)+B.differencialE(-1)); 
     }
     
     //if(dipole>0){
     //  float Adiff=0;
     //  if(A.electrons>0){
     //    Adiff=A.eenergy[A.electrons]-A.eenergy[A.electrons-1];
     //  }else{
     //    Adiff=A.eenergy[A.electrons];
     //  }
     //  float Bdiff=0;
     //  if(B.electrons<B.emax){
     //    Bdiff=B.eenergy[B.electrons+1]-B.eenergy[B.electrons];
     //  }else{
     //    Bdiff=B.eenergy[B.electrons]-B.eenergy[B.electrons-1];
     //  }
     //  pot+= dipole*(Adiff-Bdiff);
     //}else{
     //  float Adiff=0;
     //  if(A.electrons<A.emax){
     //    Adiff=A.eenergy[A.electrons+1]-A.eenergy[A.electrons];
     //  }else{
     //    Adiff=A.eenergy[A.electrons]-A.eenergy[A.electrons-1];
     //  }
     //  float Bdiff=0;
     //  if(B.electrons>0){
     //    Bdiff=B.eenergy[B.electrons]-B.eenergy[B.electrons-1];
     //  }else{
     //    Bdiff=B.eenergy[B.electrons]-B.eenergy[B.electrons-1];
     //  }
     //  pot+= dipole*(Adiff-Bdiff);
     //}
     
     Potential=pot;
     return pot;
   }

   float potential(){
     return Potential;
   }
   float electronsOn(Particle P){
     if(P==A){
       return 1-dipole;
     }if(P==B){
        return 1+dipole; 
     }
     return 1;
   }
   void Draw(Cam Camera){// Draw Bond
      stroke(255);
      strokeWeight(5.0/Camera.Scale);
      //line(Camera.RealToScreenX(A.pos.x),Camera.RealToScreenY(A.pos.y),Camera.RealToScreenX(B.pos.x),Camera.RealToScreenY(B.pos.y));
                   //strokeWeight(2/Camera.Scale);
       PVector AScreen=new PVector( Camera.RealToScreenX(A.pos.x)+0.5*A.radius*sin(A.angle+A.bondAngles[AInd])/Camera.Scale,Camera.RealToScreenY(A.pos.y)+0.5*A.radius*cos(A.angle+A.bondAngles[AInd])/Camera.Scale);
       PVector BScreen=new PVector(Camera.RealToScreenX(B.pos.x)+0.5*B.radius*sin(B.angle+B.bondAngles[BInd])/Camera.Scale,Camera.RealToScreenY(B.pos.y)+0.5*B.radius*cos(B.angle+B.bondAngles[BInd])/Camera.Scale);
       PVector Mid= PVlerp(AScreen,BScreen,0.5);
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
      textSize(4.0/Camera.Scale);
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
   boolean Connects(Particle other){
      return (A==other)||(B==other); 
   }
  void Update(){// Update particle s
      PVector AxisX=PVadd(A.pos,PVneg(B.pos));  
      float dist2=max(pow(A.radius+B.radius,2),AxisX.x*AxisX.x+AxisX.y*AxisX.y);
      if(dist2<pow(bondLength,2)){
         PVector dir=PVadd(B.pos,PVneg(A.pos));
         A.ApplyForce(PVsetMag(dir,bondForce));
         B.ApplyForce(PVneg(PVsetMag(dir,bondForce)));
      }
  }
  float SetPotential(){ // Calculate and set potential enegry
     float pot=0;
     float dist=PVmag(PVadd(A.pos,PVneg(B.pos)));
     if( dist<bondLength){
       pot-= (bondLength- dist)*bondForce;
     }
     Potential=pot;
     return pot;
  }
  float potential(){
    return Potential;  
  }
  void Draw(Cam Camera){ // Draw particle
     //float dist= PVmag(PVadd(P.pos,PVneg(J.pos)));
     //if(dist<hBondRadius[P.type][J.type]){
       strokeWeight(bondForce*3.0/Camera.Scale);
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