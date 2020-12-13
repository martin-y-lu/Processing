class Axon {
  Environment env;
  Cell presynaptic;
  Cell postsynaptic;
  
  int maxHistory=200;
  float[] signalHistory= new float[maxHistory];
  boolean[] spikeHistory = new boolean[maxHistory];

  // idea for upgrading the system.
  // spike history stores the time a spike occurs within the interval of 1 second
  // [ t: t-1, t-1: t-2, ....]
  // if the Activity is negative (-1) no spike occurs.
  // if the Activity is positive, the Activity represents the time when the spike occured.

  private float Activity=0;

  float delay;
  float peak;
  float cap;
  float weight;
  Axon(Cell dPre, Cell dPost, float dDelay, float dPeak, float dCap, float dWeight) {
    presynaptic= dPre;
    postsynaptic= dPost;
    delay=dDelay;
    if (delay<1) {
      delay=1;
    }

    peak= abs(dPeak);
    cap= abs(dCap);
    weight= dWeight;
  }
  void Commit() {
    print("committing");
    presynaptic.outAxons.add(this);
    postsynaptic.inAxons.add(this);
  }
  void Remove() {
    presynaptic.outAxons.remove(this);
    postsynaptic.inAxons.remove(this);
  }
  
  void AddHistory(){
     for(int i=signalHistory.length-1;i>0;i--){
        signalHistory[i]=signalHistory[i-1];
     }
     signalHistory[0]=getSignal();
  }
  void Update() {
    for (int i=spikeHistory.length-1; i>0; i--) {
      spikeHistory[i]=spikeHistory[i-1];
    }
    spikeHistory[0]=presynaptic.isSpiking();
    if (spikeHistory[floor(delay)]) {
      Activity = peak;
    } else {
      Activity -= 1;
    }
    if (Activity<0) {
      Activity=0;
    }
    AddHistory();
    //weight+=0.01*postsynaptic.potential*(presynaptic.history[floor(delay)][0]-weight*postsynaptic.potential);
    {
      float weightRate=0.01;
      float weightplus=weight+weightRate;
      float weightminus=weight-weightRate;
      float thisValue=estimateValue(signalHistory,delay,weight);
      float weightplusValue=estimateValue(signalHistory,delay,weightplus);
      float weightminusValue=estimateValue(signalHistory,delay,weightminus);
      //text("thisvalue:"+thisValue+"  delayPlus:"+delayplusValue+"  delayMinus:"+ delayminusValue,half.x,half.y+20);
      float allowthresh=2;
      if(weightplusValue>thisValue+allowthresh||weightminusValue>thisValue+allowthresh){
        if(weightplusValue>thisValue+2&&weightminusValue>thisValue+2){
          if(weightplusValue>weightminusValue){
            weight=weightplus;
          }else{
            weight=weightminus;
          }
        }else if(weightplusValue>thisValue+allowthresh){
          weight=weightplus;
        }else{
          weight=weightminus;
        }
      }
      if(weight>1) weight=1;
      if(weight<-1) weight=-1;
    }
    if(frameCount>250){
      float thisValue=estimateValue(signalHistory,delay,weight);
      float delayplusValue=estimateValue(delay+1,peak,cap,weight);
      float delayminusValue=estimateValue(delay-1,peak,cap,weight);
      //text("thisvalue:"+thisValue+"  delayPlus:"+delayplusValue+"  delayMinus:"+ delayminusValue,half.x,half.y+20);
      float allowthresh=3;
      if(delayplusValue>thisValue+allowthresh||delayminusValue>thisValue+allowthresh){
        if(delayplusValue>thisValue+allowthresh&&delayminusValue>thisValue+allowthresh){
          if(delayplusValue>delayminusValue){
            delay++;
          }else{
            delay--; 
          }
        }else if(delayplusValue>thisValue+allowthresh){
          delay++;
        }else{
          delay--;
        }
        if(delay<1){
          delay=1;
        }
      }
    }
    
  } 
  float getSignal() {
    return min(Activity/cap, 1)*weight;
  }
  float[] generateAlternateHistory(float dDelay, float dPeak, float dCap, float dWeight){
    if(dDelay<1){
      dDelay=1; 
    }
    
    float[] signalHistory= new float[maxHistory];
    float activity=0;
    for(int i= maxHistory-1;i>=0;i--){
      activity-=1;
      if(i+floor(dDelay)<maxHistory){
        if(spikeHistory[i+floor(dDelay)]){
           activity=dPeak;
        }
      }
      if(activity<0){
        activity=0;
      }
      signalHistory[i]= min(activity/dCap,1)*dWeight;
    }
    return signalHistory;
  }
  float estimateValue(float dDelay, float dPeak, float dCap, float dWeight){
    float[]testSignalHistory=generateAlternateHistory(dDelay,dPeak,dCap, dWeight);
    return estimateValue(testSignalHistory,dDelay,dWeight);
  }
  float estimateValue(float[]testSignalHistory,float dDelay, float dWeight){
    float value=0;
    for(int shift=0;shift<presynaptic.history.length-floor(delay)-1;shift++){
      float pre=presynaptic.history[floor(delay)+shift][0];
      float post=postsynaptic.history[shift][0]-signalHistory[shift]+testSignalHistory[shift];
      value+=post*(pre-dWeight*post);
    }
    float similarity= dWeight*env.getCellSimilarity(presynaptic,postsynaptic);
    
    return abs(dWeight+value)-dDelay-similarity;
    //return dWeight*value;
  }
  void Draw() {
    stroke(255, 180, 190);
    //text("Activity: "+getActivity(), 100, 20);
    //stroke(255);
    strokeWeight(10);
    PVector pre=presynaptic.RightSide();
    PVector post=postsynaptic.LeftSide();
    for (int i=0; i<floor(delay); i++) {
      float val= float(i)/float(floor(delay));
      float valm= float(i+1)/float(floor(delay));
      //println(val+" "+valm);
      PVector left= PVlerp(pre, post, val);
      PVector right=  PVlerp(pre, post, valm);
      stroke(255, 180, 190,255*weight);
      if (spikeHistory[i]) {
        stroke(255, 0, 0);
      }
      line(left.x, left.y, right.x, right.y);
    }
    PVector half= PVlerp(pre,post,0.5);
    fill(0);
    float similarity= weight*env.getCellSimilarity(presynaptic,postsynaptic);
    float value= estimateValue(signalHistory,delay,weight);
    text("Weight:"+nf(weight,0,3),half.x,half.y);
    text("similarity:"+nf(similarity,0,3),half.x+100,half.y);
    text("Delay:"+nf(floor(delay),0,0),half.x,half.y+20); 
    text("Value:"+nf(value,0,3),half.x+100,half.y+20); 
    
    //float thisValue=estimateValue(signalHistory,weight);
    //float delayplusValue=estimateValue(delay+1,peak,cap,weight);
    //float delayminusValue=estimateValue(delay-1,peak,cap,weight);
    //text("thisvalue:"+thisValue+"  delayPlus:"+delayplusValue+"  delayMinus:"+ delayminusValue,half.x,half.y+20);
  }
}
