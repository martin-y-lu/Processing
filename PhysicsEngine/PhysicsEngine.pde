class Button{
  PVector Pos;
  PVector Size;
  String Text;
  Button(PVector DPos,PVector DSize,String DText){
    Pos=DPos; Size=DSize; Text=DText;
  }
  Boolean IsPressed(){
    return mousePressed&&(PrevMouse==false)&&FLtween(Pos.x,Pos.x+Size.x,mouseX)&&FLtween(Pos.y,Pos.y+Size.y,mouseY);
  }
  void Display(){
    stroke(0);
    fill(255);
    rect(Pos.x,Pos.y,Size.x,Size.y);
    fill(0);
    text(Text,Pos.x+5,Pos.y+15);
  }
}

Organism Test= new Organism();
Enviroment Env= new Enviroment();
PVector Cam= new PVector(0,0);
float Energy=0;
boolean PrevMouse=false;
void setup(){
    //size(640, 360); 
    fullScreen();
  //stroke(0); 
  //strokeWeight(3);
  frameRate(60);
    
  Env.SetSummonArea(new PVector(0,100),new PVector(200,200));
  Env.OList.add(new Organism());
  Env.OList.get(0).PList.add(new Logic(new PVector(100,130),new PVector(0,0),1,0,new boolean[]{true,true}));
  Env.OList.get(0).PList.add(new Logic(new PVector(200,130),new PVector(0,0),1,2,new boolean[]{}));
  Env.OList.get(0).PList.add(new Point(new PVector(150,80),new PVector(0,0),1));
  Env.OList.get(0).PList.add(new Eye(new PVector(150,130),new PVector(0,0),8));
  //Env.OList.get(0).PList.add(new Eye(new PVector(150,130),new PVector(0,0),8));
 // Env.OList.get(0).PList.add(new Logic(new PVector(30,130),new PVector(0,0),1,0,new boolean[]{true}));
  Env.OList.get(0).MList.add(new Muscle(0,1,.4,110,.2,1,160,.2));
  Env.OList.get(0).MList.add(new Muscle(1,2,.4,110,.2,1,160,.2));
  Env.OList.get(0).MList.add(new Muscle(2,0,.4,110,.2,1,160,.2));
  Env.OList.get(0).MList.add(new Muscle(2,3,1,110,.2,1,160,.2));
  Env.OList.get(0).NList.add(new Neuron(3,false,0,15));
  //Env.OList.get(0).NList.add(new Neuron(4,false,0,30));
  Env.OList.get(0).NList.add(new Neuron(0,false,1,15));
  Env.OList.get(0).NList.add(new Neuron(1,true,3,30));
  Env.OList.get(0).SetVars();
  
  Env.OList.add(new Organism());
  Env.OList.get(1).PList.add(new Logic(new PVector(150,81),new PVector(0,0),1,1,new boolean[]{}));
  Env.OList.get(1).PList.add(new Logic(new PVector(151,80),new PVector(0,0),1,1,new boolean[]{}));
  Env.OList.get(1).PList.add(new Logic(new PVector(150,82),new PVector(0,0),1,1,new boolean[]{}));
  Env.OList.get(1).MList.add(new Muscle(0,1,.4,110,.2,1,160,.2));
  Env.OList.get(1).MList.add(new Muscle(1,2,.4,110,.2,1,160,.2));
  Env.OList.get(1).MList.add(new Muscle(2,0,.4,110,.2,1,160,.2));
  Env.OList.get(1).NList.add(new Neuron(0,true,1,15)); 
  Env.OList.get(1).NList.add(new Neuron(1,true,2,15));
  Env.OList.get(1).NList.add(new Neuron(2,true,0,15));

  Env.OList.get(1).SetVars();
  //Env.GenNewOrg();
 
  Env.BList.add(new Barrier(new PVector(-1000,300),new PVector(1800,0),.2,.1));
  Env.GenNewOrg();
  
  Env.SetVars();
  Env.ShiftToTest(2);
}

int CurrentTestDisplay=1;
void draw(){
  background(160,190,255); 
  fill(140,170,255);
  rect(Env.SummonPos.x-Cam.x,Env.SummonPos.y-Cam.y,Env.SummonRect.x,Env.SummonRect.y);
  fill(255);
  if(mouseY<80){
    Cam.y-=12;
  }if(mouseY>height-80){
    Cam.y+=12;
  }if(mouseX<80){
    Cam.x-=12;
  }if(mouseX>width-80){
    Cam.x+=12;
  }
  //Env.UpdateOrg(0);
  // Env.TestList.get(0).PList.get(4).Pos=new PVector(mouseX+Cam.x,mouseY+Cam.y);
  rect(100,110,200,60);
  fill(0);
  text("Displaying- "+CurrentTestDisplay,110,130);
  if(CurrentTestDisplay>0){
     new Button(new PVector(120,140),new PVector(60,20),"Previous").Display();
    if(new Button(new PVector(120,140),new PVector(60,20),"Previous").IsPressed()){
      CurrentTestDisplay--;
      Env.TestList.remove(0);
      Env.ShiftToTest(CurrentTestDisplay);
    }  
  }
  if(CurrentTestDisplay<Env.OList.size()-1){
    new Button(new PVector(200,140),new PVector(60,20),"Next").Display();
    if(new Button(new PVector(200,140),new PVector(60,20),"Next").IsPressed()){
      CurrentTestDisplay++;
      Env.TestList.remove(0);
      Env.ShiftToTest(CurrentTestDisplay);
    }
  }
  new Button(new PVector(200,115),new PVector(60,20),"Regen").Display();
  if(new Button(new PVector(200,115),new PVector(60,20),"Regen").IsPressed()){
      Env.OList.remove(2);
      Env.GenNewOrg();
      Env.ShiftToTest(CurrentTestDisplay);
  }
  
  
  Env.TestList.get(0).RunTest();
  text(Env.TestList.get(0).time,20,50);
  text(Env.TestList.get(0).time,20,50);
  if(Env.TestList.get(0).Finalized){
    text(Env.TestList.get(0).Fitness,20,60);
  }
  
  Env.DrawEnv(0);
  text(mouseX+" "+mouseY,10,10);
  text(Cam.x+" "+Cam.y,10,20);
  text(Energy,10,30);
  
  PrevMouse=mousePressed;
}
void mouseClicked(){
  //Env.OList.get(2).MutateOrg();
  //Env.TestList.remove(0);
  ////Env.OList.remove(2);
  ////Env.GenNewOrg();
  //Env.ShiftToTest(2);
}