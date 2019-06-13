class Particle{
    PVector pos;
    PVector vel;
    PVector acc= new PVector(0,0);
    float radius;
    float attRad;
    int type;
    Particle(PVector dPos,PVector dVel,float dRad,float dAttRad,int dType){
      pos=dPos; vel= dVel; radius=dRad; attRad=dAttRad; type=dType;
    }
    Particle(PVector dPos,PVector dVel,int dType){
      pos=dPos; vel= dVel;
      type=dType;
      radius= 18;
      attRad=ACTRAD[type];
    }
    void Draw(){
      //fill(60,20,220);
      fill(COLORS[type]);
      ellipse(pos.x,pos.y,radius,radius); 
    }
    
    void Update(){
      pos=PVadd(pos,PVadd(vel,PVscale(acc,0.5)));
      vel=PVadd(vel,acc);
      acc=new PVector(0,0);
      vel=PVscale(vel,FRICT);
    }
    float ForceMag(float d,float f){
       if(d>attRad){
          return 0; 
       }
       if(d>(radius+attRad)*0.5){
          return (attRad-d)*f*(radius-attRad)*0.5; 
       }
       if(d>radius){
         return (d-radius)*f*(radius-attRad)*0.5; 
       }
       return 12*(radius*radius/(d*d));
    }
    void Affect(Particle other){
       float dist= PVmag(PVadd(pos,PVneg(other.pos)));
       float mag=other.ForceMag(dist,FORCES[type][other.type]);
       if(mag!=0){
         PVector force=PVsetMag(PVadd(pos,PVneg(other.pos)),max(-0.8,min(mag,0.8)));
         acc=PVadd(acc,force);
       }
    }
    void CollideWall(){
      if(pos.x<0){
        acc=PVadd(acc,new PVector(10,0));
      }if(pos.x>width){
        acc=PVadd(acc,new PVector(-10,0));
      }
      if(pos.y<0){
        acc=PVadd(acc,new PVector(0,10));
      }if(pos.y>height){
        acc=PVadd(acc,new PVector(0,-10));
      }
    }
}