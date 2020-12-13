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
     
     if(Active){
       if(MouseClicked){
         MoveWindowToTop(this); 
       }
       Interact();
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
     E.Update(MouseX,MouseY,true);
   }
   void Interact(){
      if(keyPressed){
        E.KeyHeldInteract(prevPress,keyCode,true);
      }
      if(KeyPressed){
        E.KeyPressInteract(key,true); 
      }
      E.Interact(MouseClicked,true);
   }
}
class MainWindow extends EditorWindow{
  MainWindow(PVector dPos,PVector dSize,String dName, Editor dE){  
     super(dPos,dSize,dName,dE);
  }
  void Delete(){
   //Can't delete 
  }
}
class ViewWindow extends Window{
   Editor E;
   Component C;
   UIButton OpenEdit;
   UIButton Refresh;
   ViewWindow(PVector dPos,PVector dSize, Component dC){  
     super(dPos,dSize,dC.Name+" View");
     E=dC.GetEditor();
     C=dC;
      OpenEdit = new UIButton(new PVector(250,20), new PVector(100,20),"Open Editor");
      Refresh = new UIButton(new PVector(140,20), new PVector(100,20),"Refresh");
   }
   
   void Draw(){
     Window.beginDraw();
     Window.scale(E.Ia.zoom);
     E.Draw(Window);
     Window.scale(1/E.Ia.zoom);
     
     OpenEdit.Display(color(255),Window);
     Refresh.Display(color(255),Window);
     Window.endDraw();
     super.Draw();
   }
   void Update(){
     super.Update();
     E.Update(MouseX,MouseY,false);
   }
   void Interact(){
    if(keyPressed){
      E.KeyHeldInteract(prevPress,keyCode,false);
    }
    if(KeyPressed){
      E.KeyPressInteract(key,false); 
    }
    E.Interact(MouseClicked,false);
    
    if(OpenEdit.IsPressed(MouseX,MouseY)){
      Windows.add(new ComponentWindow(new PVector(200,200),new PVector(800,400),C));
    }
    if(Refresh.IsPressed(MouseX,MouseY)){
      E=C.GetEditor();
    }
    super.Interact();
  }
}

class ComponentWindow extends EditorWindow{
  Component C;
  UIButton Save;
  ComponentWindow(PVector dPos, PVector dSize, Component dC){
    super(dPos,dSize,dC.Name+" Editor", ((Component)dC.GetTemplate()).GetEditor());
    C=dC.GetTemplate();
    Save = new UIButton(new PVector(140,20), new PVector(100,20),"Save/Update");
  }
  
  void Draw(){
    super.Draw();
    Window.beginDraw();
    Save.Display(color(255),Window);
    Window.endDraw();
  }
  
  void Interact(){
   super.Interact();
   if(Save.IsPressed(MouseX,MouseY)){
     Save();
   }
  }
  
  void Save(){
    print("Saving"+ Name);
    Component temp=C.GetTemplate();
    temp=(Component)C.clone();
    FixAllComponents();
  }
  
}
class NewComponentWindow extends Window{
   int NumInps=2;
   int NumOuts=2;
   int NumDisplayWidth=0;
   int NumDisplayHeight=0;
   String Name= "IDK";
   Editor OutEdit;
   PVector OutPos;
   
   UIButton InpPlus;
   UIButton InpMinus;
   UIButton OutPlus;
   UIButton OutMinus;
   UIButton DispWidthPlus;
   UIButton DispWidthMinus;
   UIButton DispHeightPlus;
   UIButton DispHeightMinus;
   UIButton NameEdit;
   UIButton Done;
   
   ArrayList<UIButton> ComponentButtons=new ArrayList<UIButton>();
   boolean[] Create;
   
