class Logic{
  boolean[] Inp;
  boolean[] Out;
  Logic[] InFeed;
  int[] InFeedIndexes;
  
  String StateString(){
    String State="";
    for(int i=0;i<Out.length;i++){
      State+=Out[i];
      State+=';';
    }
    
    return State;
  }
  void DecodeStateString(String State){
    //String[] States= split(State,';');
    //for(int i=0;i<Out.length;i++){
    //  Out[i]=States[i].equals("true");
    
    if(Out.length>0){
      Out[0]=State.equals("true");
    } 
  }
  
  Logic(boolean[] dInp, boolean[] dOut, Logic[] dInFeed,int[]dInFeedIndexes){
    Inp=dInp;
    Out=dOut;
    InFeed=dInFeed;
    InFeedIndexes=dInFeedIndexes;
  }
  void CalcOut(){
    Out[0]=Inp[0];//Eg feed out
  }
  void FeedIn(){
    for( int i=0; i<Inp.length;i++){
      Inp[i]=InFeed[i].Out[InFeedIndexes[i]];
    }
  }
  void Update(){
    //FeedIn();
    //printArray(Gates.get(2).Inp);
    //CalcOut();
  }
  void Interact(Editor E){
  }
  Logic clone(){
    Logic Clone = new Logic(Inp,Out,InFeed,InFeedIndexes);
    return Clone;
  }
}

class Gate extends Logic{
  PVector Pos;
  PVector Size;

  PVector[] InpPos;
  PVector[] OutPos;
  
