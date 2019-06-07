class Slider{
  PVector ScreenPos;
  String Text;
  float Pos=0;
  float Min;
  float Max;
  Slider(PVector dScreenPos,String dText,float dMin,float dMax){
   ScreenPos=dScreenPos; Text= dText; Min=dMin; Max=dMax;
  }
  boolean Sliding(){
    return mousePressed&&(mouseX>Pos+ScreenPos.x)&&(mouseX<Pos+ScreenPos.x+90)
    &&(mouseY>ScreenPos.y-10)&&(mouseY<ScreenPos.y+20+10)&&(Pos>=Min)&&(Pos<=Max);
  }
  void ChangeText(String NewT){
    Text=NewT;
  }
  void CalcSlide(){
    if(Sliding()){
      Pos=mouseX-ScreenPos.x-45;
    }
    if(Pos>Max){
       Pos=Max;
    }if(Pos<Min){
       Pos=Min;
    }
  }
  void Display(){
    fill(255);
    rect(ScreenPos.x+Pos,ScreenPos.y,80,20);
    fill(0);
    text(Text,ScreenPos.x+Pos+10,ScreenPos.y+15);
  }
}
void setup(){
    frameRate(60);
    size(640, 360);
}
Slider S=new Slider(new PVector(50,20),"Corners",0,20*20);
Slider SA=new Slider(new PVector(50,60),"Shift",0,0);
void draw(){
  background(0); 
  stroke(255);
  S.CalcSlide();
  S.ChangeText("Corners :"+floor(S.Pos/20));
  S.Display();
  SA.Max=S.Pos;
  SA.CalcSlide();
  SA.ChangeText("Shift :"+floor(SA.Pos/40));
  SA.Display();
  float PoiNum=floor(S.Pos/20);
  float Change=floor(SA.Pos/40);
  float N=Change;
  line(100+200,200,
  100*cos(2*(N)/PoiNum*PI)+200,100*sin(2*(N)/PoiNum*PI)+200);
  while(N!=0){
    line(100*cos(2*N/PoiNum*PI)+200,100*sin(2*N/PoiNum*PI)+200,
    100*cos(2*((N+Change)%PoiNum)/PoiNum*PI)+200,100*sin(2*((N+Change))/PoiNum*PI)+200);
    N=(N+Change)%PoiNum;
  }
  for(float P=0;P<=PoiNum;P++){
    ellipse(100*cos(2*P/PoiNum*PI)+200,100*sin(2*P/PoiNum*PI)+200,2,2);
  }
}