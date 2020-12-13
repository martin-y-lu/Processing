enum Mode{
  Move,
  Poke,
  View
}

Environment E= new Environment();
Mode mode= Mode.Move;
void setup(){
  size(1600,700);
  //Clock clock1=new Clock(new PVector(50,250),50);
  //Clock clock2=new Clock(new PVector(50,250+100),50,15);
  //  Neuron neuron1=new Neuron(new PVector(50+300,250),20);
  //E.Cells.add(clock1);
  //E.Cells.add(clock2);
  //E.Cells.add(neuron1);
  //E.Axons.add(new Axon(clock1,neuron1,10,20,10,0.5));
  //E.Axons.add(new Axon(clock2,neuron1,1,20,10,0.6));
  Input input1=new Input(new PVector(50,250),20,10);
  Input input2=new Input(new PVector(50,250+100),20,10);
  Input input3=new Input(new PVector(50,250+2*100),20,10);
  Neuron neuron1=new Neuron(new PVector(50+300,250),20);
  Neuron neuron2=new Neuron(new PVector(50+300,250+100),20);
  E.Cells.add(input1);
  E.Cells.add(input2);
  E.Cells.add(input3);
  E.Cells.add(neuron1);
  E.Cells.add(neuron2);
  E.Axons.add(new Axon(input1,neuron1,10,20,10,0.5));
  E.Axons.add(new Axon(input2,neuron1,1,20,10,0.6));
  E.Axons.add(new Axon(input3,neuron1,1,20,10,0.6));
  
  E.Axons.add(new Axon(input1,neuron2,10,20,10,0.5));
  E.Axons.add(new Axon(input2,neuron2,1,20,10,0.6));
  E.Axons.add(new Axon(input3,neuron2,1,20,10,0.6));
  E.Axons.add(new Axon(neuron1,neuron2,1,20,10,0.6));
  E.SetController( new LogicInputController(input1,input2,input3));
  E.Commit();
}
boolean KeyPressed=false;
boolean MousePressed=false;
Cell clicking;

void draw(){
  background(255);
  fill(0);
  text("Mode: "+mode,100,100);
  E.Draw();
  E.Update();
  if(mode==Mode.Move){
    if(mousePressed){
      if(clicking !=null){
        clicking.pos= new PVector(mouseX,mouseY);
      }
    }else{
      clicking=null; 
    }
  }
  //println(clicking);
//  println(A.getValue());
  if(KeyPressed){
     if(key=='m'){
      switch(mode){
        case Move:
          mode=Mode.Poke;
          break;
        case Poke:
          mode=Mode.View;
          break;
        case View:
          mode=Mode.Move;
          break;
      }
    } 
  }
  KeyPressed=false;
  MousePressed=false;
}

void keyPressed(){
  KeyPressed=true;
  
}

void mousePressed(){
  MousePressed=true;
   for(Cell cell:E.Cells){
    if(cell.MouseIn()){
      print("indeed");
      clicking=cell;
    }
  }
}
