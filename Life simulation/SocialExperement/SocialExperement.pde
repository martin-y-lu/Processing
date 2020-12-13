PVector PVadd(PVector A,PVector B){
  return new PVector(A.x+B.x,A.y+B.y);
}
PVector PVneg(PVector A){
  return new PVector(-A.x,-A.y);
}
float PVmag(PVector Po){
  return dist(0,0,Po.x,Po.y);
}
PVector PVextend(PVector A, float mult){
  return new PVector(A.x*mult,A.y*mult);
}
PVector PVsetmag(PVector A,float mag){
  return PVextend(A,mag/PVmag(A));
}
PVector PVMult(PVector A,PVector B){
  return new PVector(A.x*B.x-A.y*B.y,A.x*B.y+A.y*B.x);
}
PVector PVDivide(PVector P,PVector C){
  return new PVector((C.x*P.x+C.y*P.y)/((C.x*C.x)+(C.y*C.y)),
  (C.x*P.y-C.y*P.x)/((C.x*C.x)+(C.y*C.y)));
}
float PVAng(PVector P){
  return atan2(P.y,P.x);
}
String PVstring(PVector P){
  return "x| "+P.x+"   y| "+ P.y;
}
PVector PV(){
  return new PVector(0,0);
}
class Community{
  ArrayList<Person> PList=new ArrayList<Person>();
  ArrayList<Connection> CList=new ArrayList<Connection>();
  void SetUp(){
    for(int i=0;i<CList.size();i++){
      CList.get(i).SetUp();
    }    
  }
  void Draw(){
    for(int i=0;i<CList.size();i++){
      CList.get(i).Draw();
    }    
    for(int i=0;i<PList.size();i++){
      PList.get(i).Draw();
    }
  }
}
class Person{
  PVector Pos;
  Person(PVector dPos){
    Pos=dPos;
  }
  void Draw(){
    stroke(0);
    strokeWeight(2);
    ellipse(Pos.x,Pos.y,20,20);
  }
}
class Connection{
  Community C;
  int PANum;
  int PBNum;
  Person PA;
  Person PB;
  float Respect;
  Connection(int dPANum,int dPBNum,float dRespect,Community dC){
   PANum=dPANum; PBNum=dPBNum; Respect=dRespect; C=dC;
  }
  void SetUp(){
    PA=C.PList.get(PANum); PB=C.PList.get(PBNum);
  }
  void Draw(){
    if(Respect>0){
      stroke(0,255,0);
    }else{
      stroke(255,0,0);
    }
    strokeWeight(abs(Respect));
    line(PA.Pos.x,PA.Pos.y,PB.Pos.x,PB.Pos.y);
  }
}
Community Com=new Community();
void setup(){
    frameRate(60);
    size(640, 360);
    Com.PList.add(new Person(new PVector(100,100)));
    Com.PList.add(new Person(new PVector(200,100)));
    Com.PList.add(new Person(new PVector(150,200)));
    Com.CList.add(new Connection(0,1,-10,Com));
    Com.CList.add(new Connection(0,2,4,Com));
    Com.SetUp();
}
void draw(){
  background(160,190,255); 
  fill(120,12,0);
  Com.Draw();
}