  Gate(PVector dPos, PVector dSize, int NumInps, int NumOut, PVector[] dInpPos, PVector[] dOutPos){
    super(new boolean[NumInps],new boolean[NumOut],new Logic[NumInps],new int[NumInps]);
    Pos=dPos;
    Size=dSize;
    InpPos=dInpPos;
    OutPos=dOutPos;
  }
  void Draw(PGraphics Window){
    Window.fill(255,30);
    Window.noStroke();
    Window.rect(Pos.x,Pos.y,Size.x,Size.y);
    Window.stroke(255);
    Window.strokeWeight(2);
    for(int i=0; i<InpPos.length;i++){
      Gate InpGate=(Gate)InFeed[i];
        if(InpGate.Out[InFeedIndexes[i]]){
          Window.stroke(40,200,40);
        }else{
          Window.stroke(200,40,40); 
        }
        Window.line(InpGate.ScreenPointOut(InFeedIndexes[i]).x,InpGate.ScreenPointOut(InFeedIndexes[i]).y,ScreenPointInp(i).x,ScreenPointInp(i).y);
    }
  }
  boolean Moused(Editor E){
    return E.Ia.MouseIn(Pos,Size);
  }
  PVector ScreenPointInp(int inpNum){
    return PVadd(Pos,InpPos[inpNum]);
  }
  PVector ScreenPointOut(int outNum){
    return PVadd(Pos,OutPos[outNum]);
  }
  Logic clone(){
    Gate Clone = new Gate(Pos,Size,Inp.length,Out.length,InpPos,OutPos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    return Clone;
  }
}
class Button extends Gate{
  boolean State;
  Button(PVector dPos,boolean dState){
    super(dPos,new PVector(20,20),0,1,new PVector[]{},new PVector[]{new PVector(30,10)});
    State=dState;
  }
  void Draw(PGraphics Window){
    super.Draw(Window);
    if(State){
      Window.fill(40,200,40);
    }else{
      Window.fill(200,40,40); 
    }
    Window.stroke(255);
    Window.strokeWeight(2);
    Window.ellipse(Pos.x+10,Pos.y+10,40,40);
    Window.ellipse(Pos.x+10,Pos.y+10,20,20);
    
    //shape(Or,Pos.x,Pos.y);
  }
  void CalcOut(){
    Out[0]=State;
  }
  void Update(){
    super.Update();
  }
  void Interact(Editor E){
    if((!Moused(E))&&E.Ia.MouseIn(PVadd(Pos, new PVector(-5,-5)),new PVector(40,40))&&MouseClicked){
      State=!State;
      print("Switch state");
    }
  }
  Logic clone(){
    Button Clone = new Button(Pos,State);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    return Clone;
  }
}
class Display extends Gate{
  Display(PVector dPos){
    super(dPos,new PVector(40,40),1,1,new PVector[]{new PVector(0,20)},new PVector[]{new PVector(30,20)});
  }
  void Draw(PGraphics Window){
    super.Draw(Window);
    if(Inp[0]){
      Window.fill(40,200,40);
    }else{
      Window.fill(200,40,40); 
    }
    Window.stroke(255);
    Window.strokeWeight(2);
    Window.ellipse(Pos.x+20,Pos.y+20,40,40);
  }
  void CalcOut(){
    Out[0]=Inp[0];
  }
  void Update(){
    super.Update();
  }
  Logic clone(){
    Display Clone = new Display(Pos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    Clone.InFeedIndexes=InFeedIndexes.clone();
    return Clone;
  }
}
class NoDelayDisplay extends Gate{
  NoDelayDisplay(PVector dPos){
    super(dPos,new PVector(20,20),1,1,new PVector[]{new PVector(0,10)},new PVector[]{new PVector(20,10)});
  }
  void Draw(PGraphics Window){
    super.Draw(Window);
    if(Inp[0]){
      Window.fill(40,200,40);
    }else{
      Window.fill(200,40,40); 
    }
    Window.stroke(255);
    Window.strokeWeight(2);
    Window.ellipse(Pos.x+10,Pos.y+10,20,20);
  }
  boolean GetState(){
    if(InFeed[0] instanceof NoDelayDisplay){
      if(!Looped(this)){
        return ((NoDelayDisplay)InFeed[0]).GetState();
      }
    }
    return InFeed[0].Out[InFeedIndexes[0]];
  }
  boolean Looped(Gate This){
    if(InFeed[0] instanceof NoDelayDisplay){
      if(InFeed[0] == This){
        return true; 
      }
      return  ((NoDelayDisplay)InFeed[0]).Looped(This);
    }
    return false;
  }
  void CalcOut(){
    Out[0]=GetState();
  }
  void Update(){
    super.Update();
  }
  Logic clone(){
    NoDelayDisplay Clone = new NoDelayDisplay(Pos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    Clone.InFeedIndexes=InFeedIndexes.clone();
    return Clone;
  }
}
class OrGate extends Gate{
  OrGate(PVector dPos){
    super(dPos,new PVector(60,40),2,1,new PVector[]{new PVector(0,10),new PVector(0,30)},new PVector[]{new PVector(60,20)});
  }
  void Draw(PGraphics Window){
    super.Draw(Window);
    Window.shape(Or,Pos.x,Pos.y);
  }
  void CalcOut(){
    Out[0]=Inp[0]||Inp[1];
  }
  Logic clone(){
    OrGate Clone = new OrGate(Pos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    Clone.InFeedIndexes=InFeedIndexes.clone();
    return Clone;
  }
}
class AndGate extends Gate{
  AndGate(PVector dPos){
    super(dPos,new PVector(60,40),2,1,new PVector[]{new PVector(0,10),new PVector(0,30)},new PVector[]{new PVector(60,20)});
  }
  void Draw(PGraphics Window){
    super.Draw(Window);
    Window.shape(And,Pos.x,Pos.y);
  }
  void CalcOut(){
    Out[0]=Inp[0]&&Inp[1];
  }
  Logic clone(){
    AndGate Clone = new AndGate(Pos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    Clone.InFeedIndexes=InFeedIndexes.clone();
    return Clone;
  }
}
class NotGate extends Gate{
  NotGate(PVector dPos){
    super(dPos,new PVector(30+3+5,30),1,1,new PVector[]{new PVector(0,15)},new PVector[]{new PVector(35,15)});
  }
  void Draw(PGraphics Window){
    super.Draw(Window);
    Window.shape(Not,Pos.x,Pos.y);
  }
  void CalcOut(){
    Out[0]=!Inp[0];
  }
  Logic clone(){
    NotGate Clone = new NotGate(Pos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    Clone.InFeedIndexes=InFeedIndexes.clone();
    return Clone;
  }
}

class Component extends Gate{
  String Name;
  int Number;
  ArrayList<Logic> Internals;
  int NumInps;
  int NumOuts;
  
