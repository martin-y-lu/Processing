class Tree{
  float treeHeight=15;
  float treeWidth=0.6;
  float treeBranchAngle=24.9;
  float treeBranchLength=4.36;
  float treeBranchStart=random(0.2,0.3);//1/5 of the way up, add branches.
  float Meter=16;
  PVector RootPos=new PVector(640/2,360-100);
  int taperShape=(int)random(0,3);
  

  Tree(float[] dSetup,PVector dRootPos,float dMeter){
   print(taperShape);
   treeHeight=dSetup[0];
   treeWidth=dSetup[1];
   treeBranchAngle=dSetup[2];
   treeBranchLength=dSetup[3];
   RootPos=dRootPos;
   Meter=dMeter;
  }
  float Taper(float Val,int Kind){
    if(Kind==0){//Linear
      return Val;
    }if(Kind==1){//SQRT
      return sqrt(Val);
    }if(Kind==2){//Dome
      return sqrt(1-(Val-1)*(Val-1));
    }
    return Val;
  }
  void Draw(){
   stroke(40, 100 ,25);
   strokeWeight(3);
   ellipse(RootPos.x,RootPos.y,20,20);
   stroke(130, 82, 1);
   strokeWeight(treeWidth*Meter);
   line(RootPos.x,RootPos.y,RootPos.x,RootPos.y-treeHeight*Meter);
   PVector BranchRangeStart=new PVector(RootPos.x,RootPos.y-treeHeight*Meter*treeBranchStart);
   PVector BranchRangeEnd=new PVector(RootPos.x,RootPos.y-treeHeight*Meter);
   
   float upAmount=0;
   while(upAmount<1){
     upAmount+=random(0.08,0.13);
     PVector BranchRoot=PVlerp(BranchRangeStart,BranchRangeEnd,upAmount);
     float angle=treeBranchAngle*PI/180;
     PVector Branch;
     float BranchAngle;
     if(random(2)>1){
       BranchAngle=angle*random(0.8,1.2);
     }else{
       BranchAngle=-angle*random(0.8,1.2);
     }
     Branch=new PVector(sin(BranchAngle),-cos(BranchAngle));
     Branch=PVextend(Branch,Taper(upAmount,taperShape)*treeBranchLength*Meter*random(0.8,1.2));
     strokeWeight(treeWidth*Meter/2);
     stroke(130, 82, 1);
     line(BranchRoot.x,BranchRoot.y,BranchRoot.x+Branch.x,BranchRoot.y+Branch.y);
     float alongAmount=0;
     float leafAngle=random(14,16)*PI/180;
     float leafSize=random(12,18);
     float leafStart=random(0.2,0.8);
     while( alongAmount<1){
       alongAmount+=random(0.12,0.15);
       PVector LeafRoot=PVlerp(PVlerp(BranchRoot,PVadd(BranchRoot,Branch),leafStart),PVadd(BranchRoot,Branch),alongAmount);
       float leafTilt=0;
       PVector Leaf;
       if(random(2)>1){
         leafTilt=BranchAngle+leafAngle*random(0.7,1.3) ;
       }else{
         leafTilt=BranchAngle-leafAngle*random(0.7,1.3);
       }
       Leaf=new PVector(sin(leafTilt),-cos(leafTilt));
       Leaf=PVextend(Leaf,leafSize);
       strokeWeight(2);
       stroke(77, 158, 58);
       line(LeafRoot.x,LeafRoot.y,LeafRoot.x+Leaf.x,LeafRoot.y+Leaf.y);
     }
   }
  }
}
float MeterSize=16;

void setup(){
      frameRate(60);
    size(640, 360);
   
}

void draw(){
   randomSeed(0);
    strokeWeight(3);
    background(135, 206, 250);
    
    ArrayList<float[]> Setups= new ArrayList<float[]>();
    Setups.add(new float[]{15,0.6,90,3});
    Setups.add(new float[]{12,0.4,20,3});
    int NumTrees=Setups.size();
    ArrayList<Tree> Trees=new ArrayList<Tree>();
    float Seperation=150;
    PVector StartRoot=new PVector(640/2-Seperation/2,360-100);
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
  
   
}
