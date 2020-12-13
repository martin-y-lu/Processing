abstract class Cell{
  Environment env;
  protected boolean spiking;
  float potential=0;
  float scale=1;
  
  int maxHistory=200;
  float[][] history = new float[maxHistory][2];
  
  PVector pos;
  
  ArrayList<Axon> inAxons= new ArrayList<Axon>();
  ArrayList<Axon> outAxons= new ArrayList<Axon>();
  boolean isSpiking(){
    return spiking; 
  }
  void AddHistory(){
     for(int i=history.length-1;i>0;i--){
        for(int j=0;j<2;j++){
          history[i][j]=history[i-1][j];
        }
        
     }
     history[0][0]=potential;
     history[0][1]=spiking? 0:1;
  }
  abstract void Update();
  abstract void Draw();
  PVector LeftSide(){
    return new PVector(pos.x-20,pos.y-40*scale/2); 
  }
  PVector RightSide(){
    return new PVector(pos.x+50*scale+20,pos.y-40*scale/2); 
  }
  boolean MouseIn(){
    return FLtween(pos.x-20,pos.x-20+50*scale+40,mouseX)&&FLtween(pos.y+20,pos.y+20-40*scale-40,mouseY); 
  }
}
class Input extends Cell{  
  float peak;
  float cap;
  float activity=0;
  boolean triggered=false;
  Input(PVector dPos,float dPeak,float dCap){
    pos=dPos;
    peak=dPeak;
    cap=dCap;
  }
  void Trigger(){
    activity=peak; 
    triggered=true;
  }
  void Update(){
    spiking=false;
    if(triggered){
      spiking=true;
      triggered=false;
    }
    
    activity-=1;
    if(activity<0) activity=0;
    potential=min(activity/cap,1);
    AddHistory();
  }
  void Draw(){
    PVector Origin= pos;
    float scale=1;
    //PVector X= new PVector(10,0);
    //PVector Y= new PVector(0,-10);
    fill(255,180,190);
    strokeWeight(2);
    stroke(0);
    if(spiking){
      strokeWeight(5);
      stroke(255,0,0);
    }
    rect(Origin.x-20,Origin.y+20,50*scale+40,-40*scale-40,20);
    fill(0);
    rect(Origin.x,Origin.y,50*scale,-40*scale*potential);
  }
  
}
class Clock extends Cell{
  int frequency=10;
  int shift=0;
  int FREQ;
  Clock(PVector dPos,int dFreq){
    pos=dPos;
    FREQ=dFreq;
    frequency=dFreq;
  }
  Clock(PVector dPos,int dFreq,int dShift){
    pos=dPos;
    FREQ=dFreq;
    frequency=dFreq;
    shift=dShift;
  }
  void Update(){
      spiking=false;
      potential= 1-float((frameCount-shift)%frequency)/frequency;
     if((frameCount+shift)%frequency==0){
       spiking=true; 
     }
     AddHistory();
  }
  void Draw(){
    PVector Origin= pos;
    float scale=1;
    //PVector X= new PVector(10,0);
    //PVector Y= new PVector(0,-10);
    fill(255,180,190);
    strokeWeight(2);
    stroke(0);
    if(spiking){
      strokeWeight(5);
      stroke(255,0,0);
    }
    rect(Origin.x-20,Origin.y+20,50*scale+40,-40*scale-40,20);
    rect(Origin.x,Origin.y,50*scale,-40*scale*potential);
    if(MouseIn()&&(mode==Mode.Poke)){
      frequency=100000;
    }else{
      frequency=FREQ;
    }
  } 
}

class Neuron extends Cell{
  float thresh=1 ;
  
  float deadClock=0;
  float deadTime=1;
  
  int maxTableHistory=50;
  float[][] table=new float[maxTableHistory][3];//History
  int historyLength=0;
  
  Neuron(PVector dPos,float dDeadTime){
    pos=dPos;
    deadTime=dDeadTime;
    if(deadTime<0){
      deadTime=0; 
    }
    scale=2;
  }
  void Draw(){
    text("Potential: "+potential,100,20+30);
    PVector Origin= pos;
    
    //PVector X= new PVector(10,0);
    //PVector Y= new PVector(0,-10);
    fill(255,180,190);
    strokeWeight(2);
    stroke(0);
    if(spiking){
      strokeWeight(5);
      stroke(255,0,0);
    }
    rect(Origin.x-20,Origin.y+20,50*scale+40,-40*scale-40,20);
    stroke(0);
    line(Origin.x,Origin.y,Origin.x+50*scale,Origin.y);
    line(Origin.x,Origin.y,Origin.x,Origin.y-40*scale);
    
    for( int i=0; i<historyLength-1;i++){
      
      //String s="";
      //for( int j=0; j<4;j++){
      //    s+=table[i][j]+" ,";
      //}
      //text(s,200,80+i*20);
      if(table[i][0]>thresh){
         stroke(255,0,0); 
         if(table[i][2]>0){
            stroke(255,155,0); 
         }
      }else{
        stroke(0);
        if(table[i][2]>0){
          stroke(255,255,0); 
        }
      }
      strokeWeight(2.5); 
      
      float max = 1.5;
      float min= -0.5;
      line(Origin.x+i*scale,Origin.y-map(table[i][0],min,max,0,40)*scale,Origin.x+(i+1)*scale,Origin.y-map(table[i+1][0],min,max,0,40)*scale);
    }
  }
  void AddTableHistory(){
     historyLength=maxTableHistory-1;
     for(int i=0;i<table.length-1;i++){
        for(int j=0;j<3;j++){
          table[i][j]=table[i+1][j];
        }
        
     }
     table[historyLength][0]=potential;
     table[historyLength][1]=spiking? 0:1;
     table[historyLength][2]=deadClock;
     
    //historyLength++;
    //if(historyLength>maxTableHistory-2){
    //  table=new float[maxTableHistory][2];//History
    //  historyLength=0;
    //}
  }
  
  void Update(){
    spiking=false;
    potential=0;
    for(Axon inAxon:inAxons){
        potential+=inAxon.getSignal();
    }
    if(MouseIn()&&MousePressed&&mode==Mode.Poke){
      potential=thresh;
    }
    if(deadClock<=0){
      if(potential>=thresh){
        spiking=true;
        deadClock=deadTime;
      }
    }
   
    deadClock-=1;
    AddHistory();
    AddTableHistory();
  }
}
