/**
Logic gate simulation
By Martin Lu

Simulates logic gates, And, Or and Not, with two interacting gates, Button and Display.

Controls-
  Click on a gate to move it, Click again to let go.
  Click on the connections entering a gate to change where its coming from (Click on another gate)
  
  Using keyboard gives you more functionality
  a, makes And Gate at mouse
  o, makes Or Gate at mouse
  n, makes Not Gate at mouse
  b, makes button at mouse
  d, makes display at mouse
  f, makes 0 delay display at mouse
  x, deletes gate at mouse
  t, teleport to origin
  m, move view around by mouse position
  q, Zoom in
  w, Zoom out
  Arrow keys, move around
  
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
boolean KeyPressed=false;
PShape Or;
PShape And;
PShape Not;
ArrayList<Logic> dGates=new ArrayList<Logic>();
boolean wait=false;
char prevPress;


//String prefFileName = "Preferences1.txt";



//PGraphics Window; 
ArrayList<Window> Windows=new ArrayList<Window>();
void SetActiveWindow(){
  for(int i=0;i<Windows.size();i++){
      Windows.get(i).Active=false;
  } //<>//
  for(int i=Windows.size()-1;i>=0;i--){
    if(Windows.get(i).MouseIn()){
       Windows.get(i).Active=true;
       break;
    }
  }
}

ArrayList<Component> Components= new ArrayList<Component>();
void FixAllComponents(){
   for(int i=0;i<E.Gates.size();i++){
      if(Components.get(i) instanceof Component){
        Component C=(Component)E.Gates.get(i);
        C.FixComponent();
      }
    }
}
void AddNewComponent(Component C){
    C.Number=Components.size();
    Components.add((Component)C.clone());
}
//ArrayList<Component> AddableComponents(ArrayList<Logic> Gates){// By refference
  
//}
//Window W;
Editor E;
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
    
    
  //  if(true){
      dGates.add(new Button(new PVector(50,100),true));
      dGates.add(new Button(new PVector(50,200),true));
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
      for(int i=0;i<dGates.size();i++){
         for(int j=0;j<((Gate)dGates.get(i)).InpPos.length;j++){
           dGates.get(i).InFeedIndexes[j]=0;
         }
      }
      E=new Editor(dGates);
      Windows.add( new EditorWindow(new PVector(100,100),new PVector(800,400),"Main Window",E));
      //Windows.add( new Window(new PVector(200,200),new PVector(800,400),"Test Window",E));
      //Window=createGraphics(500,200,JAVA2D);

    //}else{
    //  LoadPref();
    //}
}
void draw(){
  background(255-15,255-10,255-10); 
  //Window.beginDraw(); 
  //E.Update(mouseX,mouseY);
  //E.Draw(Window);
  //Window.endDraw();
  //image(Window,0,0);
  //E.Interact(MouseClicked);
  //if(keyPressed){
  //  E.KeyHeldInteract(prevPress,keyCode);
  //}
  //if(KeyPressed){
  //  E.KeyPressInteract(key); 
  //}
  //W.Update();
  //W.Draw();
  //W.Interact();
  SetActiveWindow();
  for(int i=0;i<Windows.size();i++){
    Windows.get(i).Run();
  }
  //W.Run();
  
  MouseClicked=false;
  KeyPressed=false;
}
void mouseClicked(){
  MouseClicked=true;
}
void keyPressed(){
  //scale(5);
  KeyPressed=true;
  prevPress=key;
  
 
}