   NewComponentWindow(PVector dPos, Editor dOutEdit,PVector dOutPos){  
     super(dPos,new PVector(300,600),"New Integrated");
     OutEdit=dOutEdit;
     OutPos=dOutPos;
     InpPlus= new UIButton(new PVector(30,50), new PVector(50,20),"Inp +");
     InpMinus= new UIButton(new PVector(110,50),new PVector(50,20),"Inp -");
     OutPlus= new UIButton(new PVector(30,90), new PVector(50,20),"Out +");
     OutMinus= new UIButton(new PVector(110,90),new PVector(50,20),"Out -");
     DispWidthPlus= new UIButton(new PVector(110,170), new PVector(20,20),"+");
     DispWidthMinus= new UIButton(new PVector(150,170),new PVector(20,20),"-");
     DispHeightPlus= new UIButton(new PVector(110,210), new PVector(20,20),"+");
     DispHeightMinus= new UIButton(new PVector(150,210),new PVector(20,20),"-");
     NameEdit=  new UIButton(new PVector(40,260),new PVector(200,20),"NAME");
     Done=  new UIButton(new PVector(120,300),new PVector(50,20),"Create");
     
     Create= new boolean[Components.size()];
     for(int i=0; i<Components.size();i++){
       
       if( OutEdit instanceof ComponentEditor){
        if(Components.get(i).Contains(((ComponentEditor) OutEdit).C)){
          Create[i]=false;
        }else{
          Create[i]=true; 
        }
       }else{
        Create[i]= true;
       }
       ComponentButtons.add(new  UIButton(new PVector(100,380+20*i),new PVector(100,20), Components.get(i).Name+ Components.get(i).Number));
     }
  }
  void Draw(){
    Window.beginDraw();
    Window.background(0);
    
    Window.textSize(24);
    Window.text(NumInps+" Inputs",180,70);
    InpPlus.Display(color(255),Window);
    InpMinus.Display(color(255),Window);
    
    Window.textSize(24);
    Window.fill(255);
    Window.text(NumOuts+" Outputs",170,110);
    OutPlus.Display(color(255),Window);
    OutMinus.Display(color(255),Window);
    
    Window.textSize(18);
    Window.fill(255);
    Window.text("Display",28,142);
    
    Window.textSize(24);
    Window.fill(255);
    Window.text("Width "+NumDisplayWidth,185,185);
    DispWidthPlus.Display(color(255),Window);
    DispWidthMinus.Display(color(255),Window);
    Window.textSize(24);
    Window.fill(255);
    Window.text("Height "+NumDisplayHeight,185,230);
    DispHeightPlus.Display(color(255),Window);
    DispHeightMinus.Display(color(255),Window);
    
    //Window.fill(255);
    //Window.rect(20,160,80,80);
    Window.fill(255,0,0);
    Window.stroke(255);
    Window.strokeWeight(2.5);
    for(int i=0;i<NumDisplayWidth;i++){
      for(int j=0;j<NumDisplayHeight;j++){
        Window.rect(22+i*80.0/float(NumDisplayWidth),160+j*80.0/float(NumDisplayWidth),0.7*80.0/float(NumDisplayWidth),0.7*80.0/float(NumDisplayWidth));
      }
    }
    
    NameEdit.Text=Name;
    NameEdit.Display(color(255),Window);
    Done.Display(color(255),Window);
    
    for(int i=0; i<ComponentButtons.size();i++){
      if(Create[i]){
        ComponentButtons.get(i).Display(color(255),Window);
      }else{
        ComponentButtons.get(i).Display(color(255,0,0),Window);
      }
    }
    Window.endDraw();
    super.Draw();
  }
  
  void Update(){
    super.Update();
  }
  void Interact(){
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
    if(DispWidthPlus.IsPressed(MouseX,MouseY)){
      NumDisplayWidth++; 
    }
    if(DispWidthMinus.IsPressed(MouseX,MouseY)){
      NumDisplayWidth--; 
    }
    if(DispHeightPlus.IsPressed(MouseX,MouseY)){
      NumDisplayHeight++; 
    }
    if(DispHeightMinus.IsPressed(MouseX,MouseY)){
      NumDisplayHeight--; 
    }
    NumDisplayHeight=max(0,NumDisplayHeight);
    NumDisplayWidth=max(0,NumDisplayWidth);
    
    if(NameEdit.IsIn(MouseX,MouseY)){
      if(KeyPressed){
        if(keyCode==BACKSPACE){
          if(Name.length()>0){
           Name=Name.substring(0,Name.length()- 1); 
          }
        }else{
          if(Character.isAlphabetic(key)){
           Name+=key; 
          }
        }
      }
    }
    for(int i=0; i<ComponentButtons.size();i++){
      if(Create[i]){
        if(ComponentButtons.get(i).IsPressed(MouseX,MouseY)){
          Delete();
          CreateGate(Components.get(i).clone());
          println("Component placed");
        }
      }
    }
    if(Done.IsPressed(MouseX,MouseY)){
      CreateGate();
      Delete();
      println("New Component made");
    }
    
  }
  
