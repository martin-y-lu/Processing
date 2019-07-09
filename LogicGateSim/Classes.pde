class Logic{
  boolean[] Inp;
  boolean[] Out;
  Logic[] InFeed;
  int[] InFeedIndexes;
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
      Inp[i]=InFeed[i].Out[InFeedIndexes[i]];//ASSUME THERE IS ONE OUTPUT ALWAYS
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
      return ((NoDelayDisplay)InFeed[0]).GetState();
    }
    return Inp[0];
  }
  void CalcOut(){
    Out[0]=GetState();
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
  
  Component(PVector dPos,String dName,int dNumber,int dNumInps,int dNumOuts){
    super(dPos,new PVector(100,100),dNumInps,dNumOuts,new PVector[dNumInps],new PVector[dNumOuts]);
      NumInps=dNumInps;
      NumOuts=dNumOuts;
    
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
    return new Editor(Internals);
  }
  
  Logic clone(){
    ArrayList<Logic> CloneInternals= CloneInternals();
    for(int i=0; i<CloneInternals.size();i++){ // If connections to prev select, move it to connect
      Gate thisLog= (Gate) CloneInternals.get(i);
      for( int inp=0; inp< thisLog.InFeed.length;inp++){
        int index =Internals.indexOf(thisLog.InFeed[inp]);
        if(index>=0){
          thisLog.InFeed[inp]=CloneInternals.get(index);
        }
      }
    }
    Component Clone= new Component(Pos.copy(), Name, Number, NumInps,NumOuts);
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
          Window.text("O:"+Number,Pos.x+8,Pos.y+30);
        }
        void CalcOut(){
          //Out[0]=Inp[0];
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