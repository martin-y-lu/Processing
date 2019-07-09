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
  Boolean IsPressed(float MouseX,float MouseY){
    return MouseClicked&&IsIn( MouseX,MouseY);
  }
  Boolean IsIn(float MouseX,float MouseY){
    return FLtween(Pos.x,Pos.x+Size.x,MouseX)&&FLtween(Pos.y,Pos.y+Size.y,MouseY);
  }
  void Display(color C){
    stroke(0);
    strokeWeight(2);
    fill(C);
    rect(Pos.x,Pos.y,Size.x,Size.y);
    fill(0);
    text(Text,Pos.x+5,Pos.y+15);
  }
  void Display(color C, PGraphics Window){
    Window.stroke(0);
    Window.strokeWeight(3);
    Window.fill(C);
    Window.rect(Pos.x,Pos.y,Size.x,Size.y);
    Window.fill(0);
    Window.textSize(14);
    Window.text(Text,Pos.x+5,Pos.y+15);
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
   UIButton Move;
   UIButton Resize;
   UIButton Close;
   float MouseX;
   float MouseY;
   Window(PVector dPos,PVector dSize,String dName){
     Pos=dPos;
     Size=dSize;
     Name=dName;
     Window=createGraphics((int)Size.x,(int)Size.y,JAVA2D);
     Move= new UIButton(dPos, new PVector(60,60),".");
     Resize= new UIButton(PVadd(dPos,dSize), new PVector(60,60),".");
     Close=  new UIButton(new PVector(dPos.x+dSize.x,dPos.y), new PVector(30,30),".");
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
       Delete();
     }
     //if(MouseClicked){
        //Active= FLtween(Pos.x,Pos.x+Size.x,mouseX)&&FLtween(Pos.y,Pos.y+Size.y,mouseY);
     //}
     
     if(Active){
       Interact();
     }
   }
   void Delete(){
      Windows.remove(this);
   }
   
   void Draw(){
     Window.beginDraw();
  
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
     Move.Pos=new PVector(Pos.x-30,Pos.y-30);
     Resize.Pos=new PVector(Pos.x+Size.x-30,Pos.y+Size.y-30);
     Close.Pos=new PVector(Pos.x+Size.x-15,Pos.y-15);
     
     MouseX=min(max(0,mouseX-Pos.x),Size.x);
     MouseY=min(max(0,mouseY-Pos.y),Size.y);
     Window=createGraphics((int)Size.x,(int)Size.y,JAVA2D);
   }
   void Interact(){
   }
  
}
class EditorWindow extends Window{
   Editor E;
   EditorWindow(PVector dPos,PVector dSize,String dName, Editor dE){  
     super(dPos,dSize,dName);
     E=dE;
   }
   
   void Draw(){
     Window.beginDraw();
     Window.scale(E.Ia.zoom);
     E.Draw(Window);
     Window.scale(1/E.Ia.zoom);
     Window.endDraw();
  
     super.Draw();
   }
   void Update(){
     super.Update();
     E.Update(MouseX,MouseY);
   }
   void Interact(){
      if(keyPressed){
        E.KeyHeldInteract(prevPress,keyCode);
      }
      if(KeyPressed){
        E.KeyPressInteract(key); 
      }
      E.Interact(MouseClicked);
      super.Interact();
   }
}

class ComponentWindow extends EditorWindow{
  Component C;
  UIButton Save;
  ComponentWindow(PVector dPos, PVector dSize, Component dC){
    super(dPos,dSize,dC.Name, dC.GetEditor());
    C=dC;
  }
  
  void Save(){
    Component Temp=C.GetTemplate();
    Temp=(Component)C.clone();
    FixAllComponents();
  }
  
}
class NewIntegratedWindow extends Window{
   int NumInps=2;
   int NumOuts=2;
   String Name= "IDK";
   Editor OutEdit;
   PVector OutPos;
   
   UIButton InpPlus;
   UIButton InpMinus;
   UIButton OutPlus;
   UIButton OutMinus;
   UIButton NameEdit;
   UIButton Done;
   
   NewIntegratedWindow(PVector dPos, Editor dOutEdit,PVector dOutPos){  
     super(dPos,new PVector(300,300),"New Integrated");
     OutEdit=dOutEdit;
     OutPos=dOutPos;
     InpPlus= new UIButton(new PVector(30,60), new PVector(50,20),"Inp +");
     InpMinus= new UIButton(new PVector(110,60),new PVector(50,20),"Inp -");
     OutPlus= new UIButton(new PVector(30,120), new PVector(50,20),"Out +");
     OutMinus= new UIButton(new PVector(110,120),new PVector(50,20),"Out -");
     NameEdit=  new UIButton(new PVector(40,200),new PVector(200,20),"NAME");
     Done=  new UIButton(new PVector(120,250),new PVector(50,20),"Create");
  }
  void Draw(){
    Window.beginDraw();
    Window.background(0);
    
    Window.textSize(24);
    Window.text(NumInps+" Inputs",180,80);
    InpPlus.Display(color(255),Window);
    InpMinus.Display(color(255),Window);
    
    Window.textSize(24);
    Window.fill(255);
    Window.text(NumOuts+" Outputs",170,140);
    OutPlus.Display(color(255),Window);
    OutMinus.Display(color(255),Window);
    
    NameEdit.Text=Name;
    NameEdit.Display(color(255),Window);
    Done.Display(color(255),Window);
    Window.endDraw();
    super.Draw();
  }
  
  void Update(){
    super.Update();
    if(InpPlus.IsPressed(MouseX,MouseY)){
      NumInps++; 
    }
    if(InpMinus.IsPressed(MouseX,MouseY)){
      NumInps--; 
    }
    if(OutPlus.IsPressed(MouseX,MouseY)){
      NumOuts++; 
    }
    if(OutMinus.IsPressed(MouseX,MouseY)){
      NumOuts--; 
    }
    if(NameEdit.IsIn(MouseX,MouseY)){
      if(KeyPressed){
        if(keyCode==BACKSPACE){
          if(Name.length()>0){
           Name=Name.substring(0,Name.length()- 1); 
          }
        }else{
           Name+=key; 
        }
      }
    }
    if(Done.IsPressed(MouseX,MouseY)){
      CreateGate();
      Delete();
    }
  }
  
  void CreateGate(){
    Logic NewComp= new Component(OutPos,Name,Components.size(),NumInps,NumOuts);
    NewComp.InFeed=new Logic[NumInps];
    ArrayList<Logic> Near=OutEdit.NearestGates(OutPos,OutEdit.Gates,NumInps);
    for(int i=0; i<NumInps;i++){
      if(i<Near.size()){
        NewComp.InFeed[i]=Near.get(i);
      }else{
         NewComp.InFeed[i]=Near.get(Near.size()-1);
      }
     
    }
    
    AddNewComponent((Component) NewComp.clone());
    OutEdit.Gates.add(NewComp);
  }
  
}