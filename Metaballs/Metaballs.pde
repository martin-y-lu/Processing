int Size=9;
ArrayList<MetaBall> MList=new ArrayList<MetaBall>(0);
//ArrayList<Point> PList =new ArrayList<Point>(0);
ArrayList<ArrayList<Point>>PList=new ArrayList<ArrayList<Point>>(floor(width/Size));
void Init(){
  PList=new ArrayList<ArrayList<Point>>(floor(width/Size));
  for(int pl=0;pl<floor(width/Size);pl++){
    ArrayList<Point> Empty=new ArrayList<Point>(floor(height/Size));
    for(int p=0;p<floor(height/Size);p++){
      Empty.add(null);
    }
    PList.add(Empty);
  }
}

class MetaBall{
  PVector Pos;
  float Rad;
  MetaBall(PVector dPos,float dRad){
    Pos=dPos; Rad=dRad;
  }
  void DrawBase(){
    stroke(0);
    fill(0,0,0,100);
    ellipse(Pos.x,Pos.y,2*Rad,2*Rad);
    fill(255);
    ellipse(Pos.x,Pos.y,6,6);
  }
  float MetaVal(PVector Point){
    return sq(Rad)/( sq(Point.x-Pos.x)+sq(Point.y-Pos.y) );
  }
}
color Shader(float value){
  return color(value*180+180,0,0);
}
class Point{
  int X,Y;
  float Val;
  Point(int dX, int dY, float dVal){
    X=dX; Y=dY; Val=dVal;
  }
  void Draw(){
    if(Val>0){
      fill(Val*180+180,0,0);
    }else{
      fill(0,Val*180+180,0);
    }
    ellipse(X*Size,Y*Size,Size/2,Size/2);
    fill(255);
    text(nf(Val,1,1),X*Size,Y*Size);
  }
}
boolean InRange(int X,int Y){
  return (X>=0&&X<floor(width/Size))&&(Y>=0&&Y<floor(height/Size));
}
float GetVal(int X,int Y){
  //for(int i=0; i<PList.size(); i++){
  //  Point P=PList.get(i);
  //  if((P.X==X)&(P.Y==Y)){
  //    return P.Val;
  //  }
  //}
  //float Val=CalcVal(new PVector(X*Size,Y*Size));
  //PList.add(new Point(X,Y,Val));
  
  if(PList.get(X).get(Y)==null){
    PList.get(X).set(Y,new Point(X,Y,CalcVal(new PVector(X*Size,Y*Size))));
  }
  return PList.get(X).get(Y).Val;
}
boolean NewPoint(int X,int Y){
    //for(int i=0; i<PList.size(); i++){
    //Point P=PList.get(i);
    //if((P.X==X)&(P.Y==Y)){
    //  return false;
    //}
  //}
  return PList.get(X).get(Y)==null;
}
float CalcVal(PVector Pos){
  TimesCalled++;
  float val=0;
  for(int i=0;i<MList.size();i++){
    val+=MList.get(i).MetaVal(Pos);
  }
  return val-1;
}
// shaped like so   2  3
//                  0  1
PVector Grad(float V0,float V1,float V2,float V3){
  return new PVector((V3+V1-V2-V0)/2, (V2+V3-V0-V1)/2);
}
void DrawBases(){
  for(int i=0;i<MList.size();i++){
    MList.get(i).DrawBase();
  }
}
void DrawMetaSpace(){
  Init();
 // PList =new ArrayList<Point>(0);
  ArrayList<Point> Explore=new ArrayList<Point>(0);
  for(int i=0;i<MList.size(); i++){
    MetaBall M=MList.get(i);
    int X=floor(M.Pos.x/Size);int Y=floor(M.Pos.y/Size);
    if(InRange(X,Y)){
      Explore.add(new Point(X,Y,GetVal(X,Y)));
    }
  }
  for(int e=0;e<Explore.size(); e++){
    Point E=Explore.get(e);
    int X=E.X;
    int Y=E.Y;
    float Val;
    if(InRange(X+1,Y)&&NewPoint(X+1,Y)){
      Val=GetVal(X+1,Y);
      if(Val>0){
      Explore.add(new Point(X+1,Y,Val));
      }
    }
    if(InRange(X-1,Y)&&NewPoint(X-1,Y)){
      Val=GetVal(X-1,Y);
      if(Val>0){
      Explore.add(new Point(X-1,Y,Val));
      }
    }
    if(InRange(X,Y+1)&&NewPoint(X,Y+1)){
      Val=GetVal(X,Y+1);
      if(Val>0){
        Explore.add(new Point(X,Y+1,Val));
      }
    }
    if(InRange(X,Y-1)&&NewPoint(X,Y-1)){
      Val=GetVal(X,Y-1);
      if(Val>0){
        Explore.add(new Point(X,Y-1,Val));
      }
    }
  }
  for(int p=0;p<PList.size();p++){
    ArrayList Points=PList.get(p);
    for(int i=0;i<Points.size();i++){
       Point P=PList.get(p).get(i);
        if(P!=null){
          ColorRect(P.X,P.Y);
          if(P.Val<0){// UNEFICIENCIES
            if(InRange(P.X-1,P.Y)&&NewPoint(P.X-1,P.Y)){
              ColorRect(P.X-1,P.Y);
            }
          }
        }
        //stroke(255);
        //rect(PList.get(p).X*Size,PList.get(p).Y*Size,Size,Size);
    }
   
  }
  //for(int p=0;p<PList.size();p++){
  //  stroke(0);
   // PList.get(p).Draw();
  //}
}
void ColorRect(int X,int Y){
  // 0 1
  // 2 3
  float V0;
  float V1;
  float V2;
  float V3;
  if(InRange(X,Y)&&!NewPoint(X,Y)){
    V0=GetVal(X,Y);
  }else{ V0=-100;};
  if(InRange(X+1,Y)&&!NewPoint(X+1,Y)){
    V1=GetVal(X+1,Y);
  }else{ V1=-100;};
  if(InRange(X,Y+1)&&!NewPoint(X,Y+1)){
    V2=GetVal(X,Y+1);
  }else{ V2=-100;};
  if(InRange(X+1,Y+1)&&!NewPoint(X+1,Y+1)){
    V3=GetVal(X+1,Y+1);
  }else{ V3=-100;};
  color fill0,fill1,fill2,fill3;
  fill0=Shader(V0);fill1=Shader(V1);
  fill2=Shader(V2);fill3=Shader(V3);
  int NumPositive=0;
  if(V0>0){NumPositive++;}
  if(V1>0){NumPositive++;}
  if(V2>0){NumPositive++;}
  if(V3>0){NumPositive++;}
  if(NumPositive==4){
    for(int x=-1;x<Size+1;x+=2){
      for(int y=-1;y<Size+1;y+=2){
        color Main= color(
        QuadLerp((float)red(fill0),(float)red(fill1),(float)red(fill2),(float)red(fill3),(float)x/Size,(float)y/Size),
        QuadLerp((float)green(fill0),(float)green(fill1),(float)green(fill2),(float)green(fill3),(float)x/Size,(float)y/Size),
        QuadLerp((float)blue(fill0),(float)blue(fill1),(float)blue(fill2),(float)blue(fill3),(float)x/Size,(float)y/Size));
        fill(Main);
        stroke(Main);
        rect(X*Size+x,Y*Size+y,2,2);
      }
    }
    //rect(X*Size,Y*Size,Size,Size);
  }else if(NumPositive==0){}else{
   //0 -> 1
   //v    v
   //2 -> 3  
   float lerp01=V0/(V0-V1);
   float lerp02=V0/(V0-V2);
   float lerp13=V1/(V1-V3);
   float lerp23=V2/(V2-V3);
  float redtot=0;float greentot=0;float bluetot=0;
  if(V0>0){
    redtot+=red(fill0);greentot+=green(fill0);bluetot+=blue(fill0);
  }  if(V1>0){
    redtot+=red(fill1);greentot+=green(fill1);bluetot+=blue(fill1);
  }  if(V2>0){
    redtot+=red(fill2);greentot+=green(fill2);bluetot+=blue(fill2);
  }  if(V3>0){
    redtot+=red(fill3);greentot+=green(fill3);bluetot+=blue(fill3);
  }
  color Main=color(redtot/NumPositive,greentot/NumPositive,bluetot/NumPositive);
  fill(Main);
  stroke(Main);
  beginShape();
   if(V0>0){
     vertex((X)*Size,(Y)*Size);
   }
   if(FLtween(0,1,lerp01)){     
     vertex((X+lerp01)*Size,Y*Size);
     //ellipse((X+lerp01)*Size,Y*Size,4,4);
   }
   if(V1>0){
     vertex((X+1)*Size,(Y)*Size);
   }
   if(FLtween(0,1,lerp13)){
     vertex((X+1)*Size,(Y+lerp13)*Size);
     //ellipse((X+1)*Size,(Y+lerp13)*Size,4,4);
   }
   if(V3>0){
     vertex((X+1)*Size,(Y+1)*Size);
   }
   if(FLtween(0,1,lerp23)){
     vertex((X+lerp23)*Size,(Y+1)*Size);
     //ellipse((X+lerp23)*Size,(Y+1)*Size,4,4);
   }
   if(V2>0){
     vertex((X)*Size,(Y+1)*Size);
   }
   if(FLtween(0,1,lerp02)){
     vertex((X)*Size,(Y+lerp02)*Size);
    // ellipse(X*Size,(Y+lerp02)*Size,4,4);
   }
   endShape(CLOSE);
  }
}

void setup(){ 
    frameRate(60);
    size(640, 360);
    noSmooth();
    MList.add(new MetaBall(new PVector(100,130),70));
    MList.add(new MetaBall(new PVector(230,270),100));
    MList.add(new MetaBall(new PVector(387,120),70));
}
int TimesCalled=0;
void draw(){
    //PList =new ArrayList<Point>(0);
    TimesCalled=0;
    background(0);
    MList.get(0).Pos=new PVector(mouseX,mouseY);
    //ColorRect(floor(mouseX/Size),floor(mouseY/Size));
    DrawMetaSpace();
    //println(QuadLerp(0.0,1.0,2.0,3.0,((float)mouseX)/Size,((float)mouseY)/Size));
    stroke(255);
    //DrawBases();
    fill(255);
    text("MetaBalls- "+MList.size(),10,15);
    text("Times evaluated- "+TimesCalled,10,15+10);
    //println(InRange(-1,0));
}