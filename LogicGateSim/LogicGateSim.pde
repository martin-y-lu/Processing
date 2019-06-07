/**
Logic gate simulation
By Martin Lu

Simulates logic gates, And, Or and Not, with two interacting gates, Button and Display.

Controlls-
  Click on a gate to move it, Click again to let go.
  Click on the connections entering a gate to change where its coming from (Click on another gate)
  
  Using keyboard gives you more functionality
  a, makes And Gate at mouse
  o, makes Or Gate at mouse
  n, makes Not Gate at mouse
  b, makes button at mouse
  d, makes display at mouse
  x, deletes gate at mouse
  t, teleport to origin
  m, move view around by mouse position
  q, Zoom in
  w, Zoom out
  
  Objects can be selected for editing., Selected objects have a red circle on them.
  s, add gate at mouse to selection
  S, create selection rectangle
  X, delete selected objects.
  T, translates selected to mouse position.
  c, clones selection.
  e, clears selection.
  
  k, Save to file (Will be opened when run again)
  l, Load from file.
**/

boolean MouseClicked=false;
PShape Or;
PShape And;
PShape Not;
ArrayList<Logic> Gates=new ArrayList<Logic>();
ArrayList<Logic> Select=new ArrayList<Logic>();
boolean wait=false;
char prevPress;
PVector SelectStart;
PVector SelectEnd;

String prefFileName = "Preferences.txt";