  void CreateGate(){
    Logic NewComp= new Component(OutPos,Name,Components.size(),NumInps,NumOuts,NumDisplayWidth,NumDisplayHeight);
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
  void CreateGate(Logic NewComp){
    ((Component)NewComp).Pos=OutPos;
    ArrayList<Logic> Near=OutEdit.NearestGates(OutPos,OutEdit.Gates,NewComp.InFeed.length);
    for(int i=0; i<NewComp.InFeed.length;i++){
      if(i<Near.size()){
        NewComp.InFeed[i]=Near.get(i);
      }else{
         NewComp.InFeed[i]=Near.get(Near.size()-1);
      }
    }
    OutEdit.Gates.add(NewComp);
  }
  
}
class ModifyComponentWindow extends Window{
   int NumInps;
   int NumOuts;
   int NumDisplayWidth;
   int NumDisplayHeight;
   String Name;
   
   Component Modifying;
   
   UIButton InpPlus;
   UIButton InpMinus;
   UIButton OutPlus;
   UIButton OutMinus;
   UIButton DispWidthPlus;
   UIButton DispWidthMinus;
   UIButton DispHeightPlus;
   UIButton DispHeightMinus;
   UIButton NameEdit;
   UIButton Done;
   
   ModifyComponentWindow(PVector dPos, Component dModifying){  
     super(dPos,new PVector(300,400),"Modify "+dModifying.Name);
     Modifying=dModifying;
     
     NumInps=Modifying.NumInps;
     NumOuts=Modifying.NumOuts;
     NumDisplayWidth=Modifying.DispWidth;
     NumDisplayHeight=Modifying.DispHeight;
     Name=Modifying.Name;
     
     InpPlus= new UIButton(new PVector(30,50), new PVector(50,20),"Inp +");
     InpMinus= new UIButton(new PVector(110,50),new PVector(50,20),"Inp -");
     OutPlus= new UIButton(new PVector(30,90), new PVector(50,20),"Out +");
     OutMinus= new UIButton(new PVector(110,90),new PVector(50,20),"Out -");
     DispWidthPlus= new UIButton(new PVector(110,170), new PVector(20,20),"+");
     DispWidthMinus= new UIButton(new PVector(150,170),new PVector(20,20),"-");
     DispHeightPlus= new UIButton(new PVector(110,210), new PVector(20,20),"+");
     DispHeightMinus= new UIButton(new PVector(150,210),new PVector(20,20),"-");
     NameEdit=  new UIButton(new PVector(40,260),new PVector(200,20),"NAME");
     Done=  new UIButton(new PVector(120,300),new PVector(50,20),"Commit");
  }
  void Draw(){
    Window.beginDraw();
    Window.background(0);
    
    Window.textSize(24);
    Window.text(NumInps+" Inputs",180,70);
    InpPlus.Display(color(255),Window);
    InpMinus.Display(color(255),Window);
    
    Window.textSize(24);
    Window.fill(255);
    Window.text(NumOuts+" Outputs",170,110);
    OutPlus.Display(color(255),Window);
    OutMinus.Display(color(255),Window);
    
    Window.textSize(18);
    Window.fill(255);
    Window.text("Display",28,142);
    
    Window.textSize(24);
    Window.fill(255);
    Window.text("Width "+NumDisplayWidth,185,185);
    DispWidthPlus.Display(color(255),Window);
    DispWidthMinus.Display(color(255),Window);
    Window.textSize(24);
    Window.fill(255);
    Window.text("Height "+NumDisplayHeight,185,230);
    DispHeightPlus.Display(color(255),Window);
    DispHeightMinus.Display(color(255),Window);
    
    //Window.fill(255);
    //Window.rect(20,160,80,80);
    Window.fill(255,0,0);
    Window.stroke(255);
    Window.strokeWeight(2.5);
    for(int i=0;i<NumDisplayWidth;i++){
      for(int j=0;j<NumDisplayHeight;j++){
        Window.rect(22+i*80.0/float(NumDisplayWidth),160+j*80.0/float(NumDisplayWidth),0.7*80.0/float(NumDisplayWidth),0.7*80.0/float(NumDisplayWidth));
      }
    }
    
    NameEdit.Text=Name;
    NameEdit.Display(color(255),Window);
    Done.Display(color(255),Window);
    Window.endDraw();
    super.Draw();
  }
  
