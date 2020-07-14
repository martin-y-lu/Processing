class Particle{
 IntVector pos;
 IntVector vel;
 int radius;
 int mass;
 int charge;
 int updateCount;
 System system;
  Particle(IntVector dPos,IntVector dVel,int dRadius, int dMass, int dCharge){
    pos=dPos;
    vel=dVel;
    radius=dRadius;
    mass= dMass;
    updateCount=mass;
    charge=dCharge;
  }
  int potentialAtRad(int rad){
     int potential=0;
     if(charge-rad>0){
        potential+=charge-rad; 
     }
     return potential;
  }
  int potentialAtPos(IntVector posInSpace){
     return potentialAtRad( IntVector.subtract(pos,posInSpace).magnatude());
  }
  int forceAtRad(int rad){
     return potentialAtRad(rad+1)-potentialAtRad(rad);
  }
  void draw(){
     //ellipse(pos.x*SCALE,pos.y*SCALE,10,10);
     fill(255);
     noStroke();
     pushMatrix();
     translate(pos.x*SCALE,pos.y*SCALE);
     beginShape();
     vertex(radius*SCALE,0);
     vertex(0,radius*SCALE);
     vertex(-radius*SCALE,0);
     vertex(0,-radius*SCALE);
     endShape();
     popMatrix();
     strokeWeight(5);
     if(updateCount!=0){
       stroke(255,0,0,100);
     }else{
       stroke(255,0,0,200);
     }
     line(pos.x*SCALE,pos.y*SCALE,(pos.x+vel.x)*SCALE,(pos.y+vel.y)*SCALE);
  }
  void update(){
    if(updateCount==0){
      pos.add(vel);
      updateCount=mass;
    }
    updateCount-=1;
  }
}
