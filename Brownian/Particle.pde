class Cam{
  PVector Pos= new PVector(0,0);
  float Scale=1;
  Cam(PVector dPos,float dScale){
    Pos=dPos; Scale=dScale;
  }
  
  PVector RealToScreen(PVector real){
   return PVscale(PVadd(real,PVneg(Pos)),1/Scale); 
  }
  float RealToScreenX(float realX){
    return (realX-Pos.x)/Scale; 
  }
  float RealToScreenY(float realY){
    return (realY-Pos.y)/Scale; 
  }
  PVector ScreenToReal(PVector screen){
   return PVadd(PVscale(screen,Scale),Pos); 
  } 
  float ScreenToRealX(float screenX){
    return (screenX*Scale)+Pos.x; 
  }
  float ScreenToRealY(float screenY){
    return (screenY*Scale)+Pos.y; 
  }
}

class ChemSys{
 int NUMTYPES;
 ArrayList<PartType> Types;
 ArrayList<Particle> Particles;
 float[][] hBondRadius;
 float[][] hBondForce;
 int SPEED=1;
 PVector GRAV=new PVector(0,0.004);
 float ENERGY=0;
 PVector Size;
 
 ChemSys(ArrayList<PartType> dTypes, float[][] dHBondRadius,float[][] dHBondForce, PVector dSize){
  Types= dTypes;
  //Particles= dParticles;
  Particles= new ArrayList<Particle>( );
  NUMTYPES=dTypes.size();
  hBondRadius= dHBondRadius;
  hBondForce=dHBondForce;
  Size=dSize;
 }
 PVector EField(PVector Pos){
    PVector field= new PVector(0,0);
    for( Particle P: Particles){
      field= PVadd(field,P.Field(Pos));
    }
    return field;
  }
  
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
      float targetKinetic= ENERGY-TotPotential();
      
