class UIButton{
  PVector Pos;
  PVector Size;
  String Text;
  UIButton(PVector DPos,PVector DSize,String DText){
    Pos=DPos; Size=DSize; Text=DText;
  }
  Boolean IsPressed(){
    return MouseClicked&&IsIn();
  }
  Boolean IsIn(){
    return FLtween(Pos.x,Pos.x+Size.x,mouseX)&&FLtween(Pos.y,Pos.y+Size.y,mouseY);
  }
  void Display(color C){
    stroke(0);
    strokeWeight(2);
    fill(C);
    rect(Pos.x,Pos.y,Size.x,Size.y);
    fill(0);
    text(Text,Pos.x+5,Pos.y+15);
  }
}
class UISlider{
  PVector ScreenPos;
  String Text;
  float Pos=0;
  float Min;
  float Max;
  boolean Slide=false;
  UISlider(PVector dScreenPos,String dText,float dMin,float dMax){
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
    if(Sliding()||Slide){
     Slide=true;
      Pos=mouseX-ScreenPos.x-45;
    }
    if(!mousePressed){
     Slide=false; 
    }
    if(Pos>Max){
       Pos=Max;
    }if(Pos<Min){
       Pos=Min;
    }
  }
}
class Window{
   PVector Pos;
   PVector Size;
   String Name;
   PGraphics Window;
   boolean Active=false;
   Editor E;
   
   UIButton Move;
   UIButton Resize;
   UIButton Close;
   Window(PVector dPos,PVector dSize,String dName, Editor dE){
     Pos=dPos;
     Size=dSize;
     Name=dName;
     Window=createGraphics((int)Size.x,(int)Size.y,JAVA2D);
     Move= new UIButton(dPos, new PVector(60,60),".");
     Resize= new UIButton(PVadd(dPos,dSize), new PVector(60,60),".");
     Close=  new UIButton(new PVector(dPos.x+dSize.x,dPos.y), new PVector(30,30),".");
     E=dE;
   }
   boolean MouseIn(){
      return FLtween(Pos.x,Pos.x+Size.x,mouseX)&&FLtween(Pos.y,Pos.y+Size.y,mouseY);
   }
   void Run(){
     Update();
     Draw();
     
     if(mousePressed&&Move.IsIn()){
        Pos=new PVector(mouseX+10,mouseY+10); 
     }
     if(mousePressed&&Resize.IsIn()){
       Size=new PVector(mouseX-Pos.x,mouseY-Pos.y); 
     }
     if(mousePressed&&Close.IsIn()){
        Windows.remove(this);
     }
     if(MouseClicked){
        Active= FLtween(Pos.x,Pos.x+Size.x,mouseX)&&FLtween(Pos.y,Pos.y+Size.y,mouseY);
     }
     
     if(Active){
       Interact();
     }
   }
   
   
   void Draw(){
     Window.beginDraw();
     Window.scale(E.Ia.zoom);
     E.Draw(Window);
     Window.scale(1/E.Ia.zoom);
  
     Window.stroke(155);
     Window.strokeWeight(2);
     Window.fill(255);
     Window.rect(0,0,120,25);
     
    
     Window.noFill();
     Window.strokeWeight(5);
     Window.rect(0,0,Size.x,Size.y);
     Window.fill(0);
     Window.textSize(14);
     Window.text(Name,10,18);
     Window.endDraw();
     image(Window,Pos.x,Pos.y);
     if(Move.IsIn()){
       Move.Display(color(255));
     }
     if(Resize.IsIn()){
       Resize.Display(color(255));
     }
     if(Close.IsIn()){
       Close.Display(color(255));
     }
   }
   void Update(){
     float MouseX=min(max(0,mouseX-Pos.x),Size.x);
     float MouseY=min(max(0,mouseY-Pos.y),Size.y);
     E.Update(MouseX,MouseY);
     Move.Pos=new PVector(Pos.x-30,Pos.y-30);
     Resize.Pos=new PVector(Pos.x+Size.x-30,Pos.y+Size.y-30);
     Close.Pos=new PVector(Pos.x+Size.x-15,Pos.y-15);
     Window=createGraphics((int)Size.x,(int)Size.y,JAVA2D);
   }
   void Interact(){
      E.Interact(MouseClicked);
      if(keyPressed){
        E.KeyHeldInteract(prevPress,keyCode);
      }
      if(KeyPressed){
        E.KeyPressInteract(key); 
      }
   }
  
}