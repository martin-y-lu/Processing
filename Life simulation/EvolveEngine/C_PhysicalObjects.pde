class Smart{
  String Type;//"Input","Node", or "Output"
  float State=0;
  float[]Weights;
  float Bias;
  float[]Inputs=new float[0];// All the Inputs given to node
  float[]UncheckedIn;
  String Activation;//"Relu", or "Sigmoid" 
  int InputsUsed=0;
  
  Smart(String dType,float[]dWeights,float dBias,float[] Din){
    Type=dType;
    Weights=dWeights;
    Bias=dBias;
    UncheckedIn=Din;
    if(Type=="Node"){
      Activation="Relu";
    }else if(Type=="Output"){
      Activation="Sigmoid";
    }
  }
  float Activation(float Val){
      if(Activation=="Relu"){
        return max(0,Val);
      }else if(Activation=="Sigmoid"){
        return 1.0/(1+exp(-Val));
      }else{
        return Val;
      }
  }
  void CalcState(){// Calculates the result of the node
    if(Type!="Input"){
      float out=0;
      for(int i=0;i<Inputs.length;i++){
        if(i<Weights.length){
          out+=Weights[i]*Inputs[i];
        }
      }
      out+=Bias;
      State=Activation(out);
    }
  }
}
class Point extends Smart{
  PVector Pos;
  PVector Vel;
  PVector Acc=new PVector(0,0);
  float Mass;
  

  Point(PVector dPos,PVector dVel,float dMass,float[]dWeights,float dBias,float[] dIn){
    super("Node",dWeights,dBias,dIn);
    Pos=dPos; Vel=dVel; Mass= dMass;//LogicType=DLogic;
  }
  Point(PVector dPos,PVector dVel,float dMass){//For Eye
    super("Input",new float[]{},0,new float[]{});
    Pos=dPos; Vel=dVel; Mass= dMass;//
  }
  Point ClonePoint(){ //Returns a Copy of a Particular Point.
    Point P;
    if(Type=="Input"){
     P=new Point(Pos.copy(),Vel.copy(),Mass); 
    }else{ //if(Type=="Node"){, Otherwise Node
     P=new Point(Pos.copy(),Vel.copy(),Mass,FArrayCopy(Weights),Bias,FArrayCopy(UncheckedIn));
    }
    return P;
  }
  PVector NextPos(){// Calc the next position of Point.
    return PVadd(Pos,PVadd(Vel,PVextend(Acc,0.5)));
  }
  void UpdateP(){// Updates the Positions, Velocities,and so on of the point.
    Pos=NextPos();
    Vel=PVadd(Vel,Acc);
    Acc=new PVector(0,0.3);//Grav
  }
  //void ApplyForce(PVector force){
  //  Acc=PVadd(Acc,PVextend(force,1/Mass));
  //}
  void DrawP(PVector Cam,PGraphics Canvas){// Draws Point.
    Canvas.strokeWeight(2);
    Canvas.text("State:"+State,Pos.x-Cam.x,Pos.y-Cam.y);  
    Canvas.text("Weights:"+Weights.length,Pos.x-Cam.x,Pos.y-Cam.y+20);
    Canvas.stroke(0);
    Canvas.strokeWeight(1);
    if(State>0){
        Canvas.fill(0,State*200,255);
    }else{
        Canvas.fill(-State*200,0,255);
    }
    Canvas.ellipse(Pos.x-Cam.x,Pos.y-Cam.y,15,15);
    for(int i=0;i<Inputs.length;i++){
      if(Inputs[i]>0){
        stroke(0,Inputs[i]*200,0);
      }else{
        stroke(-Inputs[i]*200,0,0);
      }
      Canvas.ellipse(Pos.x-Cam.x+i*10,Pos.y-Cam.y+13,6,6);
    }
  }
}
class Eye extends Point{
  Eye(PVector dPos,PVector dVel,float dMass){
     super(dPos,dVel,dMass);
  }
}
//class Logic extends Point{
//  float[]Weights;
//  float Bias;
//  float[]Inputs=new float[0];// All the Inputs given to node
//  float[]UncheckedIn;
//  String Activation;//"Relu", or "Sigmoid" 
//  int InputsUsed=0;
//  Logic(PVector dPos,PVector dVel,float dMass,float[]dWeights,float dBias,float[] Din){
//    super(dPos,dVel,dMass);
//    Weights=dWeights;
//    Bias=dBias;
//    UncheckedIn=Din;
//  }
//  void CalcLogic(){// Calculates the result of the node.
//    float out=0;
//    for(int i=0;i<Inputs.length;i++){
//      if(i<Weights.length){
//        out+=Weights[i]*Inputs[i];
//      }
//    }
//    out+=Bias;
//    State=max(0,out);
//  }
//  Boolean CalcPossible(){// Checks if calcultion is possible.   Just a precaution
//    return true;//Fixed
//  }
//  void DrawLogic(PVector Cam,PGraphics Canvas){
//    Canvas.stroke(0);
//    Canvas.strokeWeight(1);
//    if(State>0){
//        stroke(0,State*200,0);
//      }else{
//        stroke(-State*200,0,0);
//      }
//    Canvas.ellipse(Pos.x-Cam.x,Pos.y-Cam.y,15,15);
//    for(int i=0;i<Inputs.length;i++){
//      if(Inputs[i]>0){
//        stroke(0,Inputs[i]*200,0);
//      }else{
//        stroke(-Inputs[i]*200,0,0);
//      }
//      Canvas.ellipse(Pos.x-Cam.x+i*10,Pos.y-Cam.y+13,6,6);
//    }
//  }
//}
class Muscle extends Smart{
  int APoiNum;
  int BPoiNum;
  Point A;
  Point B;
  float Force;
  float Length;
  float Damp;
  float[] StateA=new float[3];// The force,length, damp of the muscle in state true,
  float[] StateB=new float[3];// In False.
  Organism O;
 