  int DispWidth;
  int DispHeight;
  String FileName(){
    return "Component-"+Name; 
  }
  boolean Contains(Component Temp){
    if(GetTemplate()==Temp){
      return true;
    }
    ArrayList<Component> Contained= new ArrayList<Component>();
    for(int i=0; i<Internals.size();i++){
      if(Internals.get(i) instanceof Component){
        Component Template=((Component) Internals.get(i)).GetTemplate();
        if(Template== Temp){
          return true;
        }
        if(!Contained.contains(Template)){
          Contained.add(Template);
        }
      }
    }
    for( int c=0; c<Contained.size(); c++){
      boolean subContain= Contained.get(c).Contains(Temp);
      if( subContain){
       return true;
      }
    }
    return false;
  }
  
  String StateString(){
    String State="{";
    for( int i=0; i<Internals.size();i++){
     if(!(Internals.get(i) instanceof NoDelayDisplay)){
       State+=Internals.get(i).StateString();
       State+=":";
     }
    }
    State+="}";
    return State;
  }
  void DecodeStateString(String State){
    String[] States= new String[0];
    String StateString=""+ State;
    String thisString="";
     while(StateString.length()>0){
        //println("State String length:"+ StateString.length());
        if(StateString.charAt(0)==':'){// If seperator found
          if(thisString.length()>0){
            States=append(States,thisString);// Add to states
          }
          thisString="";// clear
          StateString=StateString.substring(1);//Stepforward
        }else if(StateString.charAt(0)=='{'){// if Component state found
          StateString=StateString.substring(1); // Get rid of {
          thisString="";
          int numOpens=1;
          while((numOpens>0)){// While component state end not found
            thisString+=StateString.charAt(0); //Add to this string
            StateString=StateString.substring(1); // Step forward
            if(StateString.charAt(0)=='{'){
              numOpens++; 
            }else if(StateString.charAt(0)=='}'){
              numOpens--;
            }
          } 
          // Once found
          if(thisString.length()>0){
            States=append(States,thisString);// Add to states
          }
          thisString="";// clear
          StateString=StateString.substring(1);//  step forward X
        }else{// Else no special char
          thisString+=StateString.charAt(0); // Add to string
          StateString=StateString.substring(1); //step forward 
        }
      }
    
    int shift=0;
    for(int i=0; i<States.length;i++){
      Gate ThisGate= (Gate) Internals.get(i+shift);
      if(ThisGate instanceof NoDelayDisplay){
        shift++;
        while((i+shift+2<Internals.size())&&(Internals.get(i+shift+1) instanceof NoDelayDisplay)){
          shift++;
        }
      }
      //if(ThisGate instanceof Component){
      //  ((Component)ThisGate).FixComponent();
      //}
      ThisGate.DecodeStateString(States[i]);
    }
  }
  Component(PVector dPos,String dName,int dNumber,int dNumInps,int dNumOuts){
    super(dPos,new PVector(100,100),dNumInps,dNumOuts,new PVector[dNumInps],new PVector[dNumOuts]);
    Initialise(dName,dNumber,dNumInps,dNumOuts,0,0);
  }
  Component(PVector dPos,String dName,int dNumber,int dNumInps,int dNumOuts,int dDispWidth, int dDispHeight){
    super(dPos,new PVector(100,100),dNumInps,dNumOuts,new PVector[dNumInps],new PVector[dNumOuts]);
    Initialise(dName,dNumber,dNumInps,dNumOuts,dDispWidth,dDispHeight);
  }
  void Initialise(String dName,int dNumber,int dNumInps,int dNumOuts,int dDispWidth, int dDispHeight){
    NumInps=dNumInps;
      NumOuts=dNumOuts;
      DispWidth=dDispWidth;
      DispHeight=dDispHeight;
    
      float Height=max((dNumInps-1)*20+40,(dNumOuts-1)*20+40);
      Size= new PVector(100,Height);
      
      PVector[]Inps=new PVector[dNumInps];
      int i=0;
      for(float y=0.5*(Height-20*(dNumInps-1));i<dNumInps;y+=20){
          Inps[i]= new PVector(10,y);
          i++;
      }
      
      PVector[]Outs=new PVector[dNumOuts];
      int j=0;
      for(float y=0.5*(Height-20*(dNumOuts-1));j<dNumOuts;y+=20){
          Outs[j]= new PVector(90,y);
          j++;
      }
      
      InpPos=Inps;
      OutPos=Outs;
      
      Name=dName;
      Number=dNumber;
      
      Internals=new ArrayList<Logic>();
      for(int k=0;k<dNumInps;k++){
         Gate Inp= new ComponentInput(new PVector(0,100+k*50),k);
         Internals.add(Inp);
      }
      for(int l=0;l<dNumOuts;l++){
         Gate Out= new ComponentOutput(new PVector(500,100+l*50),l);
         Out.InFeed=new Logic[]{Internals.get(min(l,dNumInps-1))};
         Internals.add(Out);
      }
      for(int w=0;w<DispWidth;w++){
         for(int h=0;h<DispHeight;h++){
           Gate Disp= new ComponentDisplay(new PVector(580+70*w,70+70*DispHeight-70*h),w*DispHeight+h);
           if((w==0)&(h==0)){
             Disp.InFeed=new Logic[]{Internals.get(NumInps+NumOuts-1)};
           }else{
             Disp.InFeed=new Logic[]{Internals.get(Internals.size()-1)};
           }
           Internals.add(Disp);
         }
      }
  }
  void FixInitial(){
    for( int i=0; i<Internals.size();i++){
      Gate GateI=(Gate)Internals.get(i);
      if(GateI instanceof NoDelayDisplay){
        GateI.FeedIn();
        GateI.CalcOut();
      }
      if(GateI instanceof Component){
        GateI.FeedIn();
      }
      if(GateI instanceof ComponentInput){
        GateI.Out[0]= Inp[((ComponentInput)GateI).Number];
      }
    }
    for( int i=0;i<Internals.size();i++){
      Gate GateI=(Gate)Internals.get(i);
      if(GateI instanceof Component){
        ((Component)GateI).FixInitial();
      } 
    }
  }
  
