class Tree{
  float treeHeight=15;
  float treeWidth=0.6;
  float treeBranchAngle=24.9;
  float treeBranchLength=4.36;
  float treeBranchDensity=0; //0-> 1 least to most dense
  float leafStart=1; // 0 -> 1 leaf start amount
  float leafDensity=0; //0-> 1 least to most dense
  float leafThickness=2;
  float leafLength=15;
  float treeBranchStart=random(0.1,0.35);//1/5 of the way up, add branches.
  float Meter=16;
  PVector RootPos=new PVector(640/2,height-100);
  int taperShape=(int)random(0,4);
  float time=0;
  
  int stemColorType=(int)random(0,5);
  float StemR=130;//130, 82, 1
  float StemG=82;
  float StemB=1;
  
  int leafColorType=(int)random(0,6);
  float baseR=77;
  float baseG=158;
  float baseB=58;

  Tree(float[] dSetup,PVector dRootPos,float dMeter){
   println(taperShape);
   treeHeight=dSetup[0];
   treeWidth=dSetup[1];
   treeBranchAngle=dSetup[2];
   treeBranchLength=dSetup[3];
   treeBranchDensity=dSetup[4];
   leafStart=dSetup[5];
   leafDensity=dSetup[6];
   leafThickness=dSetup[7];
   leafLength=dSetup[8];
   RootPos=dRootPos;
   Meter=dMeter;
    if(leafColorType==1){
      baseR=30;
      baseG=165;
      baseB=23;
    }if(leafColorType==2){
      baseR=30;
      baseG=165;
      baseB=23;
    }if(leafColorType==3){
      baseR=251;
      baseG=205;
      baseB=38;
    }if(leafColorType==4){
      baseR=250;
      baseG=143;
      baseB=4;
    }  if(leafColorType==5){
      baseR=246;
      baseG=77;
      baseB=13;
    }
    baseR+=random(-4,4);
    baseG+=random(-4,4);
    baseB+=random(-4,4);
    
    
    if(stemColorType==2){
      StemR=110;
      StemG=67;
      StemB=0;
    }if(stemColorType==3){
      StemR=153;
      StemG=79;
      StemB=0;
    }if(stemColorType==4){
      StemR=202;
      StemG=154;
      StemB=111;
    }
    StemR+=random(-10,10);
    StemG+=random(-10,10);
    StemB+=random(-10,10);
  }
  float Taper(float Val,int Kind){
    if(Kind==0){//Linear
      return Val;
    }if(Kind==1){//SQRT
      return sqrt(Val);
    }if(Kind==2){//Dome
      return sqrt(1-(Val-1)*(Val-1));
    }if(Kind==3){// Sphere up
      return 2*sqrt(0.25-(Val-0.5)*(Val-0.5));
    }
    return Val;
  }
  void Update(){
    //treeBranchStart+=random(-0.1,0.1);
    //treeBranchAngle+=random(-0.1,0.1);
    time+=0.015;
  }
  void Draw(){
   stroke(40, 100 ,25);
   strokeWeight(3);
   ellipse(RootPos.x,RootPos.y,20,20);
   stroke(StemR, StemG, StemB);
   strokeWeight(treeWidth*Meter);
   line(RootPos.x,RootPos.y,RootPos.x,RootPos.y-treeHeight*Meter);
   PVector BranchRangeStart=new PVector(RootPos.x,RootPos.y-treeHeight*Meter*treeBranchStart);
   PVector BranchRangeEnd=new PVector(RootPos.x,RootPos.y-treeHeight*Meter);
   
   float upLow= map(treeBranchDensity,0,1,0.08,0.04);
   float upHigh=map(treeBranchDensity,0,1,0.13,0.03);
   
   float leafStartLow=map(leafStart,0,1, 0.05,0.8);
   float leafStartHigh=map(leafStart,0,1, 0.2,0.9);
   float acrossLow= map(leafDensity,0,1,0.19,0.11);
   float acrossHigh=map(leafDensity,0,1,0.25,0.13);
   
   
   float upAmount=0;
   int upCount=0;
   while(upAmount<1){
     upCount++;
     
     upAmount+=map(noise(0,upCount,100),0,1,upLow,upHigh);//random(0.08,0.13);
     PVector BranchRoot=PVlerp(BranchRangeStart,BranchRangeEnd,upAmount);
     float angle=treeBranchAngle*PI/180;
     PVector Branch;
     float BranchAngle;
     if(noise(upCount*100,upCount*10,20-upCount*100)>0.5){
       BranchAngle=angle*map(noise(time,upAmount*100,100),0,1,0.6,1.4);//random(0.8,1.2);
     }else{
       BranchAngle=-angle*map(noise(time,upAmount*100,100),0,1,0.6,1.4);//random(0.8,1.2);
     }
     Branch=new PVector(sin(BranchAngle),-cos(BranchAngle));
     Branch=PVextend(Branch,Taper(upAmount,taperShape)*treeBranchLength*Meter*map(noise(100,upAmount*100,0),0,1,0.8,1.2));//random(0.8,1.2));
     strokeWeight(treeWidth*Meter/2);
     stroke(StemR, StemG, StemB);
     line(BranchRoot.x,BranchRoot.y,BranchRoot.x+Branch.x,BranchRoot.y+Branch.y);
     float alongAmount=0;
     float leafAngle=map(noise(100,upAmount*10,200),0,1,14,15)*PI/180;//random(14,16)*PI/180;
     float leafSize=map(noise(100,upAmount*10,200),0,1,leafLength-4,leafLength+4);//random(12,18);
     float leafStart=map(noise(100,upAmount*10,400),0,1,leafStartLow,leafStartHigh);//random(0.2,0.8);
     int alongCount=0;
     while( alongAmount<1){
       alongAmount+=map(noise(alongCount),0,1,acrossLow,acrossHigh);
       alongCount++;
       PVector LeafRoot=PVlerp(PVlerp(BranchRoot,PVadd(BranchRoot,Branch),leafStart),PVadd(BranchRoot,Branch),alongAmount);
       float leafTilt=0;
       PVector Leaf;
       if(noise(100,200,alongCount*10)>0.5){
         leafTilt=BranchAngle+leafAngle*map(noise(time,alongCount*100,100),0,1,0.2,2.5);//random(0.7,1.3) ;
       }else{
         leafTilt=BranchAngle-leafAngle*map(noise(time,alongCount*100,100),0,1,0.2,2.5);
       }
       Leaf=new PVector(sin(leafTilt),-cos(leafTilt));
       Leaf=PVextend(Leaf,leafSize);
       strokeWeight(leafThickness);
       stroke(map(noise(0,100+upCount*0.05,alongCount),0,1,baseR-40,baseR+40),map(noise(100,100+upCount*0.05,alongCount),0,1,baseG-40,baseG+40),map(noise(200,100+upCount*0.05,alongCount),0,1,baseB-40,baseB+40));//77, 158, 58);
       line(LeafRoot.x,LeafRoot.y,LeafRoot.x+Leaf.x,LeafRoot.y+Leaf.y);
     }
   }
  }
  Effect DropLeaf(){
    PVector pos=new PVector(RootPos.x+random(-10,10),RootPos.y-random(0,treeHeight*Meter));
    float Len=leafLength+random(-6,1);
    return new Effect(pos,Len,leafThickness*0.8,0.5,(int)baseR,(int)baseG,(int)baseB,true,random(1)>0.5);
  }
}
class Effect{
  PVector pos;
  float len;
  float thickness;
  int colorR;
  int colorG;
  int colorB;
  float vel;//0->1
  boolean falling;
  boolean right;
  Effect(PVector dPos, float dLen,float dThick, float dVel, int dR, int dG, int dB, boolean dFall, boolean dRight){
     pos=dPos; len=dLen; thickness=dThick; vel=dVel; colorR=dR; colorG= dG; colorB= dB; falling= dFall; right=dRight;
  }
  void Draw(){
    stroke(colorR,colorG,colorB);
    strokeWeight(thickness);
    if(falling){
      if(right){
        line(pos.x,pos.y,pos.x+len,pos.y+len*0.2);
      }else{
         line(pos.x,pos.y,pos.x+len,pos.y-len*0.2);
      }
    }else{
      line(pos.x,pos.y,pos.x+len,pos.y);
    }       
  }
  void Update(){
    if(falling){
     if(right){
       pos= new PVector(pos.x+0.5*speed,pos.y+0.2*speed); 
     }else{
       pos= new PVector(pos.x-1.5*speed,pos.y+0.2*speed);  
     }
     if(random(1)>0.98){
         right=!right;
     }
     if(pos.y>height-100){
       if(random(1)>0.992){
         falling=false;
       }
     }
    }else{
     pos= new PVector(pos.x-vel*speed,pos.y); 
    }
  }
}
float MeterSize=16;

