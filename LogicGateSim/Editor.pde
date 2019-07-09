void SavePref(ArrayList<Logic> Gates,String prefFileName){
      //Store current shit
    String[] preferencesFileContent = {"Preferences: Row 1- Logic type, Row 2- Position, Row 3-Connection number, row 4- States"};//Make contenfile and add headder text
    String LogicType="";
    for( int g=0; g<Gates.size();g++){
      if(Gates.get(g) instanceof Button){
        LogicType+="Button";
      }else if(Gates.get(g) instanceof Display){
        LogicType+="Display";
      }else if(Gates.get(g) instanceof NoDelayDisplay){
        LogicType+="NoDelayDisplay";
      }else if(Gates.get(g) instanceof OrGate){
        LogicType+="OrGate";
      }else if(Gates.get(g) instanceof AndGate){
        LogicType+="AndGate";
      }else if(Gates.get(g) instanceof NotGate){
        LogicType+="NotGate";
      }else{
         print("ERROR UNKNOWN GATE");
         return;
      }
      if(g<Gates.size()-1){
       LogicType+=":"; 
      }
    }
    preferencesFileContent=append(preferencesFileContent,LogicType);
    String LogicPosition="";
    for( int g=0; g<Gates.size();g++){
      LogicPosition+=((Gate)Gates.get(g)).Pos.x+","+((Gate)Gates.get(g)).Pos.y;
      if(g<Gates.size()-1){
       LogicPosition+=":"; 
      }
    }
    preferencesFileContent=append(preferencesFileContent,LogicPosition);
    String LogicConnect="";
    for( int g=0; g<Gates.size();g++){
      Gate ThisGate=(Gate)Gates.get(g);
      for( int i=0; i<ThisGate.InFeed.length; i++){
        LogicConnect+=Gates.indexOf(ThisGate.InFeed[i]);
        if(i<ThisGate.InFeed.length-1){
         LogicConnect+=","; 
        }
      }
      if(g<Gates.size()-1){
       LogicConnect+=":"; 
      }
    }
    preferencesFileContent=append(preferencesFileContent,LogicConnect);
    String LogicState="";
    for( int g=0; g<Gates.size();g++){
      Gate ThisGate=(Gate)Gates.get(g);
      if(ThisGate.Out[0]){
        LogicState+="T"; 
      }else{
        LogicState+="F"; 
      }
      if(g<Gates.size()-1){
       LogicState+=":"; 
      }
    }
    preferencesFileContent=append(preferencesFileContent,LogicState);
    saveStrings(prefFileName, preferencesFileContent);                        //Save contenfile to disk;
}
ArrayList<Logic> LoadPref(String prefFileName){
  ArrayList<Logic>Gates=new ArrayList<Logic>();
  String[] Lines= loadStrings(prefFileName);    
    String[] LogicTypes= split(Lines[1],":");
    String[] LogicPos= split(Lines[2],":");
    String[] LogicConnect= split(Lines[3],":");
    String[] LogicState= split(Lines[4],":");
    printArray(LogicTypes);
    printArray(LogicPos);
    printArray(LogicConnect);
    for(int i=0; i<LogicTypes.length;i++){
      String[] PosString=split(LogicPos[i],",");
      PVector Pos=new PVector(float(PosString[0]),float(PosString[1]));
      println(LogicTypes[i]);
      //println(Pos.x+" ,"+Pos.y);
      if(LogicTypes[i].equals("Button")){
        Gates.add(new Button(Pos,LogicState[i].equals("T")));
        print("- Make button");
      }else if(LogicTypes[i].equals("Display")){
        Gates.add(new Display(Pos));
        print("- Make Display");
      }else if(LogicTypes[i].equals("NoDelayDisplay")){
        Gates.add(new NoDelayDisplay(Pos));
        print("- Make Display");
      }else if(LogicTypes[i].equals("OrGate")){
        Gates.add(new OrGate(Pos));
        print("= Make OrGate");
      }else if(LogicTypes[i].equals("AndGate")){
        Gates.add(new AndGate(Pos));
        print("- Make AndGate");
      }else if(LogicTypes[i].equals("NotGate")){
        Gates.add(new NotGate(Pos));
        print("- Make NorGate");
      }else{
         print("ERROR UNKNOWN GATE");
         return null;
      }
    }
    for(int i=0; i<LogicTypes.length;i++){
      Gate ThisGate= (Gate) Gates.get(i);
      String[] Connect= split(LogicConnect[i],",");
      println(Connect.length);
      for(int j=0; j<Connect.length; j++){
        if(!Connect[j].equals("")){
          ThisGate.InFeed[j]=Gates.get(int(Connect[j]));
        }
      }
    }
    for(int i=0; i<LogicTypes.length;i++){
      Gate ThisGate= (Gate) Gates.get(i);
      if(ThisGate.Out.length>0){
        ThisGate.Out[0]=LogicState[i].equals("T");
      }
    }
    return Gates;
}

