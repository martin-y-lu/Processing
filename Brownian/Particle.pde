class Particle{
    PVector pos;
    PVector vel;
    PVector acc= new PVector(0,0);
    float radius;
    float mass;
    float charge;
    Particle(PVector dPos,PVector dVel,float dRad,float dMass,float dCharge){
      pos=dPos; vel= dVel; radius= dRad; mass= dMass; charge= dCharge;
    }
    void Draw(){
      //fill(60,20,220);
      if(charge<0.0){
        fill(10,30,255) ;
      }else{
        fill(255,10,30) ;
      }
      ellipse(pos.x,pos.y,radius*2,radius*2); 
    }
    float potential(){
       float pot=0;
       //pot-=mass*pos.y*0.2;
       for(int i=0;i<Particles.size();i++){
         Particle other =Particles.get(i);
         if(other != this){
           pot+= charge*other.charge/max(radius+other.radius,PVmag(PVadd(pos,PVneg(other.pos))));
         }
       } 
        
       return pot;
    }
    float kinetic(){
      return 0.5*mass*PVmag(vel)*PVmag(vel);
    }
    float energy(){
       return kinetic()+potential();
    }
    void Update(){
      pos=PVadd(pos,PVadd(vel,PVscale(acc,0.5)));
      vel=PVadd(vel,acc);
      acc=new PVector(0,0);
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
    void Affect(Particle other){
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
       float dist2=max(pow(radius+other.radius,2),AxisX.x*AxisX.x+AxisX.y*AxisX.y);
       ApplyForce(PVsetMag(AxisX,charge*other.charge/dist2));
       other.ApplyForce(PVsetMag(PVneg(AxisX),charge*other.charge/dist2));
    }
    void CollideWall(){
      if(pos.x<radius){
        vel=new PVector(abs(vel.x),vel.y);
      }
      if(pos.x>width-radius){
        vel=new PVector(-abs(vel.x),vel.y);
      }
      if(pos.y<radius){
        vel=new PVector(vel.x,abs(vel.y));
      }
      if(pos.y>height-radius){
         vel=new PVector(vel.x,-abs(vel.y));
      }
    }
}