  Muscle(int dAPoiNum,int dBPoiNum,float[] dStateA,float[] dStateB,float[]dWeights,float dBias,float[] dIn){
    super("Output",dWeights,dBias,dIn);
    APoiNum= dAPoiNum; BPoiNum= dBPoiNum;
    StateA=dStateA;
    StateB=dStateB;
  }
  void SetPois(){// Sets the Points after a organism is given.
    A=O.PList.get(APoiNum);
    B=O.PList.get(BPoiNum);
  }
  Muscle CloneMuscle(){// Returns Copy of the muscle.
    return new Muscle(APoiNum,BPoiNum,StateA,StateB,FArrayCopy(Weights),Bias,FArrayCopy(UncheckedIn));
  }
  void CalcForce(){// Sets the state,and updates the velocity of the two particles using spring physics.
    Force=FlLerp(StateA[0],StateB[0],State);Length=FlLerp(StateA[1],StateB[1],State);Damp=FlLerp(StateA[2],StateB[2],State);
    PVector Dist=new PVector(B.Pos.x-A.Pos.x,B.Pos.y-A.Pos.y);
    float Len=sqrt(Dist.x*Dist.x+Dist.y*Dist.y);
    //PVector NDist=PVextend(Dist,1.0/Len);
    A.Vel=PVDivide(A.Vel,Dist);
    B.Vel=PVDivide(B.Vel,Dist);
    
    PVector Slide=PVextend(PVadd(PVextend(A.Vel,A.Mass),PVextend(B.Vel,B.Mass)),1.0/(A.Mass+B.Mass));

    A.Vel=PVadd(A.Vel,new PVector((1-Length/Len)*Force/A.Mass,0));
   
    A.Vel.x-=Slide.x;
    A.Vel.x*=Damp;
    A.Vel.x+=Slide.x;
    
    B.Vel=PVadd(B.Vel,new PVector(-(1-Length/Len)*Force/B.Mass,0));

    B.Vel.x-=Slide.x;
    B.Vel.x*=Damp;
    B.Vel.x+=Slide.x;
    
    A.Vel=PVMult(A.Vel,Dist);
    B.Vel=PVMult(B.Vel,Dist);
  }  
  PVector Middle(){//Returns middle of points.
    return new PVector((A.Pos.x+B.Pos.x)/2,(A.Pos.y+B.Pos.y)/2);
  }
  void DrawM(PVector Cam ,PGraphics Canvas){// Draws Muscle.
    Force=FlLerp(StateA[0],StateB[0],State);
    Canvas.stroke(0,0,0,(Force/(0.5))*255);
    Canvas.strokeWeight(8);
    Canvas.line(A.Pos.x-Cam.x,A.Pos.y-Cam.y,B.Pos.x-Cam.x,B.Pos.y-Cam.y);
    if(State>0){
      Canvas.fill(0,State*200,255);
    }else{
      Canvas.fill(-State*200,0,255);
    }
    Canvas.strokeWeight(2);
    Canvas.text("State:"+State,Middle().x-Cam.x,Middle().y-Cam.y);
    for(int i=0;i<Inputs.length;i++){
      Canvas.text("Input "+i+" :"+Inputs[i],Middle().x-Cam.x,Middle().y-Cam.y+10+i*15);
    }
  }
}
class Neuron{
  int IPoiNum;
  boolean Final;  // Final means it goes into a muscle  
  int EPoiNum;
  int Delay;
  Smart I;
  Smart O;
  Organism C;
 float[] StateList=new float[2*60];// List of states over time (2 seconds)
  Neuron(int dIPoiNum,boolean dFinal,int dEPoiNum,int dDelay){
    IPoiNum=dIPoiNum; Final=dFinal; EPoiNum=dEPoiNum; Delay=dDelay;
  }
  