      //float integ=(pow(skew+1,pow+1)-pow(skew,pow+1))/(pow+1);
      for(int i=0;i<Particles.size();i++){//Fix velocities to conserve energy
        //float rank=((float) i)/(Particles.size()-1);
        float scale=max(targetKinetic/actualKinetic,0);//*pow(rank+skew,pow)/integ;
        scale=sqrt(scale);
        
        Particles.get(i).vel=PVscale(Particles.get(i).vel,scale);
        Particles.get(i).angVel*=scale;
      }
  }
  void DrawFieldLines(Cam Camera){
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
  void DrawParticles(Cam Camera){
    for(int p=0;p<Particles.size();p++){
      Particle P= Particles.get(p);
      
      P.Draw(Camera);
      for(int j=p+1;j<Particles.size();j++){
         Particle J= Particles.get(j);
         float dist= PVmag(PVadd(P.pos,PVneg(J.pos)));
         if(dist<hBondRadius[P.type][J.type]){
           strokeWeight(hBondForce[P.type][J.type]*3.0/Camera.Scale);
           line(Camera.RealToScreenX(P.pos.x),Camera.RealToScreenY(P.pos.y),Camera.RealToScreenX(J.pos.x),Camera.RealToScreenY(J.pos.y));
         }
      }
    } 
  }
  void Draw(Cam Camera){
    //DrawFieldLines(Camera);
    DrawParticles(Camera);
    noStroke();
    fill(100);
    rect(0,0,Camera.RealToScreenX(0),height);
    rect(0,0,width,Camera.RealToScreenY(0));
    rect(width,0,Camera.RealToScreenX(Size.x)-width,height);
    rect(0,height,width,Camera.RealToScreenY(Size.y)-height);
  }
  void Update(){
    for(int s=0;s<SPEED;s++){
      for(int i=0;i<Particles.size();i++){
        for(int j=0; j<i;j++){
          Particles.get(i).Affect(Particles.get(j)); 
        }
      }
      for(int i=0;i<Particles.size();i++){
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
    if(SPEED<0){
        if(frameCount%(-SPEED)==0){
          for(int i=0;i<Particles.size();i++){
          for(int j=0; j<i;j++){
            Particles.get(i).Affect(Particles.get(j)); 
          }
        }
        for(int i=0;i<Particles.size();i++){
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
    }
  }
  void AddParticle(Particle P){
    Particles.add(P);
  }
  void FixEnergy(){
    ENERGY= TotEnergy();
  }
}



class PartType{
  float radius;
    float mass;
    float charge;
    float momInert;
    
    float bondLength;
    float bondAngle;
    float bondK;
    float bondAngK;
    
    int type;
    PartType(int dType, float dRad,float dMass,float dCharge,float dMomInert,float dBondLength,float dBondAngle,float dBondK,float dBondAngK){
       radius= dRad; mass= dMass; charge= dCharge; momInert=dMomInert; bondLength=dBondLength; bondAngle=dBondAngle; bondK=dBondK; bondAngK=dBondAngK;
       type = dType;
    }
    Particle Gen(ChemSys dSys,PVector dPos,PVector dVel,float dAngle, float dAngVel, float dAngAcc){
      return new Particle(dSys,type,dPos,dVel,radius,mass,charge,
      dAngle, dAngVel, dAngAcc,momInert,
      bondLength,bondAngle,bondK,bondAngK); 
    }
    Particle Gen(ChemSys dSys,PVector dPos,PVector dVel,float dAngle, float dAngVel, float dAngAcc, Particle dP){
      return new Particle(dSys,type,dPos,dVel,radius,mass,charge,
      dAngle, dAngVel, dAngAcc,momInert,
      bondLength,bondAngle,bondK,bondAngK, dP); 
    }
}

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
    
    float bondLength;
    float bondAngle;
    float bondK;
    float bondAngK;
    float bondAngK2;
    boolean bonded;
    Particle bondP;
    
    int type;
    
    Particle(ChemSys dSys, int dType, PVector dPos,PVector dVel,float dRad,float dMass,float dCharge,
      float dAngle, float dAngVel, float dAngAcc,float dMomInert,
      float dBondLength,float dBondAngle,float dBondK,float dBondAngK){
      Sys=dSys;
      type=dType;
      pos=dPos; vel= dVel; radius= dRad; mass= dMass; charge= dCharge; angle= dAngle; angVel=dAngVel;angAcc=dAngAcc; momInert=dMomInert; bondLength=dBondLength; bondAngle=dBondAngle; bondK=dBondK; bondAngK=dBondAngK;
      bondAngK2=bondAngK;
      bonded=false;
    }
    Particle(ChemSys dSys,int dType,PVector dPos,PVector dVel,float dRad,float dMass,float dCharge,float dAngle, float dAngVel, float dAngAcc,float dMomInert,float dBondLength,float dBondAngle,float dBondK,float dBondAngK,Particle dP){
      Sys=dSys;
      type=dType;
      pos=dPos; vel= dVel; radius= dRad; mass= dMass; charge= dCharge; angle= dAngle; angVel=dAngVel;angAcc=dAngAcc; momInert=dMomInert; bondLength=dBondLength; bondAngle=dBondAngle; bondK=dBondK; bondAngK=dBondAngK;
      bondAngK2=bondAngK;
      bonded=true;
      bondP=dP;
    }
    
    
    void Draw(Cam Camera){
      //fill(60,20,220);
      if(charge<0){
        fill(10,30,255) ;
      }else if(charge>0){
        fill(255,10,30) ;
      }else{
         fill(10,255,30) ;
      }
      stroke(255);
      strokeWeight(5.0/Camera.Scale);
      if(bonded){
         line(Camera.RealToScreenX(pos.x),Camera.RealToScreenY(pos.y),Camera.RealToScreenX(bondP.pos.x),Camera.RealToScreenY(bondP.pos.y));
      }
      noStroke();
      ellipse(Camera.RealToScreenX(pos.x),Camera.RealToScreenY(pos.y),radius*2/Camera.Scale,radius*2/Camera.Scale); 
      stroke(255);
      strokeWeight(2.0/Camera.Scale);
      line(Camera.RealToScreenX(pos.x),Camera.RealToScreenY(pos.y),Camera.RealToScreenX(pos.x)+radius*sin(angle)/Camera.Scale,Camera.RealToScreenY(pos.y)+radius*cos(angle)/Camera.Scale);
      
      fill(255);
      textSize(18.0/Camera.Scale);
      text(type,Camera.RealToScreenX(pos.x)-5,Camera.RealToScreenY(pos.y)+5);
      

    }
    float potential(){
       float pot=0;
       pot-=mass*(pos.x*Sys.GRAV.x+pos.y*Sys.GRAV.y);
       for(int i=0;i<Sys.Particles.size();i++){
         Particle other =Sys.Particles.get(i);
         if(other != this){
           float dist=PVmag(PVadd(pos,PVneg(other.pos)));
           pot+= charge*other.charge/max(radius+other.radius,dist);
           
           if(other==bondP){
             float disp=dist-bondLength;
             pot+= 0.5*bondK*(disp*disp);
             
             float bondAngle= atan2(bondP.pos.x-pos.x,bondP.pos.y-pos.y);
             float angDisp= (angle-bondAngle)%TWO_PI;
             if(angDisp>PI){
               angDisp=angDisp-TWO_PI;
             }
             pot+= 0.5*bondAngK*(angDisp*angDisp);
             float bondDisp= (bondAngle-bondP.angle)%TWO_PI;
             pot+= 0.5*bondAngK2*(bondDisp*bondDisp);
           }
           if( dist<Sys.hBondRadius[type][other.type]){
             pot-= (Sys.hBondRadius[type][other.type]- dist)*Sys.hBondForce[type][other.type];
           }
         }
       } 
        
       return pot;
    }
    float kinetic(){
      return 0.5*mass*PVmag(vel)*PVmag(vel)+0.5*momInert*angle*angle;
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
       if(other==bondP){
         PVector dir=PVadd(pos,PVneg(bondP.pos));
         float dist= PVmag(dir);
         float disp=bondLength-dist;
         float fMag=disp*bondK;
         PVector force=PVsetMag(dir,fMag);
         ApplyForce(force);
         bondP.ApplyForce(PVneg(force));
         
         //Angular
         if(dist>0){
           float bondedAngle= atan2(bondP.pos.x-pos.x,bondP.pos.y-pos.y);
           float angDisp= (angle+bondAngle-bondedAngle)%TWO_PI;
           if(angDisp>PI){
             angDisp=angDisp-TWO_PI;
           }
           float tMag= angDisp*bondAngK;
           ApplyTorque(-tMag);
           float ftMag= 2*tMag/dist;
           //println("ftMag: "+ftMag);
           PVector tforce= PVsetMag(new PVector(dir.y,-dir.x),-ftMag);
           bondP.ApplyForce(tforce);
           //ApplyForce(PVneg(tforce));
           
           float bondDisp= (bondedAngle-bondP.angle)%TWO_PI;
           float bondTMag= bondDisp*bondAngK2;
           bondP.ApplyTorque(bondTMag);
           float bondFTMag= 2*bondTMag/dist;
           PVector bondTForce= PVsetMag(new PVector(dir.y,-dir.x),bondFTMag);
           ApplyForce(bondTForce);    
         }
       }
       if(dist2<pow(Sys.hBondRadius[type][other.type],2)){
         PVector dir=PVadd(other.pos,PVneg(pos));
         ApplyForce(PVsetMag(dir,Sys.hBondForce[type][other.type]));
         other.ApplyForce(PVneg(PVsetMag(dir,Sys.hBondForce[type][other.type])));
       }
    }
    void Collide(Particle other){
      //Collide
      PVector AxisX=PVadd(pos,PVneg(other.pos));  
       if( PVmag(AxisX)<(radius+other.radius) ){
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
             float f1x= ((m1-m2)*v1x+2*m2*v2x)/(m1+m2);
             float f2x= (2*m1*v1x+(m2-m1)*v2x)/(m1+m2);
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
   Particle A;
   Particle B;
   Bond(float dBondLength, float dBondK, Particle dA,Particle dB){
    bondLength=dBondLength; bondK=dBondK; A=dA; B=dB;
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
         float angDisp= (A.angle+A.bondAngle-bondedAngle)%TWO_PI;
         if(angDisp>PI){
           angDisp=angDisp-TWO_PI;
         }
         float tMag= angDisp*A.bondAngK;
         A.ApplyTorque(-tMag);
         float ftMag= 2*tMag/dist;
         //println("ftMag: "+ftMag);
         PVector tforce= PVsetMag(new PVector(dir.y,-dir.x),-ftMag);
         B.ApplyForce(tforce);
         //ApplyForce(PVneg(tforce));
         
         float bondDisp= bondedAngle-B.angle;// B Bonding site angle here
         float bondTMag= bondDisp*A.bondAngK2;
         B.ApplyTorque(bondTMag);
         float bondFTMag= 2*bondTMag/dist;
         PVector bondTForce= PVsetMag(new PVector(dir.y,-dir.x),bondFTMag);
         A.ApplyForce(bondTForce);    
       }
   }
   float Potential(){
     float pot=0;
     float dist=PVmag(PVadd(A.pos,PVneg(B.pos)));
     float disp=dist-bondLength;
     pot+= 0.5*bondK*(disp*disp);
     
     float bondAngle= atan2(B.pos.x-A.pos.x,B.pos.y-A.pos.y);
     float angDisp= (A.angle-bondAngle)%TWO_PI;
     if(angDisp>PI){
       angDisp=angDisp-TWO_PI;
     }
     pot+= 0.5*A.bondAngK*(angDisp*angDisp); 
     return pot;
   }
   void Draw(Cam Camera){
      stroke(255);
      strokeWeight(5.0/Camera.Scale);
      line(Camera.RealToScreenX(A.pos.x),Camera.RealToScreenY(A.pos.y),Camera.RealToScreenX(B.pos.x),Camera.RealToScreenY(B.pos.y));
   }
}