  void Update(){
     for(int i=0;i<Inp.length;i++){
        for(int j=0;j<Internals.size();j++){
          if(Internals.get(j) instanceof ComponentInput){
            ComponentInput Input= ((ComponentInput)Internals.get(j));
            if(Input.Number==i){
              Input.Out[0]=Inp[i]; 
            }
          }
        }
     }
    for( int i=0; i<Internals.size();i++){
      Gate GateI=(Gate)Internals.get(i);
      GateI.FeedIn();
    }
    for( int i=0; i<Internals.size();i++){
      Gate GateI=(Gate)Internals.get(i);
      GateI.CalcOut();
      GateI.Update();
    }
  }
  void Draw(PGraphics Window){
    super.Draw(Window);
    Window.stroke(255);
    Window.strokeWeight(2);
    Window.rect(Pos.x,Pos.y,Size.x,Size.y);
    Window.fill(255);
    Window.text(Name,Pos.x+10,Pos.y+20);
    for(int i=0;i<OutPos.length;i++){
      Window.rect(Pos.x+OutPos[i].x-5,Pos.y+OutPos[i].y-5,10,10);
    }
    Window.strokeWeight(2);
    Window.stroke(255);
    Window.fill(255,0,0);
    //Window.rect(Pos.x+22,Pos.y+30,Size.x-2*22,Size.y-30-20);
    
    PVector LeftCorner= new PVector(Pos.x+22,Pos.y+20);
    PVector DisplaySize= new PVector(Size.x-22-26,Size.y-20-10);
    float CenterX= LeftCorner.x+DisplaySize.x*0.5;
    float CenterY= LeftCorner.y+DisplaySize.y*0.5;
    float lentorad=0.4;
    
    float len= min(DisplaySize.x/(float(DispWidth)-1+2*lentorad),DisplaySize.y/(float(DispHeight)-1+2*lentorad));
    float rad= len*lentorad;
    for(int w=0;w<DispWidth;w++){
      for(int h=0;h<DispHeight;h++){
        for(int d=0;d<Internals.size();d++){
          if(Internals.get(d) instanceof ComponentDisplay){
            if(((ComponentDisplay)Internals.get(d)).Number== w*DispHeight+h){
              if(((ComponentDisplay)Internals.get(d)).Inp[0]){
                Window.fill(0,255,0);
              }else{
                Window.fill(255,0,0);
              }
            }
          }
        }
        
       Window.rect(CenterX-len*(DispWidth-1)*0.5+w*len-rad,CenterY-len*(DispHeight-1)*0.5+h*len-rad,2*rad,2*rad);
      }
    }
    
  }    
  void CalcOut(){
    for(int i=0;i<Out.length;i++){
        for(int j=0;j<Internals.size();j++){
          if(Internals.get(j) instanceof ComponentOutput){
            ComponentOutput Output= ((ComponentOutput)Internals.get(j));
            if(Output.Number==i){
              Out[i]=Output.Inp[0]; 
            }
          }
        }
     }
  }
  