  void SetPois(){//Sets up Points and muscles given a organism
    I=(Smart)C.PList.get(IPoiNum);
    if(Final){
      O=(Smart)C.MList.get(EPoiNum);
    }else{
      O=(Smart)C.PList.get(EPoiNum);
    }
    for(int i=0;i<StateList.length;i++){StateList[i]=0;}
  }
  Neuron CloneNeuron(){// Returns copy of neuron.
    return new Neuron(IPoiNum,Final,EPoiNum,Delay);
  }
  void DrawNeuLine(PVector Pa,PVector Pb,PGraphics Canvas){
    PVector line= PVextend(PVadd(Pb,PVextend(Pa,-1)),1/float(Delay+1));
    Canvas.strokeWeight(2);
    for(int I=0;I<Delay+1;I++){
      float val=StateList[Delay+1-I];
      if(val>0){
        Canvas.stroke(0,val*200,255);
      }else{
        Canvas.stroke(-val*200,0,255);
      }
      Canvas.line(Pa.x,Pa.y,Pa.x+line.x*(Delay+1-I),Pa.y+line.y*(Delay+1-I));
    }
  }
  void DrawNeuron(PVector Cam, PGraphics Canvas){// Draws neuron.
    Canvas.strokeWeight(2);
    Canvas.stroke(255,0,0);
    if(Final==false){
      DrawNeuLine(PVadd(((Point)I).Pos,PVminus(Cam)),PVadd(((Point)O).Pos,PVminus(Cam)),Canvas);
    }else{
      DrawNeuLine(PVadd(((Point)I).Pos,PVminus(Cam)),PVadd(((Muscle)O).Middle(),PVminus(Cam)),Canvas);
    }
  }
}
class Barrier{// Class for barr
  PVector Corner;
  PVector Base;
  
  float Bounce;
  float Slide;
  Barrier(PVector DCorner,PVector DBase,float DBounce,float DSlide){
    Corner=DCorner; Base=DBase; Bounce= DBounce; Slide = DSlide;
  }
  Barrier CloneBarrier(){
    return new Barrier(Corner,Base,Bounce,Slide);
  }
  boolean CollidesGiven(Point Po,PVector Posr,PVector Nextr){// Checks if a Point is going to collide this frame.
    return (((Posr.y>0)&&(Nextr.y<0))||((Posr.y<0)&&(Nextr.y>0))
    ||((Posr.y==0)&&(Nextr.y>0))||((Nextr.y==0)&&(Posr.y>0))
    ||((Posr.y==0)&&(Nextr.y==0)))&&
    (BetweenBarrier(Po,Posr,Nextr));
  }
  boolean Collides(Point Po){
    PVector Posr=PVDivide(PVadd(Po.Pos,PVextend(Corner,-1)),Base);
    PVector Nextr=PVDivide(PVadd(Po.NextPos(),PVextend(Corner,-1)),Base);
    return CollidesGiven(Po,Posr,Nextr);
  }
  boolean BetweenBarrier(Point Po,PVector Posr,PVector Nextr){// checks if the Point is in the middle
    //PVector Posr=PVDivide(PVadd(Po.Pos,PVextend(Corner,-1)),Base);
    //PVector Nextr=PVDivide(PVadd(Po.NextPos(),PVextend(Corner,-1)),Base);
    return ((Posr.x>=0)&&(Posr.x<=1))||((Nextr.x>=0)&&(Nextr.x<=1));
  }
  
