class Gate{
  PVector Pos;
  boolean[] Inp;
  boolean[] Out;
  
  Gate(PVector dPos, int NumInps, int NumOut){
    Pos=dPos;
    Inp=new boolean[NumInps];
    Out=new boolean[NumOut];
  }
  void Draw(){
  }
  void CalcOut(){
  }
}
class OrGate extends Gate{
  OrGate(PVector dPos){
    super(dPos,2,1);
  }
  void Draw(){
    shape(Or,Pos.x,Pos.y);
  }
}