//Neuron N= new Neuron(new PVector(100,550));

//ArrayList<Cell> Cells= new ArrayList<Cell>();
//ArrayList<Axon> Axons= new ArrayList<Axon>();
Enviroment E= new Enviroment();
void setup(){
  size(1600,700);
  Neuron inp1=new Neuron(new PVector(300,200),0.9,0.94,1.14,0.07,0.1);
  Neuron inp2=new Neuron(new PVector(300,400),0.9,0.94,1.14,0.07,0.1);
  Neuron AND=new Neuron(new PVector(650,400),0.9,0.94,1.14,0.07,0.1);
  Neuron OR=new Neuron(new PVector(650,200),0.9,0.94,1.14,0.07,0.1);
  Neuron NAND=new Neuron(new PVector(950,480),0.99,0.994,1.14,0.07,0.1);
  Neuron XOR=new Neuron(new PVector(1250,340),0.905,0.92,1.10,0.06,0.065);
  Clock clock1=new Clock(new PVector(50,250),50);
  Clock clock2=new Clock(new PVector(50,350),50);
  Clock clock3=new Clock(new PVector(650,600),25);
  E.Cells.add(inp1);
  E.Cells.add(inp2);
  E.Cells.add(AND);
  E.Cells.add(OR);
  E.Cells.add(NAND);
  E.Cells.add(XOR);
  E.Cells.add(clock1);
  E.Cells.add(clock2);
  E.Cells.add(clock3);
  E.Axons.add(new Axon(inp1,AND,0.15,0,10));
  E.Axons.add(new Axon(inp2,AND,0.15,0,10));
  E.Axons.add(new Axon(inp1,OR,0.25,0,10));
  E.Axons.add(new Axon(inp2,OR,0.25,0,10));
  E.Axons.add(new Axon(OR,XOR,0.14,0,10));
  
  E.Axons.add(new Axon(clock1,inp1,0.25,0,10));
  E.Axons.add(new Axon(clock2,inp2,0.25,0,10));
  
  E.Axons.add(new Axon(clock3,NAND,0.18,0,10));
  E.Axons.add(new Axon(AND,NAND,-0.50,0,10));
  E.Axons.add(new Axon(NAND,XOR,0.14,0,10));
}
void draw(){
  background(255);
  fill(0);
  //N.Draw();
  //N.Update(); 
  E.Draw();
  E.Update();

}

void keyPressed(){
}
void mousePressed(){
   ((Neuron)E.Cells.get(0)).sodiumConc+=0.1;
}
