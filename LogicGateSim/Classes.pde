class Logic{
  boolean[] Inp;
  boolean[] Out;
  Logic[] InFeed;
  Logic(boolean[] dInp, boolean[] dOut, Logic[] dInFeed){
    Inp=dInp;
    Out=dOut;
    InFeed=dInFeed;
  }
  void CalcOut(){
    Out[0]=Inp[0];//Eg feed out
  }
  void FeedIn(){
    for( int i=0; i<InFeed.length;i++){
      Inp[i]=InFeed[i].Out[0];//ASSUME THERE IS ONE OUTPUT ALWAYS
    }
  }
  void Update(){
    //FeedIn();
    //printArray(Gates.get(2).Inp);
    //CalcOut();
  }
  Logic clone(){
    Logic Clone = new Logic(Inp,Out,InFeed);
    return Clone;
  }
}

class Gate extends Logic{
  PVector Pos;
  PVector Size;

  PVector[] InpPos;
  PVector[] OutPos;
  
  Gate(PVector dPos, PVector dSize, int NumInps, int NumOut, PVector[] dInpPos, PVector[] dOutPos){
    super(new boolean[NumInps],new boolean[NumOut],new Logic[NumInps]);
    Pos=dPos;
    Size=dSize;
    InpPos=dInpPos;
    OutPos=dOutPos;
  }
  void Draw(){
    fill(255,30);
    noStroke();
    rect(Pos.x,Pos.y,Size.x,Size.y);
    stroke(255);
    for(int i=0; i<InpPos.length;i++){
      Gate InpGate=(Gate)InFeed[i];
        if(InpGate.Out[0]){
          stroke(40,200,40);
        }else{
          stroke(200,40,40); 
        }
        line(InpGate.ScreenPointOut(0).x,InpGate.ScreenPointOut(0).y,ScreenPointInp(i).x,ScreenPointInp(i).y);
    }
  }
  boolean Moused(){
    return MouseIn(Pos,Size);
  }
  PVector ScreenPointInp(int inpNum){
    return PVadd(Pos,InpPos[inpNum]);
  }
  PVector ScreenPointOut(int outNum){
    return PVadd(Pos,OutPos[outNum]);
  }
  Logic clone(){
    Gate Clone = new Gate(Pos,Size,Inp.length,Out.length,InpPos,OutPos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    return Clone;
  }
}
class Button extends Gate{
  boolean State;
  Button(PVector dPos,boolean dState){
    super(dPos,new PVector(20,20),0,1,new PVector[]{},new PVector[]{new PVector(30,10)});
    State=dState;
  }
  void Draw(){
    super.Draw();
    if(State){
      fill(40,200,40);
    }else{
      fill(200,40,40); 
    }
    stroke(255);
    strokeWeight(2);
    ellipse(Pos.x+10,Pos.y+10,40,40);
    ellipse(Pos.x+10,Pos.y+10,20,20);
    
    //shape(Or,Pos.x,Pos.y);
  }
  void CalcOut(){
    Out[0]=State;
  }
  void Update(){
    super.Update();
    if((!Moused())&&MouseIn(PVadd(Pos, new PVector(-5,-5)),new PVector(40,40))&&MouseClicked){
      State=!State;
    }
  }
  Logic clone(){
    Button Clone = new Button(Pos,State);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    return Clone;
  }
}
class Display extends Gate{
  Display(PVector dPos){
    super(dPos,new PVector(40,40),1,1,new PVector[]{new PVector(0,20)},new PVector[]{new PVector(30,20)});
  }
  void Draw(){
    super.Draw();
    if(Inp[0]){
      fill(40,200,40);
    }else{
      fill(200,40,40); 
    }
    stroke(255);
    strokeWeight(2);
    ellipse(Pos.x+20,Pos.y+20,40,40);
  }
  void CalcOut(){
    Out[0]=Inp[0];
  }
  void Update(){
    super.Update();
  }
  Logic clone(){
    Display Clone = new Display(Pos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    return Clone;
  }
}
class OrGate extends Gate{
  OrGate(PVector dPos){
    super(dPos,new PVector(60,40),2,1,new PVector[]{new PVector(0,10),new PVector(0,30)},new PVector[]{new PVector(60,20)});
  }
  void Draw(){
    super.Draw();
    shape(Or,Pos.x,Pos.y);
  }
  void CalcOut(){
    Out[0]=Inp[0]||Inp[1];
  }
  Logic clone(){
    OrGate Clone = new OrGate(Pos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    return Clone;
  }
}
class AndGate extends Gate{
  AndGate(PVector dPos){
    super(dPos,new PVector(60,40),2,1,new PVector[]{new PVector(0,10),new PVector(0,30)},new PVector[]{new PVector(60,20)});
  }
  void Draw(){
    super.Draw();
    shape(And,Pos.x,Pos.y);
  }
  void CalcOut(){
    Out[0]=Inp[0]&&Inp[1];
  }
  Logic clone(){
    AndGate Clone = new AndGate(Pos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    return Clone;
  }
}
class NotGate extends Gate{
  NotGate(PVector dPos){
    super(dPos,new PVector(30+3+5,30),1,1,new PVector[]{new PVector(0,15)},new PVector[]{new PVector(35,15)});
  }
  void Draw(){
    super.Draw();
    shape(Not,Pos.x,Pos.y);
  }
  void CalcOut(){
    Out[0]=!Inp[0];
  }
  Logic clone(){
    NotGate Clone = new NotGate(Pos);
    Clone.Inp=Inp.clone();
    Clone.Out=Out.clone();
    Clone.InFeed=InFeed.clone();
    return Clone;
  }
}