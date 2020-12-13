class Enviroment{
  ArrayList<Cell> Cells= new ArrayList<Cell>();
  ArrayList<Axon> Axons= new ArrayList<Axon>();
  void Draw(){
    for(Cell N:Cells){
      N.Draw(); 
    }
    for(Axon A:Axons){
      A.Draw(); 
    }
  }
  void Update(){
    for(Cell N:Cells){
    N.Update(); 
    }
    for(Axon A:Axons){
      A.Update(); 
    }
  }
}
