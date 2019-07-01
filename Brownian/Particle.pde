class Particle implements Comparable{
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
    
    Particle(PVector dPos,PVector dVel,float dRad,float dMass,float dCharge,
      float dAngle, float dAngVel, float dAngAcc,float dMomInert,
      float dBondLength,float dBondAngle,float dBondK,float dBondAngK){
      pos=dPos; vel= dVel; radius= dRad; mass= dMass; charge= dCharge; angle= dAngle; angVel=dAngVel;angAcc=dAngAcc; momInert=dMomInert; bondLength=dBondLength; bondAngle=dBondAngle; bondK=dBondK; bondAngK=dBondAngK;
      bondAngK2=bondAngK;
      bonded=false;
    }
    Particle(PVector dPos,PVector dVel,float dRad,float dMass,float dCharge,float dAngle, float dAngVel, float dAngAcc,float dMomInert,float dBondLength,float dBondAngle,float dBondK,float dBondAngK,Particle dP){
      pos=dPos; vel= dVel; radius= dRad; mass= dMass; charge= dCharge; angle= dAngle; angVel=dAngVel;angAcc=dAngAcc; momInert=dMomInert; bondLength=dBondLength; bondAngle=dBondAngle; bondK=dBondK; bondAngK=dBondAngK;
      bondAngK2=bondAngK;
      bonded=true;
      bondP=dP;
    }
    
    
    void Draw(){
      //fill(60,20,220);
      if(charge<0){
        fill(10,30,255) ;
      }else if(charge>0){
        fill(255,10,30) ;
      }else{
         fill(10,255,30) ;
      }
      stroke(255);
      strokeWeight(5);
      if(bonded){
         line(pos.x,pos.y,bondP.pos.x,bondP.pos.y);
      }
      noStroke();
      ellipse(pos.x,pos.y,radius*2,radius*2); 
      stroke(255);
      strokeWeight(2);
      line(pos.x,pos.y,pos.x+radius*sin(angle),pos.y+radius*cos(angle));
      

    }
    float potential(){
       float pot=0;
       pot-=mass*(pos.x*GRAV.x+pos.y*GRAV.y);
       for(int i=0;i<Particles.size();i++){
         Particle other =Particles.get(i);
         if(other != this){
           pot+= charge*other.charge/max(radius+other.radius,PVmag(PVadd(pos,PVneg(other.pos))));
           
           if(other==bondP){
             float disp=PVmag(PVadd(pos,PVneg(bondP.pos)))-bondLength;
             pot+= 0.5*bondK*(disp*disp);
             
             float bondAngle= atan2(bondP.pos.x-pos.x,bondP.pos.y-pos.y);
             float angDisp= (angle-bondAngle)%TWO_PI;
             if(angDisp>PI){
               angDisp=angDisp-TWO_PI;
             }
             pot+= 0.5*bondAngK*(angDisp*angDisp);
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
      acc=GRAV;

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
           println("ftMag: "+ftMag);
           PVector tforce= PVsetMag(new PVector(dir.y,-dir.x),-ftMag);
           bondP.ApplyForce(tforce);
           //ApplyForce(PVneg(tforce));
           
           float bondDisp= bondedAngle-bondP.angle;
           float bondTMag= bondDisp*bondAngK2;
           bondP.ApplyTorque(bondTMag);
           float bondFTMag= 2*bondTMag/dist;
           PVector bondTForce= PVsetMag(new PVector(dir.y,-dir.x),bondFTMag);
           ApplyForce(bondTForce);    
         }
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
      if(pos.x>width-radius){
        vel=new PVector(-abs(vel.x),vel.y);
      }
      //if(pos.x>mouseX-radius){
      //  vel=new PVector(-abs(vel.x),vel.y);
      //}
      if(pos.y<radius){
        vel=new PVector(vel.x,abs(vel.y));
      }
      if(pos.y>height-radius){
         vel=new PVector(vel.x,-abs(vel.y));
      }
    }
    
    int compareTo(Object P) {
      return Float.compare(((Particle)P).kinetic(),kinetic());
    }
}