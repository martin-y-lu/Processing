class Light{
  PVector Pos;
  ArrayList<PVector> RayPos=new ArrayList<PVector>(0);
  ArrayList<PVector> LightField=new ArrayList<PVector>(0);
  Light(PVector dPos){
    Pos=dPos;
  }
  void DrawLight(){
    stroke(255);
    fill(255);
    ellipse(Pos.x,Pos.y,4,4);
    fill(255,255,255,80);
    noStroke();
    for(int L=0;L<LightField.size()-1;L++){
       line(LightField.get(L).x,LightField.get(L).y,LightField.get(L+1).x,LightField.get(L+1).y);
       triangle(LightField.get(L).x,LightField.get(L).y,LightField.get(L+1).x,LightField.get(L+1).y,Pos.x,Pos.y);
    }
    line(LightField.get(LightField.size()-1).x,LightField.get(LightField.size()-1).y,LightField.get(0).x,LightField.get(0).y);
    triangle(LightField.get(LightField.size()-1).x,LightField.get(LightField.size()-1).y,LightField.get(0).x,LightField.get(0).y,Pos.x,Pos.y);
  }
  void CalcLightField(){
    RayPos=new ArrayList<PVector>(0);
    LightField=new ArrayList<PVector>(0);
    for(int W=0; W<WList.size();W++){
       RayPos.add(PVadd(WList.get(W).PoiA,PVminus(Pos)));
       RayPos.add(PVMult(PVadd(WList.get(W).PoiA,PVminus(Pos)),new PVector(1,0.001)));
       RayPos.add(PVMult(PVadd(WList.get(W).PoiA,PVminus(Pos)),new PVector(1,-0.001)));
       RayPos.add(PVadd(WList.get(W).PoiB,PVminus(Pos)));
       RayPos.add(PVMult(PVadd(WList.get(W).PoiB,PVminus(Pos)),new PVector(1,0.001)));
       RayPos.add(PVMult(PVadd(WList.get(W).PoiB,PVminus(Pos)),new PVector(1,-0.001)));
    }
    for(int r=0;r<RayPos.size();r++){
      ArrayList<PVector> ClosePos=new ArrayList<PVector>(0);
      for(int W=0; W<WList.size();W++){
        if(RayIntersect(Pos,RayPos.get(r),WList.get(W).PoiA,WList.get(W).PoiB)){
          ClosePos.add(RayIntersectPos(Pos,RayPos.get(r),WList.get(W).PoiA,WList.get(W).PoiB));
        }
      }
      for(int C=0;C<ClosePos.size()-1;C++){
        PVector PA=ClosePos.get(C);
        PVector PB=ClosePos.get(C+1);
        if(dist(PA.x,PA.y,Pos.x,Pos.y)<dist(PB.x,PB.y,Pos.x,Pos.y)){
          ClosePos.get(C+1).set(PA);
        }
      }
      if(ClosePos.size()>=1){
        LightField.add(ClosePos.get(ClosePos.size()-1));
      }
    }
    for(int L=0;L<=LightField.size()-2;L++){
      for(int M=0;M<=LightField.size()-L-2;M++){
        PVector One=LightField.get(M).copy();
        PVector Two=LightField.get(M+1).copy();
        if(atan2(One.x-Pos.x,One.y-Pos.y)>atan2(Two.x-Pos.x,Two.y-Pos.y)){
          LightField.get(M).set(Two);
          LightField.get(M+1).set(One);
        }
      }
    }
  }
}
class Wall{
  PVector PoiA;
  PVector PoiB;
  Wall(PVector dPoiA,PVector dPoiB){
    PoiA=dPoiA;
    PoiB=dPoiB;
  }
  void DrawWall(){
    stroke(255);
    line(PoiA.x,PoiA.y,PoiB.x,PoiB.y);
  }
}
ArrayList<Light> LList=new ArrayList<Light>();
ArrayList<Wall> WList= new ArrayList<Wall>();
void setup(){
    frameRate(60);
    size(640, 360);
    WList.add(new Wall(new PVector(100,100),new PVector(220,360)));
    WList.add(new Wall(new PVector(100,100),new PVector(600,300)));
    WList.add(new Wall(new PVector(500,0),new PVector(550,200)));
    
    WList.add(new Wall(new PVector(0,0),new PVector(0,height)));
    WList.add(new Wall(new PVector(0,0),new PVector(width,0)));
    WList.add(new Wall(new PVector(0,height),new PVector(width,height)));
    WList.add(new Wall(new PVector(width,0),new PVector(width,height)));
    for(int i=0;i<=5;i++){
      LList.add(new Light(new PVector()));
    }
}
void draw(){
  background(0); 
  fill(0);
  stroke(0);
  for(float i=0;i<=5;i++){
    Light L= LList.get(int(i));
    L.Pos=new PVector(mouseX+cos(2*i/5*PI)*4,mouseY+sin(2*i/5*PI)*4);
    L.CalcLightField();
    L.DrawLight();
  }
}