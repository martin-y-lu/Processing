class Enviroment{
  ArrayList<Barrier> BList= new ArrayList<Barrier>();
  ArrayList<Organism> OList= new ArrayList<Organism>();
  ArrayList<Tester> TestList= new ArrayList<Tester>();
  PVector SummonPos;
  PVector SummonRect;
  
  void SetVars(){// Sets all the E's in all orrganisms.
    for(int O=0;O<OList.size();O++){
      Organism Org=OList.get(O);
      Org.E=this;
    }
  }
  void ShiftToTest(int N){
    TestList.add(new Tester(OList.get(N).CloneOrganism(),this));
  }
  void SetSummonArea(PVector Pos,PVector Rect){
    SummonPos=Pos; SummonRect=Rect;
  }
  boolean AllFinalized(){
    boolean finals=false;
    for(int t=0;t<TestList.size();t++){
      finals=finals&&TestList.get(t).Finalized;
    }
    return finals;
  }
  void TestAll(){
    for(int t=0;t<TestList.size();t++){
      TestList.get(t).QuickRunTest();
    }
  }
  void MutateAll(){
    for(int O=0;O<OList.size();O++){
      Organism Org=OList.get(O);
      Org.MutateOrg();
    }
  }
  void Reproduce(){
    for(int L=0;L<=TestList.size()-2;L++){
      for(int M=0;M<=TestList.size()-L-2;M++){
        Tester One=TestList.get(M);
        Tester Two=TestList.get(M+1);
        if(One.Fitness>Two.Fitness){
        }
      }
    }
    
  }
  void GenNewOrg(){//Generates new Random Organism
    Organism O= new Organism();
    O.E=this;
    int NumPois=randomInt(3,6);
    for(int I=0;I<NumPois;I++){
      O.GenNewPoi();
    }
    int NumMusc=randomInt(2,NumPois*(NumPois-1)/2);
    for(int M=0;M<NumMusc;M++){
      O.GenNewMusc();
    }
    int NumNeu=randomInt(2,5);
    for(int N=0;N<NumNeu;N++){
      O.GenNewNeu();
    }
    OList.add(O);
  }
  Boolean InGround(Point P){// Checks if any Point P is within the ground in the Enviroment.
    boolean Under=false;
    for(int f=0;f<BList.size();f++){
      Barrier F=BList.get(f);
      Under=Under||F.WithinBarr(P);
    }
    return Under;
  }
  boolean MoreCalc(Point P){// Sees if any particles are colliding
    Boolean more=false;
    for(int o=0;o<BList.size();o++){
      Barrier B=BList.get(o);
      more=more||B.Collides(P);
    }
    return more;
  }
  int NumColliding(Point P){//number of particles colliding
    int coll=0;
    for(int o=0;o<BList.size();o++){
      Barrier B=BList.get(o);
      if(B.Collides(P)){
        coll++;
      }
    }
    return coll;
  }
  void DrawEnv(int N){// Draws ground and organisms.
    for(int f=0;f<BList.size();f++){
      BList.get(f).DrawBarr();
    }
    TestList.get(N).O.DrawO();
  }
}

class Tester{
  Organism O;
  Enviroment E;
  boolean Finalized=false;
  float Fitness;
  Tester(Organism dO,Enviroment dE){
    O=dO;
    E=dE;
    O.E=E;
    SetTester();
  }
  float time;
  void SetTester(){
    time=0;
  }
  void UpdateOrg(){// Updates positions, forces on Organism #N.
    O.CalcNeurons();
    O.UpdatePois();
  }
  boolean EndTest(){
    return time>60*20;
  }
  float EvaluateFitness(){
    return O.CenterOfOrg().x;
  }
  void RunTest(){
    if(Finalized==false){
      UpdateTest();
      UpdateOrg();
      if(EndTest()){
        Finalized=true;
        Fitness=EvaluateFitness();
      }
    }
  }
  void UpdateTest(){
    time++;
  }
  void QuickRunTest(){
    while(Finalized==false){
      RunTest();
    }
  }
}