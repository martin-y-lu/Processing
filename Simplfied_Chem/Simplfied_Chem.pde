System S= new System();
void setup(){
  size(600,600,P3D);
  S.addParticle(new Particle(new IntVector(10,30),new IntVector(1,0),1,2,1));
   S.addParticle(new Particle(new IntVector(40,35),new IntVector(1,0),3,1000,1));
}
int SCALE=10;
void draw(){
  background(0);
  strokeWeight(1);
  for(int i=0;i<height;i+=SCALE){
   stroke(255,150);
   line(0,i,width,i);
  }
  for(int i=0;i<width;i+=SCALE){
   stroke(255,150);
   line(i,0,i,height);
  }
  S.draw();
  if(frameCount%20==0){
    fill(255,0,0);
    noStroke();
    ellipse(15,15,5,5);
    S.update(); 
  }
}