  boolean Rests(Point Po){ // Checks if a point has stopped bouncing and is stable
    //Point PoS= new Point(Po.Pos,Po.Vel,Po.Mass);
    //PoS.Acc=Po.Acc;
    //boolean Rest=false;
    //if(Collides(PoS)){
    //  BouncePoi(PoS);
    //  if(Collides(PoS)){
    //    Rest=true;
    //  }
    //}
    print("Checks for rest now, fix pls");
    return false;
  }
  
  void BouncePoi(Point Po,PVector Rvel,PVector RAcc){// Applies bouncy physics
    //PVector Rvel=PVDivide(Po.Vel,Base);
    //PVector RAcc=PVDivide(Po.Acc,Base);
    RAcc.x*=1+Slide*(Rvel.y+RAcc.y); 
    Rvel.y*=-Bounce;
    Rvel.x*=Slide;
    Po.Vel=PVMult(Rvel,Base);
    Po.Acc=PVMult(RAcc,Base); 
  }
  void StablisePoi(Point Po, PVector RVel,PVector RAcc){// Stableises point, stops fallthrough
    //PVector RVel=PVDivide(Po.Vel,Base);
    RVel.y=0;
    Po.Vel=PVMult(RVel,Base); 
    
    //PVector RAcc=PVDivide(Po.Acc,Base);
    RAcc.y=0;
    //Po.Acc=PVMult(RAcc,Base); 
  }
  void CheckColl(Point Po){// Checks and updates point according to bouncy.
    PVector Posr=PVDivide(PVadd(Po.Pos,PVextend(Corner,-1)),Base);
    PVector Nextr=PVDivide(PVadd(Po.NextPos(),PVextend(Corner,-1)),Base);
    PVector Rvel=PVDivide(Po.Vel,Base);
    PVector RAcc=PVDivide(Po.Acc,Base);
    if(CollidesGiven(Po,Posr,Nextr)){
      //BouncePoi(Po,Rvel,RAcc);
      RAcc.x*=1+Slide*(Rvel.y+RAcc.y); //Bounce the particle
      Rvel.y*=-Bounce;
      Rvel.x*=Slide;
  
      Nextr=PVadd(Posr,PVadd(Rvel,PVextend(RAcc,0.5)));
      if(CollidesGiven(Po,Posr,Nextr)){// Still collides
        Rvel.y=0;//Stablize
        RAcc.y=0;
      }
    }
    Po.Vel=PVMult(Rvel,Base);
    Po.Acc=PVMult(RAcc,Base); 
  }
  boolean WithinBarr(Point P){// checks if Point is under the barrier
    return (PVDivide(PVadd(P.Pos,PVextend(Corner,-1)),Base).y>0)
    &&(FLtween(Corner.x,Base.x+Corner.x,P.Pos.x));
  }
  void DrawBarr(PVector Cam,PGraphics Canvas){
    Canvas.stroke(255);
    Canvas.fill(255);
    Canvas.triangle(Corner.x-Cam.x,Corner.y-Cam.y,Corner.x+Base.x-Cam.x,Corner.y+Base.y-Cam.y,Corner.x-Cam.x,height);
    Canvas.triangle(Corner.x-Cam.x,height,Corner.x+Base.x-Cam.x,height,Corner.x+Base.x-Cam.x,Corner.y+Base.y-Cam.y);
    Canvas.stroke(0);
    Canvas.line(Corner.x-Cam.x,Corner.y-Cam.y,Corner.x+Base.x-Cam.x,Corner.y+Base.y-Cam.y);
  }
}