class Editor{ 
  ArrayList<Logic>Gates=new ArrayList<Logic>();
  ArrayList<Logic> Select=new ArrayList<Logic>();
  
  class Interactables{
    boolean Dragging=false;
    Gate CurrentDrag;
    
    PVector SelectStart;
    PVector SelectEnd;
    
    Logic CurrentSelect;
    int CurrentSelectInp;
    boolean SelectingInp=false;
    float zoom=1;
    float MouseX;//Scaled MouseY
    float MouseY;//Scaled MouseY
    PVector PVMouse;
    
    Interactables(){
    }
    
    boolean MouseIn(float x,float y,float Width,float Height){
      return (MouseX>x)&&(MouseX<x+Width)&&(MouseY>y)&&(MouseY<y+Height);
    }
    boolean MouseIn(PVector Pos, PVector Size){
      return MouseIn(Pos.x,Pos.y,Size.x,Size.y);
    }
  }
  Interactables Ia= new Interactables();
  
  Editor(ArrayList<Logic>dGates){
     Gates=dGates;
  }
  void Update(float MouseX,float MouseY){
    Ia.MouseX=int(MouseX/Ia.zoom);
    Ia.MouseY=int(MouseY/Ia.zoom);
    Ia.PVMouse=new PVector(Ia.MouseX,Ia.MouseY);//Ia.PVMouse;
    for( int i=0; i<Gates.size();i++){
      Gate GateI=(Gate)Gates.get(i);
      GateI.FeedIn();
    }
    for( int i=0; i<Gates.size();i++){
      Gate GateI=(Gate)Gates.get(i);
      GateI.CalcOut();
      GateI.Update();
    }

  }
  void Draw(PGraphics Window){
    Window.background(15,10,10); 
    for( int i=0; i<Gates.size();i++){
      Gate GateI=(Gate)Gates.get(i);
      GateI.Draw(Window);
      for( int inp=0;inp<GateI.Inp.length;inp++){
        PVector InpPoint=((Gate)GateI.InFeed[inp]).ScreenPointOut(GateI.InFeedIndexes[inp]);
        PVector OutPoint=GateI.ScreenPointInp(inp);
        PVector Tween= PVadd(OutPoint,PVscale(InpPoint,-1));
        PVector Div= PVdivide(PVadd(Ia.PVMouse,PVscale(InpPoint,-1)),Tween);
        if(FLtween(1-0.2,1,Div.x)&&FLtween(-10/PVmag(Tween),10/PVmag(Tween),Div.y)){
          PVector frac=PVadd(OutPoint, PVscale(Tween,-0.2));
          Window.stroke(255);
          Window.line(OutPoint.x,OutPoint.y,frac.x,frac.y);
        }
      }
    }
    for( int i=0;i<Select.size();i++){
      Window.fill(255-100*i/Select.size());
      Gate thisGate=((Gate)Select.get(i));
      Window.ellipse(thisGate.Pos.x,thisGate.Pos.y,10,10);
    }
    if(keyPressed){
      if(prevPress=='S'){
          Window.noFill();
          //fill(255);
          Window.text("S",100,100);
          Window.rect(Ia.SelectStart.x,Ia.SelectStart.y,Ia.MouseX-Ia.SelectStart.x,Ia.MouseY-Ia.SelectStart.y);
          for(int i=0;i<Gates.size();i++){
            Gate GateI=((Gate)Gates.get(i));
            PVector pos= GateI.Pos;
            if(FLtween(Ia.SelectStart.x,Ia.MouseX,pos.x)&&FLtween(Ia.SelectStart.y,Ia.MouseY,pos.y)){
              if(!Select.contains(GateI)){
                Select.add(GateI);
              }
            }
          }
        }else{
          Ia.SelectStart=Ia.PVMouse;
        }
    }
  }
  void Interact(Boolean MouseClicked){
    for( int i=0; i<Gates.size();i++){
      Gate GateI=(Gate)Gates.get(i);
      GateI.Interact(this);
      if (MouseClicked){
        if(GateI.Moused(this)){
          if(Ia.SelectingInp){
            // Set the Input, if electing Inp
            //Find nearest output
            int nearestInd=0;
            float dist=1000000;
            for(int j=0;j<GateI.OutPos.length;j++){
                float newdist=PVmag(new PVector(Ia.MouseX-(GateI.Pos.x+GateI.OutPos[j].x),Ia.MouseY-(GateI.Pos.y+GateI.OutPos[j].y)));
                println("index:"+j+"  distance:"+newdist);
                if(newdist<dist){
                  nearestInd=j;
                  dist=newdist;
                }
            }
            println("Nearest index:"+nearestInd);
            if(GateI!=Ia.CurrentSelect){
              
              Ia.CurrentSelect.InFeed[Ia.CurrentSelectInp]=GateI;
              Ia.CurrentSelect.InFeedIndexes[Ia.CurrentSelectInp]=nearestInd;
            }
          }else{
            // Start Dragging
            Ia.CurrentDrag=GateI;
            Ia.Dragging=true;
            //println("Setting Drag "+ frameCount);
          }
          Ia.SelectingInp=false;
        }
      }
      for( int inp=0;inp<GateI.Inp.length;inp++){
        //Check if clicking
        PVector InpPoint=((Gate)GateI.InFeed[inp]).ScreenPointOut(GateI.InFeedIndexes[inp]);
        PVector OutPoint=GateI.ScreenPointInp(inp);
        PVector Tween= PVadd(OutPoint,PVscale(InpPoint,-1));
        PVector Div= PVdivide(PVadd(Ia.PVMouse,PVscale(InpPoint,-1)),Tween);
        if(FLtween(1-0.2,1,Div.x)&&FLtween(-10/PVmag(Tween),10/PVmag(Tween),Div.y)){
          if(MouseClicked){
            //print("Selecting Inp");
            Ia.CurrentSelect=GateI;
            Ia.CurrentSelectInp=inp;
            Ia.SelectingInp=true;
          }
        } 
      }
    }
    if(Ia.Dragging){
       Ia.CurrentDrag.Pos=Ia.PVMouse.add(PVscale(Ia.CurrentDrag.Size,-0.5));
       //println("Dragging "+frameCount);
    }
    if(wait==true&&MouseClicked){
      wait=false;
      Ia.Dragging=false;
      //println("End Drag "+frameCount);
    }
    if(Ia.Dragging&&MouseClicked){
      wait = true;
    }
  }
  void KeyHeldInteract(int prevPress,int KeyCode){
    if(KeyCode==RIGHT){
      PVector add=new PVector(-10,0);
      for(int i=0; i<Gates.size();i++){
        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
        ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
      }
    }
    if(KeyCode==LEFT){
      PVector add=new PVector(10,0);
      for(int i=0; i<Gates.size();i++){
        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
        ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
      }
    }
    if(KeyCode==UP){
      PVector add=new PVector(0,10);
      for(int i=0; i<Gates.size();i++){
        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
        ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
      }
    }
    if(KeyCode==DOWN){
      PVector add=new PVector(0,-10);
      for(int i=0; i<Gates.size();i++){
        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
        ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
      }
    } 
  }
  
