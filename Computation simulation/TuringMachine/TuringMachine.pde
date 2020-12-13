boolean MouseClicked=false;
boolean ManyRounds=false;
boolean Reset=true;
int RoundNum=0;
int OpNum=0;

State CurrState;
int CurrStateNum=1;
int CurrValue;

int InitPointNum=10;
boolean Halted=false;
String[] SymbolList={"a","b","c"}; 
int[] InitTapeList={1,1,0,2,1,0,
                   0,1,0,2,1,0,
                   2,0,1,0,2,0,
                   0,1,0,1,2,2,
                   0,2,0,0,1,1,0,0,0,0,0,0,0,0,0,0};
                   
int PointNum=10;
int[] TapeNumList=new int[InitTapeList.length];
ArrayList<State> StateList=new ArrayList<State>();
State H=new State("HALT",new int[]{1,0},new boolean[]{true,true});
void setup(){
    frameRate(60);
    size(1000, 360);
    arrayCopy(InitTapeList,TapeNumList);
    StateList.add(H);
    StateList.add(new State("Right1",new int[]{0,1,0},new boolean[]{true,true,true}));
    StateList.add(new State("Right2",new int[]{0,1,0},new boolean[]{true,false,true}));
    StateList.add(new State("Left1",new int[]{0,1,0},new boolean[]{false,false,false}));
    StateList.add(new State("Left2",new int[]{0,1,0},new boolean[]{false,true,false}));
    CurrState=StateList.get(1);
    StateList.get(1).InitStates(new int[]{1,2,1});
    StateList.get(2).InitStates(new int[]{1,3,1});
    StateList.get(3).InitStates(new int[]{3,4,3});
    StateList.get(4).InitStates(new int[]{3,0,3});
}

void draw(){
  background(9); 
  fill(0);
  strokeWeight(2);
  
  for(int i=0;i<TapeNumList.length;i++){
    fill(255);
    textSize(12);
    text(i,18+i*25,15);
    stroke(255);
    fill(120,20,20);
    if(MouseIn(15+i*25,20,20,30)){
      fill(255,200,200);
      if(MouseClicked){
        if(Reset){
          InitTapeList[i]=(InitTapeList[i]+1)%(SymbolList.length);
          arrayCopy(InitTapeList,TapeNumList);
        }else{
          TapeNumList[i]=(TapeNumList[i]+1)%(SymbolList.length);
        }
      }
    }
    rect(15+i*25,20,20,30);
    
    fill(255);
    textSize(20);
    text(SymbolList[TapeNumList[i]],19+i*25,42);
    
  }
  
  fill(255,100,100);
  triangle(25+PointNum*25,60,45+PointNum*25,85,5+PointNum*25,85);
  int ShiftAmount=0;
  if(OpNum==0){
   ShiftAmount=30;
  }else if(OpNum==1){
   ShiftAmount=70;
  }else if(OpNum==2){
   ShiftAmount=130;
  }
  triangle(25+(CurrStateNum-1)*180+ShiftAmount,135+25*SymbolList.length
  ,45+(CurrStateNum-1)*180+ShiftAmount,160+25*SymbolList.length
  ,5+(CurrStateNum-1)*180+ShiftAmount,160+25*SymbolList.length);
  
  for(int i=1;i<StateList.size();i++){
    StateList.get(i).DrawState(10+(i-1)*180,100);
  }
 
  if(MouseIn(10,275-20,200,25)){
    if(MouseClicked){
      OneStep();
    }
    fill(255,200,200);
  }else{fill(250,110,110);}
  rect(10,275-20,200,25);
  
  if(MouseIn(10,310-20,200,25)){
    fill(255,200,200);
    if(MouseClicked){
      OneStep();
      while(OpNum!=0){
        OneStep();
      }
    }
  }else{fill(250,110,110);}
  rect(10,310-20,200,25);
  
  if(MouseIn(10,345-20,200,25)){
    fill(255,200,200);
    if(MouseClicked){
      ManyRounds= !ManyRounds;
    }
  }else{fill(250,110,110);}
  rect(10,345-20,200,25);
  
  if(MouseIn(220,275-20,200,25)){
    fill(255,200,200);
    if(MouseClicked){
      ManyRounds=false;
      Reset();
    }
  }else{fill(250,110,110);}
  rect(220,275-20,200,25);
  
  fill(255);
  textSize(20);
  text("Do one Operation",20,275);
  text("Do one Round",20,310);
  if(ManyRounds){
    text("Stop doing Rounds",20,345);
    if(frameCount%15==0){
      OneStep();
    }
  }else{
    text("Do Many Rounds",20,345);
  }
  text("Reset",250,275);
  
  text("Operation- "+OpNum,220,305);
  text("Round- "+RoundNum,220,325);
  if(!Reset){
    text("Running",220,345);
  }
  MouseClicked=false;
}
void OneStep(){
  Reset=false;
  if(Halted==false){
    if(OpNum==0){
      CurrValue=TapeNumList[PointNum];
      CurrState.SetSymbol(CurrValue);
      OpNum++;
    }else if(OpNum==1){
      CurrState.SetDirection(CurrValue);
      OpNum++;
    }else if(OpNum==2){
       CurrState.SetNextState(CurrValue);
       if(CurrState.StateName=="HALT"){
         Halted=true;
       }
       OpNum=0;
       RoundNum++;
    }
  }
}
void Reset(){
      Reset=true;
      arrayCopy(InitTapeList,TapeNumList);
      PointNum=InitPointNum;
      CurrState=StateList.get(1);
      CurrStateNum=1;
      Halted=false;
      OpNum=0;
      RoundNum=0; 
}
void mouseClicked(){
  MouseClicked=true;
}
void mouseReleased(){
 // MouseClicked=false;
}