  Editor GetEditor(){
    return new ComponentEditor(this);
  }
  
  Logic clone(){
    ArrayList<Logic> CloneInternals= CloneInternals();
    Component Clone= new Component(Pos.copy(), Name, Number, NumInps,NumOuts,DispWidth,DispHeight);
    Clone.Internals=CloneInternals;
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    Clone.InFeedIndexes=InFeedIndexes.clone();
    return Clone;
  }
  ArrayList<Logic> CloneInternals(){
    ArrayList<Logic> CloneInternals= new ArrayList<Logic>();
    for(int i=0; i<Internals.size();i++){// Clone selection
      Logic clone= Internals.get(i).clone();
      CloneInternals.add(clone);
    }
    for(int i=0; i<CloneInternals.size();i++){ // If connections to prev select, move it to connect
      Gate thisLog= (Gate) CloneInternals.get(i);
      for( int inp=0; inp< thisLog.InFeed.length;inp++){
        int index =Internals.indexOf(thisLog.InFeed[inp]);
        if(index>=0){
          thisLog.InFeed[inp]=CloneInternals.get(index);
        }
      }
    }
    return CloneInternals;
  }
  Component GetTemplate(){
    for(int i=0;i<Components.size();i++){
      if(Components.get(i).Number==Number){
          return Components.get(i);
      }
    }
    return null;
  }
  
  void FixComponent(){
    boolean fixed= false;
    for(int n=0;n<Components.size();n++){
       if(Components.get(n).Number==Number){
         Internals= Components.get(n).CloneInternals();
         Name=Components.get(n).Name;
         NumInps=Components.get(n).NumInps;
         NumOuts=Components.get(n).NumOuts;
         DispWidth=Components.get(n).DispWidth;
         DispHeight=Components.get(n).DispHeight;
         fixed=true;
       }
    }
    if(!fixed){
      for(int i=0;i<Internals.size();i++){
        if(Internals.get(i) instanceof Component){
          Component C=(Component)Internals.get(i);
          C.FixComponent();
        }
      }
    }
  }
  //ArrayList<Component> Contains(){//Array of components(Templates) contained
  //  ArrayList<Component> Contained;
    