  void Update(){
    super.Update();
  }
  void Interact(){
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
    if(DispWidthPlus.IsPressed(MouseX,MouseY)){
      NumDisplayWidth++; 
    }
    if(DispWidthMinus.IsPressed(MouseX,MouseY)){
      NumDisplayWidth--; 
    }
    if(DispHeightPlus.IsPressed(MouseX,MouseY)){
      NumDisplayHeight++; 
    }
    if(DispHeightMinus.IsPressed(MouseX,MouseY)){
      NumDisplayHeight--; 
    }
    NumDisplayHeight=max(0,NumDisplayHeight);
    NumDisplayWidth=max(0,NumDisplayWidth);
    
    if(NameEdit.IsIn(MouseX,MouseY)){
      if(KeyPressed){
        if(keyCode==BACKSPACE){
          if(Name.length()>0){
           Name=Name.substring(0,Name.length()- 1); 
          }
        }else{
          if(Character.isAlphabetic(key)){
           Name+=key; 
          }
        }
      }
    }
    if(Done.IsPressed(MouseX,MouseY)){
      ModifyGate();
      Delete();
      println("New Component made");
    } 
  }
  void ModifyGate(){
    if(NumInps>Modifying.NumInps){
      for(int i=Modifying.NumInps;i<NumInps;i++){
         Gate Inp= new ComponentInput(new PVector(0,-500+i*50),i);
         Modifying.Internals.add(i,Inp);
      }
      Modifying.NumInps=NumInps;
    }
    if(NumInps<Modifying.NumInps){
      for(int i=Modifying.NumInps;i>NumInps;i--){
        Modifying.Internals.remove(i-1);
      }
      Modifying.NumInps=NumInps;
    }
    if(NumOuts>Modifying.NumOuts){
      for(int i=Modifying.NumOuts;i<NumOuts;i++){
         Gate Inp= new ComponentOutput(new PVector(0,-500+i*50),i);
         Modifying.Internals.add(NumInps-i,Inp);
      }
      Modifying.NumOuts=NumOuts;
    }
    if(NumOuts<Modifying.NumOuts){
      for(int i=Modifying.NumOuts;i>NumOuts;i--){
        Modifying.Internals.remove(NumInps+i-1);
      }
      Modifying.NumOuts=NumOuts;
    }
    Modifying.Name=Name;
    if((Modifying.DispWidth!=NumDisplayWidth)||(Modifying.DispHeight!=NumDisplayHeight)){
      for(int i=Modifying.Internals.size();i<=0; i--){
        if(Modifying.Internals.get(i) instanceof ComponentDisplay){
          Modifying.Internals.remove(i); 
        }
      }
      for(int w=0;w<NumDisplayWidth;w++){
         for(int h=0;h<NumDisplayHeight;h++){
           Gate Disp= new ComponentDisplay(new PVector(500+70*w,-500+70*NumDisplayHeight-70*h),w*NumDisplayHeight+h);
           if((w==0)&(h==0)){
             Disp.InFeed=new Logic[]{Modifying.Internals.get(NumInps+NumOuts-1)};
           }else{
             Disp.InFeed=new Logic[]{Modifying.Internals.get(Modifying.Internals.size()-1)};
           }
           Modifying.Internals.add(NumInps+NumOuts+w*NumDisplayHeight+h,Disp);
         }
      }
      Modifying.DispWidth=NumDisplayWidth;
      Modifying.DispHeight=NumDisplayHeight;
    }
    
  }
  
}


class WindowOpener extends Window{
   
  //UIButton MainWindow;
   ArrayList<UIButton> ComponentButtons=new ArrayList<UIButton>();
   
   WindowOpener(PVector dPos){  
     super(dPos,new PVector(300,400),"New Window");
     //MainWindow= new UIButton(new PVector(100,100),new PVector(100,20),"Main Window");
     for(int i=0; i<Components.size();i++){
       ComponentButtons.add(new  UIButton(new PVector(80,100+20*i),new PVector(140,20), Components.get(i).Name+ Components.get(i).Number+" Editor"));
     }
  }
  void Draw(){
    Window.beginDraw();
    Window.background(0);
    
    Window.textSize(18);
    Window.text("Open Window",80,80);
    
    //MainWindow.Display(color(255),Window);
    for(int i=0; i<ComponentButtons.size();i++){
        ComponentButtons.get(i).Display(color(255),Window);
    }
    Window.endDraw();
    super.Draw();
  }
  
  void Update(){
    super.Update();
  }
  void Interact(){
    //if(MainWindow.IsPressed(MouseX,MouseY)){
    //  Windows.add( new EditorWindow(new PVector(100,100),new PVector(800,400),"Main Window",E));
    //  Delete();
    //}
    for(int i=0; i<ComponentButtons.size();i++){
      if(ComponentButtons.get(i).IsPressed(MouseX,MouseY)){
        Windows.add(new ComponentWindow(new PVector(200,200),new PVector(800,400),Components.get(i)));
        Delete();
      }
    }
  }
}