//boolean Dragging=false;
//Gate CurrentDrag;

//Logic CurrentSelect;
//int CurrentSelectInp;
//boolean SelectingInp=false;
//float zoom=1;
//float MouseX;//Scaled MouseY
//float MouseY;//Scaled MouseY
//void draw(){
//  background(15,10,10); 
//  fill(0);
  
//  //println(frameCount+" "+Dragging+" "+MouseClicked);
//  for( int i=0; i<Gates.size();i++){
//    Gate GateI=(Gate)Gates.get(i);
//    GateI.FeedIn();
//  }
//  for( int i=0; i<Gates.size();i++){
//    Gate GateI=(Gate)Gates.get(i);
//    GateI.CalcOut();
//    GateI.Update();
//  }
  
//  MouseX=int(mouseX/zoom);
//  MouseY=int(mouseY/zoom);
//  scale(zoom);
//  for( int i=0; i<Gates.size();i++){
//    Gate GateI=(Gate)Gates.get(i);
//    GateI.Draw();
//    if (MouseClicked){
//      if(GateI.Moused()){
//        if(SelectingInp){
//          // Set the Input, if electing Inp
//          //Find nearest output
//          int nearestInd=0;
//          float dist=1000000;
//          for(int j=0;j<GateI.OutPos.length;j++){
//              float newdist=PVmag(new PVector(MouseX-(GateI.Pos.x+GateI.OutPos[j].x),MouseY-(GateI.Pos.y+GateI.OutPos[j].y)));
//              println("index:"+j+"  distance:"+newdist);
//              if(newdist<dist){
//                nearestInd=j;
//                dist=newdist;
//              }
//          }
//          println("Nearest index:"+nearestInd);
//          if(GateI!=CurrentSelect){
            
//            CurrentSelect.InFeed[CurrentSelectInp]=GateI;
//            CurrentSelect.InFeedIndexes[CurrentSelectInp]=nearestInd;
//          }
//        }else{
//          // Start Dragging
//          CurrentDrag=GateI;
//          Dragging=true;
//          //println("Setting Drag "+ frameCount);
//        }
//        SelectingInp=false;
//      }
//    }
//    for( int inp=0;inp<GateI.Inp.length;inp++){
//      //Check if clicking
//      PVector InpPoint=((Gate)GateI.InFeed[inp]).ScreenPointOut(GateI.InFeedIndexes[inp]);
//      PVector OutPoint=GateI.ScreenPointInp(inp);
//      PVector Tween= PVadd(OutPoint,PVscale(InpPoint,-1));
//      PVector Div= PVdivide(PVadd(new PVector(MouseX,MouseY),PVscale(InpPoint,-1)),Tween);
//      if(FLtween(1-0.2,1,Div.x)&&FLtween(-10/PVmag(Tween),10/PVmag(Tween),Div.y)){
//        if(MouseClicked){
//          //print("Selecting Inp");
//          CurrentSelect=GateI;
//          CurrentSelectInp=inp;
//          SelectingInp=true;
//        }
//        // Draw highlight
//        PVector frac=PVadd(OutPoint, PVscale(Tween,-0.2));
//        stroke(255);
//        line(OutPoint.x,OutPoint.y,frac.x,frac.y);
//      } 
//    }
//  }
//  if(Dragging){
//     CurrentDrag.Pos=new PVector(MouseX,MouseY).add(PVscale(CurrentDrag.Size,-0.5));
//     //println("Dragging "+frameCount);
//  }
//  if(wait==true&&MouseClicked){
//    wait=false;
//    Dragging=false;
//    //println("End Drag "+frameCount);
//  }
//  if(Dragging&&MouseClicked){
//    wait = true;
//  }
//  //Highlight selected
//  for( int i=0;i<Select.size();i++){
//    fill(255-100*i/Select.size());
//    Gate thisGate=((Gate)Select.get(i));
//    ellipse(thisGate.Pos.x,thisGate.Pos.y,10,10);
//  }
  
