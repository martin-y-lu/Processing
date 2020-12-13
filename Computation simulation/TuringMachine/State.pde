class State{
  int[] WriteSymbols;
  boolean[] MoveRight;
  int[] NextState;
  ArrayList<State> NextStates= new ArrayList<State>();
  String StateName;
  int Width=180;
  State(String dName,int[] dSymbols,boolean[] dMove){
    StateName=dName;
    WriteSymbols=expand(dSymbols,SymbolList.length);
    MoveRight=expand(dMove,SymbolList.length);
    //NextStates=dStates;
  }
  void InitStates(int[]StateNums){
    NextState=StateNums;
    SetStates();
  }
  void SetStates(){
    NextStates=new ArrayList<State>();
    for(int i=0;i<NextState.length;i++){
       NextStates.add(StateList.get(NextState[i]));
    }
  }
  void DrawState(int x,int y){
    int Height=25*SymbolList.length;
    fill(200,60,60);
    rect(x,y,Width,25+Height);
    if((this==CurrState)){
       fill(255,180,180);
       rect(x,25+25*CurrValue+y,Width,25);
    }
    textSize(16);
    fill(255);
    text(StateName,x+30,19+y);
    if(StateName!="HALT"){
      for(int i=0;i<SymbolList.length;i++){
        if(Reset){
          fill(255,200,200);
          if(MouseIn(x+30,25+25*i+y,30,25)){
            rect(x+30,25+25*i+y,30,25);
            if(MouseClicked){
              WriteSymbols[i]=(WriteSymbols[i]+1)%(WriteSymbols.length);
            }
          }
          if(MouseIn(x+60,25+25*i+y,50,25)){
            rect(x+60,25+25*i+y,50,25);
            if(MouseClicked){
              MoveRight[i]=!MoveRight[i];
            }
          }
          if(MouseIn(x+110,25+25*i+y,Width-110,25)){
            rect(x+110,25+25*i+y,Width-110,25);
            if(MouseClicked){
              NextState[i]= (NextState[i]+1)%(StateList.size());
              SetStates();
            }
          }
        }
        line(x,25+25*i+y,x+ Width,25+25*i+y);
        fill(255);
        textSize(20);
        text(SymbolList[i]+":",x+10,25+25*i+20+y);
        text(SymbolList[WriteSymbols[i]],x+40,25+25*i+20+y);
        if(MoveRight[i]){
          text("->",x+73,25+25*i+20+y);
        }else{
          text("<-",x+73,25+25*i+20+y);
        }
        textSize(16);
        text(NextStates.get(i).StateName,x+115,25+25*i+20+y);
      }
      strokeWeight(1.5);
      line(x+30,y+25,x+30,y+25+Height);
      line(x+60,y+25,x+60,y+25+Height);
      line(x+110,y+25,x+110,y+25+Height);
      strokeWeight(2);
    }
  }
  void SetSymbol(int Value){
    TapeNumList[PointNum]=WriteSymbols[Value];
  }
  void SetDirection(int Value){
    if(MoveRight[Value]){
        PointNum++;
      }else{
        PointNum--;
    }
  }
  void SetNextState(int Value){
    CurrStateNum=NextState[CurrValue];
    CurrState=NextStates.get(Value);
  }
}