void SavePref(){
      //Store current shit
    String[] preferencesFileContent = {"Preferences: Row 1- Logic type, Row 2- Position, Row 3-Connection number, row 4- States"};//Make contenfile and add headder text
    String LogicType="";
    for( int g=0; g<Gates.size();g++){
      if(Gates.get(g) instanceof Button){
        LogicType+="Button";
      }else if(Gates.get(g) instanceof Display){
        LogicType+="Display";
      }else if(Gates.get(g) instanceof OrGate){
        LogicType+="OrGate";
      }else if(Gates.get(g) instanceof AndGate){
        LogicType+="AndGate";
      }else if(Gates.get(g) instanceof NotGate){
        LogicType+="NotGate";
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
void LoadPref(){
  Gates=new ArrayList<Logic>();
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
      }else if(LogicTypes[i].equals("OrGate")){
        Gates.add(new OrGate(Pos));
        print("= Make OrGate");
      }else if(LogicTypes[i].equals("AndGate")){
        Gates.add(new AndGate(Pos));
        print("- Make AndGate");
      }else if(LogicTypes[i].equals("NotGate")){
        Gates.add(new NotGate(Pos));
        print("- Make NorGate");
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
}
void setup(){          
    frameRate(60);
    fullScreen(P2D);
    //size(640, 360);
    
    //Define shapes
    Or=createShape();
    Or.beginShape();
    Or.fill(102);
    Or.stroke(255);
    Or.strokeWeight(2);
    // Here, we are hardcoding a series of vertices
    Or.vertex(0,0);
    Or.vertex(30,0);
    Or.vertex(45,5);
    Or.vertex(60,20);
    Or.vertex(45,40-5);
    Or.vertex(30,40);
    Or.vertex(0,40);
    Or.vertex(15,20);
    Or.endShape(CLOSE);
    
    And=createShape();
    And.beginShape();
    And.fill(102);
    And.stroke(255);
    And.strokeWeight(2);
    // Here, we are hardcoding a series of vertices
    And.vertex(5,0);
    And.vertex(30,0);
    And.vertex(47,5);
    And.vertex(60,20);
    And.vertex(47,40-5);
    And.vertex(30,40);
    And.vertex(5,40);
    And.endShape(CLOSE);
    
    Not=createShape();
    Not.beginShape();
    Not.fill(102);
    Not.stroke(255);
    Not.strokeWeight(2);
    Not.vertex(0,0);
    //Not.vertex(30,15);
    for(float ang=0.2;ang<PI*2-0.2;ang+=0.3){
      Not.vertex(30+3-cos(ang)*5,15-sin(ang)*5);
    }
    Not.vertex(0,30);
    Not.endShape(CLOSE);
    
    
    //Gates.add(new Button(new PVector(50,100),true));
    //Gates.add(new Button(new PVector(50,200),true));
    //Gates.add(new OrGate(new PVector(200,100)));
    //Gates.add(new AndGate(new PVector(200,200)));
    //Gates.add(new NotGate(new PVector(300,200)));
    //Gates.add(new Display(new PVector(400,200)));
    //Gates.add(new Display(new PVector(300,100)));
    //Gates.get(2).InFeed=new Logic[]{Gates.get(0),Gates.get(1)};
    //Gates.get(3).InFeed=new Logic[]{Gates.get(0),Gates.get(1)};
    //Gates.get(4).InFeed=new Logic[]{Gates.get(3)};
    //Gates.get(5).InFeed=new Logic[]{Gates.get(4)};
    //Gates.get(6).InFeed=new Logic[]{Gates.get(2)};
    
    
    //Gates.add(new Button(new PVector(0,100),true));
    //Gates.add(new Button(new PVector(50,100),true));
    //Gates.add(new OrGate(new PVector(100,100)));
    //Gates.add(new Display(new PVector(450,100)));
    //Gates.get(2).InFeed=new Logic[]{Gates.get(0),Gates.get(1)};
    //Gates.get(3).InFeed=new Logic[]{Gates.get(2)};
    LoadPref();
    
}
boolean Dragging=false;
Gate CurrentDrag;

Logic CurrentSelect;
int CurrentSelectInp;
boolean SelectingInp=false;
float zoom=1;
float MouseX;//Scaled MouseY
float MouseY;//Scaled MouseY
void draw(){
  background(15,10,10); 
  fill(0);
  MouseX=int(mouseX/zoom);
  MouseY=int(mouseY/zoom);
  //println(frameCount+" "+Dragging+" "+MouseClicked);
  for( int i=0; i<Gates.size();i++){
    Gate GateI=(Gate)Gates.get(i);
    GateI.FeedIn();
  }
  for( int i=0; i<Gates.size();i++){
    Gate GateI=(Gate)Gates.get(i);
    GateI.CalcOut();
    GateI.Update();
  }
  scale(zoom);
  for( int i=0; i<Gates.size();i++){
    Gate GateI=(Gate)Gates.get(i);
    GateI.Draw();
    if (MouseClicked){
      if(GateI.Moused()){
        if(SelectingInp){
          // Set the Input, if electing Inp
          if(GateI!=CurrentSelect){
            
            CurrentSelect.InFeed[CurrentSelectInp]=GateI;
          }
        }else{
          // Start Dragging
          CurrentDrag=GateI;
          Dragging=true;
          //println("Setting Drag "+ frameCount);
        }
        SelectingInp=false;
      }
    }
    for( int inp=0;inp<GateI.Inp.length;inp++){
      //Check if clicking
      PVector InpPoint=((Gate)GateI.InFeed[inp]).ScreenPointOut(0);
      PVector OutPoint=GateI.ScreenPointInp(inp);
      PVector Tween= PVadd(OutPoint,PVscale(InpPoint,-1));
      PVector Div= PVdivide(PVadd(new PVector(MouseX,MouseY),PVscale(InpPoint,-1)),Tween);
      if(FLtween(1-0.2,1,Div.x)&&FLtween(-10/PVmag(Tween),10/PVmag(Tween),Div.y)){
        if(MouseClicked){
          //print("Selecting Inp");
          CurrentSelect=GateI;
          CurrentSelectInp=inp;
          SelectingInp=true;
        }
        // Draw highlight
        PVector frac=PVadd(OutPoint, PVscale(Tween,-0.2));
        stroke(255);
        line(OutPoint.x,OutPoint.y,frac.x,frac.y);
      } 
    }
  }
  if(Dragging){
     CurrentDrag.Pos=new PVector(MouseX,MouseY).add(PVscale(CurrentDrag.Size,-0.5));
     //println("Dragging "+frameCount);
  }
  if(wait==true&&MouseClicked){
    wait=false;
    Dragging=false;
    //println("End Drag "+frameCount);
  }
  if(Dragging&&MouseClicked){
    wait = true;
  }
  //Highlight selected
  for( int i=0;i<Select.size();i++){
    fill(255-100*i/Select.size());
    Gate thisGate=((Gate)Select.get(i));
    ellipse(thisGate.Pos.x,thisGate.Pos.y,10,10);
  }
  
  //S key held
  if(keyPressed){
    if(prevPress=='S'){
      //fill(255);
      //text("S",100,100);
      rect(SelectStart.x,SelectStart.y,mouseX-SelectStart.x,mouseY-SelectStart.y);
    }
  }
  text(prevPress,100,100);
  MouseClicked=false;
}
void mouseClicked(){
  MouseClicked=true;
}
Logic[] NearestGates(PVector Pos){
  Logic[] Nearest=new Logic[]{Gates.get(0),Gates.get(1)};
  float dist=99999999;
  for( int i=0; i<Gates.size();i++){
    float newDist=PVmag(PVadd(Pos,PVminus(((Gate)Gates.get(i)).Pos)));
    println(newDist);
    if(newDist<dist){
      dist=newDist;
      Nearest[1]=Nearest[0];
      Nearest[0]=Gates.get(i);
    }
  }
  return Nearest;
}
void keyPressed(){
  //scale(5);
  prevPress=key;
  int Gl=Gates.size();
  Logic[] NearestGate=NearestGates(new PVector(MouseX,MouseY));
  if(key=='a'){// Make an and gate at mouse, connected to nearest
    print("A");
    Logic NewAnd= new AndGate(new PVector(MouseX,MouseY));
    NewAnd.InFeed=NearestGate;
    Gates.add(NewAnd);
  }
  if(key=='o'){// Make an or gate at mouse, connected to nearest
    print("O");
    Logic NewOr= new OrGate(new PVector(MouseX,MouseY));
    NewOr.InFeed=NearestGate;
    Gates.add(NewOr);
  }
  if(key=='n'){ // Make an not gate at mouse, connected to nearest
    print("N");
    Logic NewNot= new NotGate(new PVector(MouseX,MouseY));
    NewNot.InFeed=new Logic[]{NearestGate[0]};
    Gates.add(NewNot);
  }
  if(key=='b'){ // Make a button at mouse
    print("B");
    Logic NewBut= new Button(new PVector(MouseX,MouseY),true);
    Gates.add(NewBut);
  }
  if(key=='d'){ // Make a display (buffer) gate at mouse, connected to nearest
    print("D");
    Logic NewDisp= new Display(new PVector(MouseX,MouseY));
    NewDisp.InFeed=new Logic[]{NearestGate[0]};
    Gates.add(NewDisp);
  }
  if(key=='x'){ // Delete hovered object
    for( int i=0; i<Gates.size();i++){
      Gate GateI=(Gate)Gates.get(i);
      if(GateI.Moused()){
        Gates.remove(i);
        Select.remove(GateI);
      }
    }
  }
  if(key=='X'){ // Delete selected objects
    for( int i=0; i<Select.size();i++){  
      Gates.remove(Select.get(i));
    }
    Select=new ArrayList<Logic>();
  }
  if(key=='t'){ // translate all
    PVector add=new PVector(MouseX-((Gate)Gates.get(0)).Pos.x,MouseY-((Gate)Gates.get(0)).Pos.y);
    for(int i=0; i<Gates.size();i++){
      //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
      ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
    }
  }
  if(key=='T'){ // translate selected
    PVector add=new PVector(MouseX-((Gate)Select.get(0)).Pos.x,MouseY-((Gate)Select.get(0)).Pos.y);
    for(int i=0; i<Select.size();i++){
      //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
      ((Gate)Select.get(i)).Pos=PVadd( ((Gate)Select.get(i)).Pos, add);
    }
  }
  if(key=='m'){// Move things around
    PVector add=PVscale(new PVector(MouseX-width*0.5,MouseY-height*0.5),0.2);
    for(int i=0; i<Gates.size();i++){
      //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
      ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
    }
  }
  if(key=='s'){// Select gates
    for( int i=0; i<Gates.size();i++){
      Gate GateI=(Gate)Gates.get(i);
      if(GateI.Moused()){
        if(!Select.contains(GateI)){
          Select.add(GateI);
        }else{
          Select.remove(GateI);
        }
      }
    }
  }
  if(key=='S'){// Select gates
    SelectStart=new PVector(mouseX,mouseY);
  }
  if(key=='e'){ // clear selection
    Select=new ArrayList<Logic>();
  }
  if(key=='c'){ // clone selection
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
  if(key=='k'){ // Save
    SavePref();
  }
  if(key=='l'){ // Load
    LoadPref();
  }
   if(key=='q'){ // Zoom In
    zoom*=0.9;
  }
  if(key=='w'){ // Zoom Out
    zoom/=0.9;
  }
}