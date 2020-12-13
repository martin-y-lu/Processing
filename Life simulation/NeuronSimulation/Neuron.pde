class Cell{
  boolean spiking;
  PVector pos;
  void Update(){
    
  }
  void Draw(){
    
  }
  PVector LeftSide(){
    return new PVector(pos.x-20,pos.y-3*40/2); 
  }
  PVector RightSide(){
    return new PVector(pos.x+3*50+20,pos.y-3*40/2); 
  }
}
class Clock extends Cell{
  int frequency=10;
  int FREQ;
  Clock(PVector dPos,int dFreq){
    pos=dPos;
    FREQ=dFreq;
    frequency=dFreq;
  }
  void Update(){
      spiking=false;
     if(frameCount%frequency==0){
       spiking=true; 
     }
  }
  void Draw(){
    PVector Origin= pos;
    float scale=3;
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
    if(FLtween(Origin.x-20,Origin.x-20+50*scale+40,mouseX)&&FLtween(Origin.y+20,Origin.y+20-40*scale-40,mouseY)){
      frequency=100000;
    }else{
      frequency=FREQ;
    }
  }
  
}
class Neuron extends Cell{
  float memPotential;
  float resting=-70; // -70 mV
  float action=40; // +40 mV
  float thresh=-55;// -55 mV  (channel
  // resting sodium 0 potassium 1 = -70 mv
  //during action sodium is going to peak to one -> sodium 1 potassium 1 is 40 mv
  //after action potassium will drain  -> sodium 1- potassium 0 less than -70 (-85) 
  
  
  float sodiumChannelActivity=1; //0 -> All inactive, 1 -> All active
  float activityFactor=1.14;
  
  float sodiumConc=0.6; // positive charge. 0 -> all outside, 1-> All inside (all outside at resting)
  float sodiumRest=0;
  float sodiumDiff=0.90;// Rate of diffusion exponential
  
  float potassiumChannelStart=0.07;
  float potassiumChannelEnd=0.1;
  
  float potassiumConc=0; // negative charge. 0-> all inside, 1-> All outside (all inside at resting)
  float potassiumRest=1;
  float potassiumDiff=0.94;// Rate of diffusion exponential
  int maxHistory=50;
  float[][] table=new float[maxHistory][4];//History
  int historyLength=0;
  
  
  
  Neuron(PVector dPos,float dSodiumDiff,float dPotassiumDiff,float dActivityFactor,float dPotStart,float dPotEnd){
    pos=dPos;
    sodiumDiff=dSodiumDiff;
    potassiumDiff=dPotassiumDiff;
    activityFactor=dActivityFactor;
    potassiumChannelStart=dPotStart;
    potassiumChannelEnd=dPotEnd;
  }
  void Draw(){
    //text("Membrane Potential: "+memPotential+" mV",100,20);
    //text("Relative Sodium Concentration: "+nf(sodiumConc,1,4),50,40);
    //text("Sodium Channel Activity: "+sodiumChannelActivity,300,40);
    //text("Relative Potassium Concentration: "+nf(potassiumConc,1,4),100,60);
    //text("History:",100,80);
    
    PVector Origin= pos;
    float scale=3;
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
      }else{
        stroke(0);
      }
      line(Origin.x+i*scale,Origin.y-map(table[i][0],-100,60,0,40)*scale,Origin.x+(i+1)*scale,Origin.y-map(table[i+1][0],-100,60,0,40)*scale);
      stroke(0,255,0);
      line(Origin.x+i*scale,Origin.y-map(table[i][3],0,1,0,40)*scale,Origin.x+(i+1)*scale,Origin.y-map(table[i+1][3],0,1,0,40)*scale);
    }
  }
  float[] TableEntry(){
     return new float[]{memPotential,sodiumConc,potassiumConc,sodiumChannelActivity}; 
  }
  void AddHistory(){
    table[historyLength]=TableEntry(); 
    historyLength++;
    if(historyLength>maxHistory-2){
      table=new float[maxHistory][4];//History
      historyLength=0;
    }
  }
  float MemPotential(){
    return (action-resting)*sodiumConc+(action-resting)*potassiumConc+2*resting-action;
  }
  void Update(){
    sodiumConc=sodiumRest-(sodiumRest-sodiumConc)*sodiumDiff;
    potassiumConc=potassiumRest-(potassiumRest-potassiumConc)*potassiumDiff;
    memPotential=MemPotential();
    
    spiking=false;
    if(memPotential>thresh){
      if( sodiumChannelActivity==1){
        sodiumConc=1;
        sodiumChannelActivity=0.05;
        spiking=true;
      }
    }
    sodiumChannelActivity*=activityFactor;
    if(sodiumChannelActivity>1){
      sodiumChannelActivity=1;
    }
    if((sodiumChannelActivity>potassiumChannelStart)&&(sodiumChannelActivity<potassiumChannelEnd)){
      potassiumConc=0;
    }
    
    AddHistory();
  }
 
}
