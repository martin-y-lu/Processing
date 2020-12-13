int NUMTYPES=9;

float[] ACTRAD;//{100,100,100};
float[][] FORCES;//={{0,1,-1},{-1,0,1},{1,-1,0}};//;//
int[] COLORS= {color(255,0,0),color(0,255,0),color(0,0,255),color(255,255,0),color(255,0,255),color(0,255,255),color(120,120,255),color(120,225,120),color(255,120,120)};
float FRICT=2.1;
float VELSCALE=0.7;

//0.7 -> 2.1
//0.5 v ->1.6
//0.3 -> 1.2;
//0.1-> 0.8


ArrayList<Particle> Particles;

void Set(){
  VELSCALE=random(0.1,0.7);
  FRICT=2.25*VELSCALE+ 0.575;
  FRICT*=random(0.9,1.2);
  
  for(int i=0;i<NUMTYPES;i++){
   ACTRAD[i]=abs(80+randomGaussian()*10); 
  }
  for(int i=0;i<NUMTYPES;i++){
    for(int j=0;j<NUMTYPES;j++){
      if(i!=j){
       FORCES[i][j]=randomGaussian()*20.0; 
      }else{
        FORCES[i][j]=randomGaussian()*16.0; 
      }
    }
  }
  
}
void setup() {
  //size(600,600,P2D);
  fullScreen();
  ACTRAD= new float[NUMTYPES];

  FORCES=new float[NUMTYPES][NUMTYPES];
  Set();

  
  Particles=new ArrayList<Particle>();
  for(int i=0;i<200;i++){
    PVector Pos= new PVector(random(1)*width,random(1)*height);
    Particles.add(new Particle(Pos,new PVector(1,0),randomInt(0,NUMTYPES-1)));
  }
}
void draw(){
  background(0);
  for(Particle P:Particles){
    P.Draw();
  }
  for(int i=0;i<Particles.size();i++){
    for(int j=0; j<Particles.size();j++){
      if(i!=j){
        Particles.get(i).Affect(Particles.get(j)); 
      }
    }
  }
  for(int i=0; i<Particles.size(); i++){
     Particles.get(i).Update(); 
     Particles.get(i).CollideWall(); 
  }
}
void mousePressed(){
 Set(); 
}