ArrayList<Tree> Trees=new ArrayList<Tree>();
ArrayList<Effect> Effects= new ArrayList<Effect>();
void setup(){
    frameRate(60);
    size(640, 600);
    strokeWeight(3);
    background(135, 206, 250);
    
    ArrayList<float[]> Setups= new ArrayList<float[]>();
    Setups.add(new float[]{15,0.6,90,3,0,0,1,3,15});
    Setups.add(new float[]{12,0.4,20,3,1,1,1,2,15});
    int NumTrees=Setups.size();
    
    float Seperation=150;
    PVector StartRoot=new PVector(640/2-Seperation/2,height-100);
    for(int i=0;i<NumTrees;i++){
      Trees.add(new Tree(Setups.get(i),StartRoot,MeterSize));
      StartRoot=PVadd(StartRoot,new PVector(Seperation,0));
     Trees.get(i).Draw();
    }
    
   //rect(0,0,10,10);
   fill(96, 200, 56);
   stroke(40, 100 ,25);
   strokeWeight(3);
   rect(0,height-100,width,height,6);
  
   for(float i=0; i<10;i++){
    println(noise(i)); 
   }
   
}
float count=0;
float cut=random(60*2.2,60*3.5);
int speed=4;

void draw(){
    background(135, 206, 250);
   for(int i=Trees.size()-1;i>=0;i--){
     Tree T= Trees.get(i);
     T.Update();
     T.RootPos= new PVector(T.RootPos.x-0.5*speed,T.RootPos.y);
     T.Draw();
     if(random(1)>0.993){
       Effects.add(T.DropLeaf());
     }
     if(T.RootPos.x<-200){
       Trees.remove(i);
     }
     
   } 
   count ++;
   if(count > cut){
     count=0;
     cut=random(60*2.1,60*5.7)/speed;
     PVector StartRoot=new PVector(700,height-100);
     float[] Setup=new float[]{map(random(1),0,1,6,28),map(random(1),0,1,0.3,0.7),map(random(1),0,1,20,90),map(random(1),0,1,2,4),random(1),random(0.2,1),random(1.3),random(2,6),random(10,20)};//new float[]{12,0.4,20,3};new float[]{15,0.6,90,3}
     Trees.add(new Tree(Setup,StartRoot,MeterSize));
   }
   fill(96, 200, 56);
   stroke(40, 100 ,25);
   strokeWeight(3);
   rect(0,height-100,width,height,6);
   
   if(random(1)>0.9){//wind
     Effects.add(new Effect(new PVector(700,random(0,height-100-5)),random(10,100),2,random(0.9,1.1),201,244,255,false,false));
   }
   if(random(1)>0.96){//dird/ leafs
     Effects.add(new Effect(new PVector(700,random(height-100+5,height)),random(5,20),random(2,4),0.5,40,110,25,false,false));
   }
   if(random(1)>0.99){//dird/ leafs;//130, 82, 1
     Effects.add(new Effect(new PVector(700,random(height-100+5,height)),random(5,15),random(2,4),0.5,130,82,1,false,false));
   }
   for(int i=0;i<Effects.size();i++){
     Effect E= Effects.get(i);
     E.Update();
     E.Draw(); 
   }
   for(int i=Effects.size()-1;i>=0;i--){
     Effect E= Effects.get(i);
     if(E.pos.x<-100){
      Effects.remove(i); 
     }
   }
   //saveFrame("video/clip_####.png");
}