  ArrayList<Logic> NearestGates(PVector Pos,ArrayList<Logic>Gates,int NumGates){
    ArrayList<Logic> Nearest=new ArrayList<Logic>();
    for( int i=0; i<Gates.size();i++){
      float newDist=PVmag(PVadd(Pos,PVminus(((Gate)Gates.get(i)).Pos)));
      float thisDist=999999999;
      int index=0;
      while(index<Nearest.size()){
        thisDist=PVmag(PVadd(Pos,PVminus(((Gate)Nearest.get(index)).Pos)));
        if(thisDist>newDist){
          break; 
        }
        index++;
      }
      
      if(index!=NumGates){
         Nearest.add(index,Gates.get(i)); 
      }
      if(Nearest.size()>NumGates){
         Nearest.remove(NumGates); 
      }
    }
    return Nearest;
  }
  void KeyPressInteract(int Key){
    int Gl=Gates.size();
    ArrayList<Logic> NearestGates=NearestGates(Ia.PVMouse,Gates,2);
    Logic[] NearestGate= new Logic[]{NearestGates.get(0),NearestGates.get(1)};
    if(Key=='a'){// Make an and gate at mouse, connected to nearest
      print("A");
      Logic NewAnd= new AndGate(Ia.PVMouse);
      NewAnd.InFeed=NearestGate;
      Gates.add(NewAnd);
    }
    if(Key=='o'){// Make an or gate at mouse, connected to nearest
      print("O");
      Logic NewOr= new OrGate(Ia.PVMouse);
      NewOr.InFeed=NearestGate;
      Gates.add(NewOr);
    }
    if(Key=='n'){ // Make an not gate at mouse, connected to nearest
      print("N");
      Logic NewNot= new NotGate(Ia.PVMouse);
      NewNot.InFeed=new Logic[]{NearestGate[0]};
      Gates.add(NewNot);
    }
    if(Key=='b'){ // Make a button at mouse
      print("B");
      Logic NewBut= new Button(Ia.PVMouse,true);
      Gates.add(NewBut);
    }
    if(Key=='d'){ // Make a display (buffer) gate at mouse, connected to nearest
      print("D");
      Logic NewDisp= new Display(Ia.PVMouse);
      NewDisp.InFeed=new Logic[]{NearestGate[0]};
      Gates.add(NewDisp);
    }
    if(Key=='f'){ // Make a no delay display gate at mouse, connected to nearest
      print("F");
      Logic NewDisp= new NoDelayDisplay(Ia.PVMouse);
      NewDisp.InFeed=new Logic[]{NearestGate[0]};
      Gates.add(NewDisp);
    }
    if(Key=='i'){// Make an Integrated comoponent
     Windows.add(new NewIntegratedWindow(new PVector(300,300),this,Ia.PVMouse));
      //Logic NewComp= new Component(Ia.PVMouse,"Component",1,2,2);
      //NewComp.InFeed=new Logic[]{NearestGate[0],NearestGate[1]};
      //Gates.add(NewComp);
    }
    
    if(Key=='y'){
       Logic NewTest= new ComponentInput(Ia.PVMouse,1);
      NewTest.InFeed=new Logic[]{NearestGate[0],NearestGate[1]};
      Gates.add(NewTest);
    }
    if(Key=='u'){// Open IC editor
      for( int i=0; i<Gates.size();i++){
        Gate GateI=(Gate)Gates.get(i);
        if(GateI.Moused(this)){
          if(GateI instanceof Component){
            Windows.add(new EditorWindow(new PVector(200,200),new PVector(800,400),((Component) GateI).Name,((Component) GateI).GetEditor()));
          }
        }
      }
      
    }
    if(Key=='x'){ // Delete hovered object
      for( int i=0; i<Gates.size();i++){
        Gate GateI=(Gate)Gates.get(i);
        if(GateI.Moused(this)){
          Gates.remove(i);
          Select.remove(GateI);
        }
      }
    }
    if(Key=='X'){ // Delete selected objects
      for( int i=0; i<Select.size();i++){  
        Gates.remove(Select.get(i));
      }
      Select=new ArrayList<Logic>();
    }
    if(Key=='t'){ // translate all
      PVector add=new PVector(Ia.MouseX-((Gate)Gates.get(0)).Pos.x,Ia.MouseY-((Gate)Gates.get(0)).Pos.y);
      for(int i=0; i<Gates.size();i++){
        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
        ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
      }
    }
    if(Key=='T'){ // translate selected
      PVector add=new PVector(Ia.MouseX-((Gate)Select.get(0)).Pos.x,Ia.MouseY-((Gate)Select.get(0)).Pos.y);
      for(int i=0; i<Select.size();i++){
        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
        ((Gate)Select.get(i)).Pos=PVadd( ((Gate)Select.get(i)).Pos, add);
      }
    }
    if(Key=='m'){// Move things around
      PVector add=PVscale(new PVector(Ia.MouseX-width*0.5,Ia.MouseY-height*0.5),0.2);
      for(int i=0; i<Gates.size();i++){
        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
        ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
      }
    }
    if(Key=='s'){// Select gates
      for( int i=0; i<Gates.size();i++){
        Gate GateI=(Gate)Gates.get(i);
        if(GateI.Moused(this)){
          if(!Select.contains(GateI)){
            Select.add(GateI);
          }else{
            Select.remove(GateI);
          }
        }
      }
    }
    if(Key=='S'){// Select gates
      Ia.SelectStart=Ia.PVMouse;
    }
    if(Key=='e'){ // clear selection
      Select=new ArrayList<Logic>();
    }
    if(Key=='c'){ // clone selection
      ArrayList<Logic> newSelect= new ArrayList<Logic>();
      for(int i=0; i<Select.size();i++){// Clone selection
        Logic clone= Select.get(i).clone();
        ((Gate)clone).Pos=PVadd(((Gate)clone).Pos,new PVector(30,30));
        newSelect.add(clone);
      }
      for(int i=0; i<newSelect.size();i++){ // If connections to prev select, move it to connect
        Gate thisLog= (Gate) newSelect.get(i);
        for( int inp=0; inp< thisLog.InFeed.length;inp++){
          int index =Select.indexOf(thisLog.InFeed[inp]);
          if(index>=0){
            thisLog.InFeed[inp]=newSelect.get(index);
          }
        }
      }
      Select=newSelect;
      Gates.addAll(newSelect);
    }
    if(Key=='k'){ // Save
      SavePref(Gates,"Preferences1.txt");
    }
    if(Key=='l'){ // Load
      Gates= LoadPref("Preferences1.txt");
    }
     if(Key=='q'){ // Zoom In
      Ia.zoom*=0.9;
    }
    if(Key=='w'){ // Zoom Out
      Ia.zoom/=0.9;
    }
    
  }
}