//  //S key held
//  if(keyPressed){
//    if(prevPress=='S'){
//      noFill();
//      //fill(255);
//      text("S",100,100);
      
//      rect(SelectStart.x,SelectStart.y,mouseX-SelectStart.x,mouseY-SelectStart.y);
//      for(int i=0;i<Gates.size();i++){
//        Gate GateI=((Gate)Gates.get(i));
//        PVector pos= GateI.Pos;
//        if(FLtween(SelectStart.x,MouseX,pos.x)&&FLtween(SelectStart.y,MouseY,pos.y)){
//          if(!Select.contains(GateI)){
//            Select.add(GateI);
//          }
//        }
//      }
//    }
//  }
//  text(prevPress,100,100);
  
  
  
  
  
  
  
//  if(keyPressed){
//    if(keyCode==RIGHT){
//      PVector add=new PVector(-10,0);
//      for(int i=0; i<Gates.size();i++){
//        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
//        ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
//      }
//    }
//    if(keyCode==LEFT){
//      PVector add=new PVector(10,0);
//      for(int i=0; i<Gates.size();i++){
//        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
//        ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
//      }
//    }
//    if(keyCode==UP){
//      PVector add=new PVector(0,10);
//      for(int i=0; i<Gates.size();i++){
//        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
//        ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
//      }
//    }
//    if(keyCode==DOWN){
//      PVector add=new PVector(0,-10);
//      for(int i=0; i<Gates.size();i++){
//        //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
//        ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
//      }
//    } 
//  }
//  MouseClicked=false;
//}
//void mouseClicked(){
//  MouseClicked=true;
//}
//Logic[] NearestGates(PVector Pos,ArrayList<Logic>Gates){
//  Logic[] Nearest=new Logic[]{Gates.get(0),Gates.get(1)};
//  float dist=99999999;
//  for( int i=0; i<Gates.size();i++){
//    float newDist=PVmag(PVadd(Pos,PVminus(((Gate)Gates.get(i)).Pos)));
//    println(newDist);
//    if(newDist<dist){
//      dist=newDist;
//      Nearest[1]=Nearest[0];
//      Nearest[0]=Gates.get(i);
//    }
//  }
//  return Nearest;
//}
//void keyPressed(){
//  //scale(5);
//  prevPress=key;
//  int Gl=Gates.size();
//  Logic[] NearestGate=NearestGates(new PVector(MouseX,MouseY),Gates);
//  if(key=='a'){// Make an and gate at mouse, connected to nearest
//    print("A");
//    Logic NewAnd= new AndGate(new PVector(MouseX,MouseY));
//    NewAnd.InFeed=NearestGate;
//    Gates.add(NewAnd);
//  }
//  if(key=='o'){// Make an or gate at mouse, connected to nearest
//    print("O");
//    Logic NewOr= new OrGate(new PVector(MouseX,MouseY));
//    NewOr.InFeed=NearestGate;
//    Gates.add(NewOr);
//  }
//  if(key=='n'){ // Make an not gate at mouse, connected to nearest
//    print("N");
//    Logic NewNot= new NotGate(new PVector(MouseX,MouseY));
//    NewNot.InFeed=new Logic[]{NearestGate[0]};
//    Gates.add(NewNot);
//  }
//  if(key=='b'){ // Make a button at mouse
//    print("B");
//    Logic NewBut= new Button(new PVector(MouseX,MouseY),true);
//    Gates.add(NewBut);
//  }
//  if(key=='d'){ // Make a display (buffer) gate at mouse, connected to nearest
//    print("D");
//    Logic NewDisp= new Display(new PVector(MouseX,MouseY));
//    NewDisp.InFeed=new Logic[]{NearestGate[0]};
//    Gates.add(NewDisp);
//  }
//  if(key=='f'){ // Make a no delay display gate at mouse, connected to nearest
//    print("F");
//    Logic NewDisp= new NoDelayDisplay(new PVector(MouseX,MouseY));
//    NewDisp.InFeed=new Logic[]{NearestGate[0]};
//    Gates.add(NewDisp);
//  }
//  if(key=='i'){// Make an Integrated comoponent
//    Logic NewComp= new Component(new PVector(MouseX,MouseY),"Component",1,2,2);
//    NewComp.InFeed=new Logic[]{NearestGate[0],NearestGate[1]};
//    Gates.add(NewComp);
//  }
//  if(key=='x'){ // Delete hovered object
//    for( int i=0; i<Gates.size();i++){
//      Gate GateI=(Gate)Gates.get(i);
//      if(GateI.Moused()){
//        Gates.remove(i);
//        Select.remove(GateI);
//      }
//    }
//  }
//  if(key=='X'){ // Delete selected objects
//    for( int i=0; i<Select.size();i++){  
//      Gates.remove(Select.get(i));
//    }
//    Select=new ArrayList<Logic>();
//  }
//  if(key=='t'){ // translate all
//    PVector add=new PVector(MouseX-((Gate)Gates.get(0)).Pos.x,MouseY-((Gate)Gates.get(0)).Pos.y);
//    for(int i=0; i<Gates.size();i++){
//      //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
//      ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
//    }
//  }
//  if(key=='T'){ // translate selected
//    PVector add=new PVector(MouseX-((Gate)Select.get(0)).Pos.x,MouseY-((Gate)Select.get(0)).Pos.y);
//    for(int i=0; i<Select.size();i++){
//      //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
//      ((Gate)Select.get(i)).Pos=PVadd( ((Gate)Select.get(i)).Pos, add);
//    }
//  }
//  if(key=='m'){// Move things around
//    PVector add=PVscale(new PVector(MouseX-width*0.5,MouseY-height*0.5),0.2);
//    for(int i=0; i<Gates.size();i++){
//      //PVector add=new PVector(0.2*MouseX-100,0.2*MouseY-100);
//      ((Gate)Gates.get(i)).Pos=PVadd( ((Gate)Gates.get(i)).Pos, add);
//    }
//  }

  
//  if(key=='s'){// Select gates
//    for( int i=0; i<Gates.size();i++){
//      Gate GateI=(Gate)Gates.get(i);
//      if(GateI.Moused()){
//        if(!Select.contains(GateI)){
//          Select.add(GateI);
//        }else{
//          Select.remove(GateI);
//        }
//      }
//    }
//  }
//  if(key=='S'){// Select gates
//    SelectStart=new PVector(MouseX,MouseY);
//  }
//  if(key=='e'){ // clear selection
//    Select=new ArrayList<Logic>();
//  }
//  if(key=='c'){ // clone selection
//    ArrayList<Logic> newSelect= new ArrayList<Logic>();
//    for(int i=0; i<Select.size();i++){// Clone selection
//      Logic clone= Select.get(i).clone();
//      ((Gate)clone).Pos=PVadd(((Gate)clone).Pos,new PVector(30,30));
//      newSelect.add(clone);
//    }
//    for(int i=0; i<newSelect.size();i++){ // If connections to prev select, move it to connect
//      Gate thisLog= (Gate) newSelect.get(i);
//      for( int inp=0; inp< thisLog.InFeed.length;inp++){
//        int index =Select.indexOf(thisLog.InFeed[inp]);
//        if(index>=0){
//          thisLog.InFeed[inp]=newSelect.get(index);
//        }
//      }
//    }
//    Select=newSelect;
//    Gates.addAll(newSelect);
//  }
//  if(key=='k'){ // Save
//    SavePref();
//  }
//  if(key=='l'){ // Load
//    LoadPref();
//  }
//   if(key=='q'){ // Zoom In
//    zoom*=0.9;
//  }
//  if(key=='w'){ // Zoom Out
//    zoom/=0.9;
//  }
//}