  //}
}

class ComponentInput extends Gate{
     int Number;
      ComponentInput(PVector dPos,int dNumber){
        super(dPos,new PVector(40,40),0,1,new PVector[]{},new PVector[]{new PVector(40,20)});
        Number=dNumber;
      }
      void Draw(PGraphics Window){
        super.Draw(Window);
        if(Out[0]){
          Window.fill(40,200,40);
        }else{
          Window.fill(200,40,40); 
        }
        Window.stroke(255);
        Window.strokeWeight(2);
        Window.ellipse(Pos.x+20,Pos.y+20,40,40);
        Window.fill(0);
        Window.textSize(20);
        Window.text("I:"+Number,Pos.x+10,Pos.y+30);
      }
      void CalcOut(){
        //Out[0]=Inp[0];
      }
      void Update(){
        super.Update();
      }
      void Interact(Editor E){
        if(E instanceof ComponentEditor){
          if((!Moused(E))&&E.Ia.MouseIn(PVadd(Pos, new PVector(-5,-5)),new PVector(80,80))&&MouseClicked){
            Out[0]=!Out[0];
            print("Switch state");
          }
        }
         
      }
      Logic clone(){
        ComponentInput Clone = new ComponentInput(Pos,Number);
        Clone.Inp=Inp.clone();
        Clone.Out=Out.clone();
        Clone.InFeed=InFeed.clone();
        Clone.InFeedIndexes=InFeedIndexes.clone();
        return Clone;
      }
  }
  class ComponentOutput extends Gate{
       int Number;
        ComponentOutput(PVector dPos,int dNumber){
          super(dPos,new PVector(40,40),1,1,new PVector[]{new PVector(0,20)},new PVector[]{new PVector(40,20)});
          Number=dNumber;
        }
        void Draw(PGraphics Window){
          super.Draw(Window);
          if(Inp[0]){
            Window.fill(40,200,40);
          }else{
            Window.fill(200,40,40); 
          }
          Window.stroke(255);
          Window.strokeWeight(2);
          Window.ellipse(Pos.x+20,Pos.y+20,40,40);
          Window.fill(0);
          Window.textSize(18);
          Window.text("O:",Pos.x+6,Pos.y+30);
          if(Number<10){
            Window.textSize(18);
          }else if(Number<100){
            Window.textSize(10);
          }else{
           Window.textSize(6); 
          }
          Window.text(Number,Pos.x+26,Pos.y+30);
        }
        void CalcOut(){
          Out[0]=Inp[0];
        }
        void Update(){
          super.Update();
        }
        Logic clone(){
          ComponentOutput Clone = new ComponentOutput(Pos,Number);
          Clone.Inp=Inp.clone();
          Clone.Out=Out.clone();
          Clone.InFeed=InFeed.clone();
          Clone.InFeedIndexes=InFeedIndexes.clone();
          return Clone;
        }
  }
  class ComponentDisplay extends Gate{
       int Number;
        ComponentDisplay(PVector dPos,int dNumber){
          super(dPos,new PVector(40,40),1,1,new PVector[]{new PVector(0,20)},new PVector[]{new PVector(40,20)});
          Number=dNumber;
        }
        void Draw(PGraphics Window){
          super.Draw(Window);
          if(Inp[0]){
            Window.fill(40,200,40);
          }else{
            Window.fill(200,40,40); 
          }
          Window.stroke(255);
          Window.strokeWeight(2);
          Window.ellipse(Pos.x+20,Pos.y+20,40,40);
          Window.fill(0);
          Window.textSize(18);
          Window.text("D:",Pos.x+6,Pos.y+30);
          if(Number<10){
            Window.textSize(18);
          }else if(Number<100){
            Window.textSize(10);
          }else{
           Window.textSize(6); 
          }
          Window.text(Number,Pos.x+26,Pos.y+30);
        }
        void CalcOut(){
          Out[0]=Inp[0];
        }
        void Update(){
          super.Update();
        }
        Logic clone(){
          ComponentDisplay Clone = new ComponentDisplay(Pos,Number);
          Clone.Inp=Inp.clone();
          Clone.Out=Out.clone();
          Clone.InFeed=InFeed.clone();
          Clone.InFeedIndexes=InFeedIndexes.clone();
          return Clone;
        }
  }