class Axon{
  Cell presynaptic;
  Cell postsynaptic;
  float sodiumIncrease=0;
  float potassiumIncrease=0;
  boolean[] spikeHistory;
  Axon(Cell dPre,Cell dPost,float dSodInc,float dPotInc,int delay){
    presynaptic=dPre;
    postsynaptic=dPost;
    sodiumIncrease=dSodInc;
    potassiumIncrease=dPotInc;
    if(delay<1){
      delay=1; 
    }
    spikeHistory= new boolean[delay];
  }
  void Update(){
    for(int i=spikeHistory.length-1;i>0;i--){
      spikeHistory[i]=spikeHistory[i-1];
    }
    spikeHistory[0]=presynaptic.spiking;
    if(spikeHistory[spikeHistory.length-1]){
      print("GOOOO");
      ((Neuron)postsynaptic).sodiumConc+=sodiumIncrease; 
      ((Neuron)postsynaptic).potassiumConc+=potassiumIncrease; 
    }
  }
  void Draw(){
    stroke(255,180,190);
    //stroke(255);
    strokeWeight(10);
    PVector pre=presynaptic.RightSide();
    PVector post=((Neuron)postsynaptic).LeftSide();
    for(int i=0; i<spikeHistory.length-1;i++){
      float val= float(i)/float(spikeHistory.length-1);
      float valm= float(i+1)/float(spikeHistory.length-1);
      //println(val+" "+valm);
      PVector left= PVlerp(pre,post,val);
      PVector right=  PVlerp(pre,post,valm);
      stroke(255,180,190);
      if(spikeHistory[i]){
        stroke(255,0,0);
      }
      
      line(left.x,left.y,right.x,right.y);
    }
    
  }
}
