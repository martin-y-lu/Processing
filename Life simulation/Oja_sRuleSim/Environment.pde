class Environment{
  ArrayList<Cell> Cells= new ArrayList<Cell>();
  ArrayList<Axon> Axons= new ArrayList<Axon>();
  InputController controller;
  
  void SetController(InputController dController){
     controller=dController;
  }
  void Commit(){
    for(Axon A:Axons){
      A.Commit(); 
      A.env=this;
    }
    for(Cell C:Cells){
      C.env=this; 
    }
  }
  void Draw(){
    for(Cell N:Cells){
      N.Draw(); 
    }
    for(Axon A:Axons){
      A.Draw(); 
    }
  }
  void Update(){
    for(Axon A:Axons){
      A.Update(); 
    }
    controller.Update();
    for(Cell N:Cells){
      N.Update(); 
    }
  }
  Axon AxonFromTo(Cell A,Cell B){
    for(Axon ax:A.outAxons){
      if(ax.postsynaptic==B){
         return ax; 
      }
    }
    return null;
  }
  float getCellSimilarity(Cell A,Cell B){
    float similarity=0;
    for(Axon ax: A.inAxons){
       Cell presynaptic= ax.presynaptic;
       Axon fromPresynapseToB= AxonFromTo(presynaptic,B);
       if(fromPresynapseToB!=null){
         similarity+=ax.weight*fromPresynapseToB.weight;     
       }
    }
    return similarity;
  }
}

abstract class InputController{
   ArrayList<Input> inputs;
   abstract void Update();
}
class LogicInputController extends InputController{
    Input inputA;
    Input inputB;
    Input AorB;
    int period=50;
    LogicInputController(Input dInputA, Input dInputB, Input dAorB){
       inputA= dInputA;
       inputB= dInputB;
       AorB= dAorB;
    }
    void Update(){
      if(frameCount%period==0){
        boolean a= random(1)>0.5; 
        boolean b= random(1)>0.5;
        if(a||b) inputA.Trigger();
        if(b) inputB.Trigger();
        if((a||b)&&(!b)) AorB.Trigger();
      }
    }
}
