class Particle implements Comparable{
    ChemSys Sys;
    PVector pos;
    PVector vel;
    PVector acc= new PVector(0,0);
    float radius;
    float mass;
    float charge;
    float angle;
    float angVel;
    float angAcc;
    float momInert;
    
    int NumSites;
    float[] bondAngles;
    float[] bondAngKs;
    Bond[] Sites;
    
    int type;
    
    Particle(ChemSys dSys, int dType, PVector dPos,PVector dVel,float dRad,float dMass,float dCharge,
    float dAngle, float dAngVel, float dAngAcc,float dMomInert,
    float[] dBondAngles ,float[] dBondAngKs){
      Sys=dSys;
      type=dType;
      pos=dPos; vel= dVel; radius= dRad; mass= dMass; charge= dCharge; 
      angle= dAngle; angVel=dAngVel;angAcc=dAngAcc; momInert=dMomInert;
      bondAngles=dBondAngles;  bondAngKs=dBondAngKs;
      NumSites=bondAngles.length;
      Sites= new Bond[NumSites];
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
    
    
    void Draw(Cam Camera){
      //fill(60,20,220);
      if(charge<0){
        fill(10,30,255) ;
      }else if(charge>0){
        fill(255,10,30) ;
      }else{
         fill(10,255,30) ;
      }
      //stroke(255);
      //strokeWeight(5.0/Camera.Scale);
      //if(bonded){
      //   bondP.Draw(Camera);
      //   //line(Camera.RealToScreenX(pos.x),Camera.RealToScreenY(pos.y),Camera.RealToScreenX(bondP.pos.x),Camera.RealToScreenY(bondP.pos.y));
      //}
      noStroke();
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
    float potential(){
       float pot=0;
       pot-=mass*(pos.x*Sys.GRAV.x+pos.y*Sys.GRAV.y);
       for(int i=0;i<Sys.Particles.size();i++){
         Particle other =Sys.Particles.get(i);
         if(other != this){
           float dist=PVmag(PVadd(pos,PVneg(other.pos)));
           pot+= charge*other.charge/max(radius+other.radius,dist);
           if( dist<Sys.hBondRadius[type][other.type]){
             pot-= (Sys.hBondRadius[type][other.type]- dist)*Sys.hBondForce[type][other.type];
           }
         }
       }
       //if(bonded){
       //  pot+=bondP.Potential();
       //}
       return pot;
    }
    float kinetic(){
      return 0.5*mass*PVmag(vel)*PVmag(vel)+0.5*momInert*angVel*angVel;
    }
    float energy(){
       return kinetic()+potential();
    }
    void UpdatePos(){
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
    float ForceMag(float d,float f){
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
    void Affect(Particle other){
      PVector AxisX=PVadd(pos,PVneg(other.pos));  
      
       //EM
       float dist2=max(pow(radius+other.radius,2),AxisX.x*AxisX.x+AxisX.y*AxisX.y);
       if(dist2>0){
         ApplyForce(PVsetMag(AxisX,charge*other.charge/dist2));
         other.ApplyForce(PVsetMag(PVneg(AxisX),charge*other.charge/dist2));
       }
       
       //Elasitic
       //if(bonded){
       //  if(other==bondP.B){
       //    bondP.Update();
       //  }
       //}
       if(dist2<pow(Sys.hBondRadius[type][other.type],2)){
         PVector dir=PVadd(other.pos,PVneg(pos));
         ApplyForce(PVsetMag(dir,Sys.hBondForce[type][other.type]));
         other.ApplyForce(PVneg(PVsetMag(dir,Sys.hBondForce[type][other.type])));
       }
    }
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
    
    int compareTo(Object P) {
      return Float.compare(((Particle)P).kinetic(),kinetic());
    }
}
class Bond{
   float bondLength;
   float bondK;
   float bondEnergy;
   Particle A;
   int AInd;
   Particle B;
   int BInd;
   
   Bond(float dBondLength, float dBondK,float dBondEnergy, Particle dA,int dAInd,Particle dB,int dBInd){
    bondLength=dBondLength; bondK=dBondK; bondEnergy= dBondEnergy; A=dA; AInd=dAInd; B=dB; BInd=dBInd;
   }
   
   boolean Connects(Particle other){
      return (A==other)||(B==other); 
   }
   void Update(){
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
         PVector bondTForce= PVsetMag(new PVector(dir.y,-dir.x),bondFTMag);
         A.ApplyForce(bondTForce);    
       }
   }
   float potential(){
     float pot=-bondEnergy;
     float dist=PVmag(PVadd(A.pos,PVneg(B.pos)));
     float disp=dist-bondLength;
     pot+= 0.5*bondK*(disp*disp);
     
     float bondAngle= atan2(B.pos.x-A.pos.x,B.pos.y-A.pos.y);
     float angDisp= (A.angle-bondAngle+A.bondAngles[AInd])%TWO_PI;
     if(angDisp>PI){
       angDisp=angDisp-TWO_PI;
     }
     pot+= 0.5*A.bondAngKs[AInd]*(angDisp*angDisp); 
     float bondDisp= (B.angle-bondAngle+B.bondAngles[BInd])%TWO_PI;
     if(bondDisp>PI){
       bondDisp=bondDisp-TWO_PI;
     }
     pot+= 0.5*B.bondAngKs[BInd]*(bondDisp*bondDisp);
     return pot;
   }
   void Draw(Cam Camera){
      stroke(255);
      strokeWeight(5.0/Camera.Scale);
      //line(Camera.RealToScreenX(A.pos.x),Camera.RealToScreenY(A.pos.y),Camera.RealToScreenX(B.pos.x),Camera.RealToScreenY(B.pos.y));
      line( Camera.RealToScreenX(A.pos.x)+0.5*A.radius*sin(A.angle+A.bondAngles[AInd])/Camera.Scale,Camera.RealToScreenY(A.pos.y)+0.5*A.radius*cos(A.angle+A.bondAngles[AInd])/Camera.Scale,
      Camera.RealToScreenX(B.pos.x)+0.5*B.radius*sin(B.angle+B.bondAngles[BInd])/Camera.Scale,Camera.RealToScreenY(B.pos.y)+0.5*B.radius*cos(B.angle+B.bondAngles[BInd])/Camera.Scale);
      PVector mid = new PVector((A.pos.x+B.pos.x)/2,(A.pos.y+B.pos.y)/2);
      fill(255,0,0);
      textSize(4.0/Camera.Scale);
      text("BOND:"+nf(potential(),3,1),Camera.RealToScreenX(mid.x),Camera.RealToScreenY(mid.y));
   }
}