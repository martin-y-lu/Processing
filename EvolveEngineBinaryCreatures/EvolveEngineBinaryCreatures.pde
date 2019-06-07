import java.util.*;
class Button{
  PVector Pos;
  PVector Size;
  String Text;
  Button(PVector DPos,PVector DSize,String DText){
    Pos=DPos; Size=DSize; Text=DText;
  }
  Boolean IsPressed(){
    return mousePressed&&IsIn();
  }
  Boolean IsIn(){
    return (PrevMouse==false)&&FLtween(Pos.x,Pos.x+Size.x,mouseX)&&FLtween(Pos.y,Pos.y+Size.y,mouseY);
  }
  void Display(color C){
    stroke(0);
    fill(C);
    rect(Pos.x,Pos.y,Size.x,Size.y);
    fill(0);
    text(Text,Pos.x+5,Pos.y+15);
  }
}
class Slider{
  PVector ScreenPos;
  String Text;
  float Pos=0;
  float Min;
  float Max;
  boolean Slide=false;
  Slider(PVector dScreenPos,String dText,float dMin,float dMax){
   ScreenPos=dScreenPos; Text= dText; Min=dMin; Max=dMax;
  }
  boolean Sliding(){
    return mousePressed&&(mouseX>Pos+ScreenPos.x)&&(mouseX<Pos+ScreenPos.x+90)
    &&(mouseY>ScreenPos.y-10)&&(mouseY<ScreenPos.y+20+10)&&(Pos>=Min)&&(Pos<=Max);
  }
  void ChangeText(String NewT){
    Text=NewT;
  }
  void CalcSlide(){
    if(Sliding()||Slide){
     Slide=true;
      Pos=mouseX-ScreenPos.x-45;
    }
    if(!mousePressed){
     Slide=false; 
    }
    if(Pos>Max){
       Pos=Max;
    }if(Pos<Min){
       Pos=Min;
    }
  }
  void Display(){
    fill(255);
    rect(ScreenPos.x+Pos,ScreenPos.y,80,20);
    fill(0);
    text(Text,ScreenPos.x+Pos+10,ScreenPos.y+15);
  }
}
class Camera{
 PVector CamPos;
 float Zoom;
 Camera(PVector dCamPos,float dZoom){
  CamPos=dCamPos; Zoom=dZoom;
 }
 
 PVector RealToScreen(PVector RealPos){
  return new PVector(RealToScreenX(RealPos.x),RealToScreenY(RealPos.y));
 }
 float RealToScreenX(float RealPosX){
   return Zoom*(RealPosX-CamPos.x);
 }
 float RealToScreenY(float RealPosY){
   return Zoom*(RealPosY-CamPos.y);
 }
 PVector ScreenToReal(PVector ScreenPos){
   return new PVector(ScreenPos.x/Zoom+CamPos.x,ScreenPos.y/Zoom+CamPos.y);
 }
}
Organism Test= new Organism();
Enviroment Env= new Enviroment();

int EnvNumber=0;
ArrayList<Enviroment> PastEnvs=new ArrayList<Enviroment>();
void ResetEnv(){
  if(EnvNumber!=PastEnvs.size()-1){
    EnvNumber=PastEnvs.size()-1;
    //Env=PastEnvs.get(EnvNumber);
  }
}
void SetEnv(int Number){
  EnvNumber=Number;
  Env=PastEnvs.get(EnvNumber).CloneEnv();
  Env.ReshiftToTest();
}
void AddEnv(Enviroment NewEnv){
  int ArchivePoint=1;
  PastEnvs.add(NewEnv.CloneEnv());
  EnvNumber=PastEnvs.size()-1;
  int ArchInd=PastEnvs.size()-1-ArchivePoint;
  if(ArchInd>=0){
    PastEnvs.set(ArchInd,PastEnvs.get(ArchInd).StoreEnv());
  }
  //PastEnvs.get(EnvNumber).ReshiftToTest();
}

int NUMCREATURES=3000;
Camera Cam=new Camera(new PVector(-50,-600),0.9);
//PVector Cam= new PVector(0,0);
float Zoom=1;// 1 is normal, 2 is zoom in factor of 2 ect
float Energy=0;
boolean PrevMouse=false;
int LastTime = 0;
PGraphics MainScreen;
PGraphics HistoGram;
PGraphics SpeciesFreq;
PGraphics BestOrg;
PGraphics MedianOrg;
PGraphics WorstOrg;

PGraphics OrgGraphic;
void setup(){
  randomSeed(19);
  //Seeds with interesting stuffs
  //size(1280, 720);
  fullScreen();
  //stroke(0); 
  //strokeWeight(3);
  frameRate(60);
  HistoGram=createGraphics(400,200,JAVA2D);
  SpeciesFreq=createGraphics(510,260,JAVA2D);//createGraphics(510,60);
  WorstOrg=createGraphics(200,200,JAVA2D);
  MedianOrg=createGraphics(200,200,JAVA2D);
  BestOrg=createGraphics(200,200,JAVA2D);
  MainScreen=createGraphics(width,height,JAVA2D);
  OrgGraphic=createGraphics(width,height,JAVA2D);
  OrgGraphic.beginDraw(); 
  //OrgGraphic.background(255,0); 
  //OrgGraphic.endDraw();

  
  
  Env.SetSummonArea(new PVector(0,100),new PVector(200,200));
  Env.SetLiveArea(new PVector(-1000,-1000),new PVector(20000,1800));
  Env.OList.add(new Organism());
  Env.OList.get(0).PList.add(new Logic(new PVector(100,130),new PVector(0,0),1,0.1,0,new boolean[]{true,true}));
  Env.OList.get(0).PList.add(new Logic(new PVector(200,130),new PVector(0,0),5,0.1,2,new boolean[]{}));
  Env.OList.get(0).PList.add(new Point(new PVector(150,80),new PVector(0,0),5,0.1));
  Env.OList.get(0).PList.add(new Eye(new PVector(150,130),new PVector(0,0),5,0.1));
  //Env.OList.get(0).PList.add(new Eye(new PVector(150,130),new PVector(0,0),8));
 // Env.OList.get(0).PList.add(new Logic(new PVector(30,130),new PVector(0,0),1,0,new boolean[]{true}));
  Env.OList.get(0).MList.add(new Muscle(0,1,.4,110,.2,1,160,.2));
  Env.OList.get(0).MList.add(new Muscle(1,2,.4,110,.2,1,160,.2));
  Env.OList.get(0).MList.add(new Muscle(2,0,.4,110,.2,1,160,.2));
  Env.OList.get(0).MList.add(new Muscle(2,3,1,110,.2,1,160,.2));
  Env.OList.get(0).NList.add(new Neuron(3,false,0,15));
  //Env.OList.get(0).NList.add(new Neuron(4,false,0,30));
  Env.OList.get(0).NList.add(new Neuron(0,false,1,15));
  Env.OList.get(0).NList.add(new Neuron(1,true,3,30));
  Env.OList.get(0).SetVars();
  
  Env.OList.add(new Organism());
  Env.OList.get(1).PList.add(new Logic(new PVector(150,81),new PVector(0,0),1,0.5,1,new boolean[]{}));
  Env.OList.get(1).PList.add(new Logic(new PVector(151,80),new PVector(0,0),1,0.5,1,new boolean[]{}));
  Env.OList.get(1).PList.add(new Logic(new PVector(150,82),new PVector(0,0),1,0.5,1,new boolean[]{}));
  Env.OList.get(1).MList.add(new Muscle(0,1,.4,110,.2,1,160,.2));
  Env.OList.get(1).MList.add(new Muscle(1,2,.4,110,.2,1,160,.2));
  Env.OList.get(1).MList.add(new Muscle(2,0,.4,110,.2,1,160,.2));
  Env.OList.get(1).NList.add(new Neuron(0,true,1,15)); 
  Env.OList.get(1).NList.add(new Neuron(1,true,2,15));
  Env.OList.get(1).NList.add(new Neuron(2,true,0,15));
  Env.OList.get(1).SetVars();
  
  Env.OList.add(new Organism());
  Env.OList.get(2).PList.add(new Point(new PVector(150,0-500),new PVector(0,0),1,0.1));
  Env.OList.get(2).PList.add(new Point(new PVector(0,0-500),new PVector(0,0),1,0.1));
  Env.OList.get(2).PList.add(new Point(new PVector(0,0-500),new PVector(0,0),1,0.1));
  Env.OList.get(2).PList.add(new Point(new PVector(0,150-500),new PVector(0,0),1,0.1));
  Env.OList.get(2).MList.add(new Muscle(0,1,.4,110,.2,1,160,.2));
  Env.OList.get(2).MList.add(new Muscle(2,3,.4,110,.2,1,160,.2));
  Env.OList.get(2).SetVars();
  //Env.GenNewOrg();
 
  Env.BList.add(new Barrier(new PVector(-2000,300),new PVector(2000+20000,0),.2,.05));
 
  //int init=600;
  //int size=500;
  //int gap=100;
  // Env.BList.add(new Barrier(new PVector(-2000,300),new PVector(2000+init,0),.2,.05));
  //Env.BList.add(new Barrier(new PVector(init,300),new PVector(0,500),.2,.05));
  //while( init<8000){
  //  init+=gap;
  //  Env.BList.add(new Barrier(new PVector(init,300),new PVector(size,0),.2,.05));
  //   Env.BList.add(new Barrier(new PVector(init,300+500),new PVector(0,-500),.2,.05));
  //   Env.BList.add(new Barrier(new PVector(init+size,300),new PVector(0,500),.2,.05));
  //  init+=size;
  //  gap+=50;
  //}
  
  Env.GenNewOrg();
  
  Env.SetVars();
  Env.ShiftToTest(0);
  Env.ShiftToTest(1);
  Env.ShiftToTest(2);
  Env.ShiftToTest(3);
  for(int i=0;i<500;i++){
   //print(abs(round(randomGaussian())));
   //print(randomGaussian());
  }
  //FillHisto(HistoGram);
  //Env.QuickGen();
  //Env.SetInfo();
  //FillHisto(HistoGram);
  //AddEnv(Env);
}

int ScreenNumber=0; //0 is MainScreen, 1 is OverviewScreen
int CurrentTestDisplay=0;
int CurrentEnv=0;
int PlayBackSpeed=1;
boolean ALAP=false;
boolean FollowOrg=false;
boolean OverviewOrgs=true;

Slider OrgSlide=new Slider(new PVector(100,100),"Org-",0,10);
Slider GenSlide=new Slider(new PVector(100,230),"Gen-",0,10);

void RunMainScreen(PGraphics MainScreen,PGraphics HistoGram,PGraphics SpeciesFreq,PGraphics BestOrg,PGraphics MedianOrg,PGraphics WorstOrg){
  //_____________________________________________________________________________________________
  // Main screen draw, enviroment draw & Update
  MainScreen.beginDraw();
  MainScreen.background(255,255,255);
  Env.DrawBackground(Cam,MainScreen);

  //Env.UpdateOrg(0);
  // Env.TestList.get(0).PList.get(4).Pos=new PVector(mouseX+Cam.x,mouseY+Cam.y);
  if(CurrentTestDisplay>=Env.TestList.size()){
    CurrentTestDisplay=Env.TestList.size()-1;
  }
  for(int i=0;i<PlayBackSpeed;i++){
     Env.TestList.get(CurrentTestDisplay).RunTest();
  }
  MainScreen.textSize(12);
  MainScreen.text("Time-"+Env.TestList.get(CurrentTestDisplay).time,20,50);
  MainScreen.text("delta Time-"+(millis()-LastTime),width-100,20);
  if(Env.TestList.get(CurrentTestDisplay).Finalized){
    MainScreen.text("Fitness-"+Env.TestList.get(CurrentTestDisplay).Fitness,20,60);
  }
  
  MainScreen.fill(140,170,255);
  MainScreen.rect(Cam.RealToScreenX(Env.SummonPos.x),Cam.RealToScreenY(Env.SummonPos.y),Env.SummonRect.x*Cam.Zoom,Env.SummonRect.y*Cam.Zoom);
  Env.DrawGround(Cam,MainScreen);
  if(OverviewOrgs){
    for(int i=0;i<Env.OList.size();i+=ceil(Env.OList.size()/10.0)){//10.0
      OrgGraphic.beginDraw();
      OrgGraphic.background(255,0);
      Env.DrawOrg(i,Cam,OrgGraphic);
      PVector OrgCenter=Env.TestList.get(i).O.CenterOfOrg();
      OrgGraphic.fill(SpeciesColor(Env.TestList.get(i).O.SpeciesNumber()));
      OrgGraphic.stroke(0);
      OrgGraphic.triangle(Cam.RealToScreenX(OrgCenter.x),100,Cam.RealToScreenX(OrgCenter.x)-20,50,Cam.RealToScreenX(OrgCenter.x)+20,50);
      OrgGraphic.endDraw();
      //OrgImg=OrgGraphic.get();
      MainScreen.tint(255,100);
      MainScreen.image(OrgGraphic,0,0);
    }
  }
  MainScreen.fill(255);
  MainScreen.stroke(0);
  MainScreen.strokeWeight(2);
  PVector OrgCenter=Env.TestList.get(CurrentTestDisplay).O.CenterOfOrg();
  MainScreen.triangle(Cam.RealToScreenX(OrgCenter.x),100,Cam.RealToScreenX(OrgCenter.x)-20,50,Cam.RealToScreenX(OrgCenter.x)+20,50);
  Env.DrawOrg(CurrentTestDisplay,Cam,MainScreen);// Draw current organism.
  MainScreen.textSize(12);
  MainScreen.fill(0);
  MainScreen.text(mouseX+" "+mouseY,10,10);
  MainScreen.text("Camera-"+ Cam.CamPos.x+" "+Cam.CamPos.y+" Zoom-"+Cam.Zoom,10,20);
  MainScreen.text("Energy-"+Energy,10,30);
  if(Cam.Zoom>0.6){
    MainScreen.textSize(24);
  }else{
    MainScreen.textSize(24*Cam.Zoom/0.6);
  }
  for(float i=Cam.CamPos.x-100;i<Cam.CamPos.x+width/Cam.Zoom;i+=100){
    i= ceil(i/100.0)*100; //round up 100
    MainScreen.line(Cam.RealToScreenX(i),height,Cam.RealToScreenX(i),height-50);
    MainScreen.text(floor(i/100),Cam.RealToScreenX(i)+5,height-30);
  }
  MainScreen.endDraw();
  //tint(255,255);
  image(MainScreen,0,0);
  
  
  //_____________________________________________________________________________________________
  //Draw HistoGram and Species Percent graphs
  Button DrawHisto= new Button(new PVector(280+80,10),new PVector(60,20),"Graphs");
  DrawHisto.Display(255);
  if(DrawHisto.IsPressed()){  
    ResetEnv();
    Env.SetInfo();
    FillSpeciesFreq(SpeciesFreq);
    FillHisto(HistoGram);
    //AddEnv(Env);
  }
  image(HistoGram, width-(1280-820), 30); 
  
  //SpeciesFreq.beginDraw();
  //SpeciesFreq.background(255);
  //FillSpeciesFreq(SpeciesFreq);
  //SpeciesFreq.endDraw();
  image(SpeciesFreq,100,260);
  //_____________________________________________________________________________________________
  //Best, Worst, and median creatures
  WorstOrg.beginDraw();
  WorstOrg.background(200,220,255);
  
  WorstOrg.stroke(0);
  WorstOrg.strokeWeight(3);
  WorstOrg.noFill();
  WorstOrg.rect(0,0,200,200);
  int worst=Env.OList.size()-1;
  PVector CenterOrg=Env.OList.get(worst).CenterOfOrg();
  Env.OList.get(worst).DrawO(new Camera(new PVector(CenterOrg.x-100,CenterOrg.y-100),1),WorstOrg);
  WorstOrg.endDraw();
  image(WorstOrg, width-(1280-820), 250,100,100); 
  
  MedianOrg.beginDraw();
  MedianOrg.background(200,220,255);
  MedianOrg.stroke(0);
  MedianOrg.strokeWeight(3);
  MedianOrg.noFill();
  MedianOrg.rect(0,0,200,200);
  int median=floor((float)Env.OList.size()/2.0);
  CenterOrg=Env.OList.get(median).CenterOfOrg();
  Env.OList.get(median).DrawO(new Camera(new PVector(CenterOrg.x-100,CenterOrg.y-100),1),MedianOrg);
  MedianOrg.endDraw();
  image(MedianOrg, width-(1280-970), 250,100,100); 
  
  
  BestOrg.beginDraw();
  BestOrg.background(200,220,255);
  
  BestOrg.stroke(0);
  BestOrg.strokeWeight(3);
  BestOrg.noFill();
  BestOrg.rect(0,0,200,200);
  CenterOrg=Env.OList.get(0).CenterOfOrg();
  Env.OList.get(0).DrawO(new Camera(new PVector(CenterOrg.x-100,CenterOrg.y-100),1),BestOrg);
  BestOrg.endDraw();
  image(BestOrg, width-(1280-1120), 250,100,100); 
  
  
  //_____________________________________________________________________________________________
  // Sliders
  fill(0);
  float OrgSlideDist=430.0/NUMCREATURES;
  OrgSlide.CalcSlide();
  if(OrgSlide.Pos/OrgSlideDist!=CurrentTestDisplay){
    if(OrgSlide.Sliding()){
      CurrentTestDisplay=round(OrgSlide.Pos/OrgSlideDist);
    }else{
      OrgSlide.Pos=CurrentTestDisplay*OrgSlideDist;
    }
  }
  OrgSlide.ChangeText("Org-"+CurrentTestDisplay);
  OrgSlide.Display();
  OrgSlide.Max=floor(Env.OList.size()*OrgSlideDist-1);
   
  float GenSlideDist=400/(PastEnvs.size()+1);
  GenSlide.CalcSlide();
  if(GenSlide.Pos/GenSlideDist!=EnvNumber){
    if(GenSlide.Sliding()){
      if(round(GenSlide.Pos/GenSlideDist)!=EnvNumber){
        int prevsize=Env.OList.size();
        SetEnv(round(GenSlide.Pos/GenSlideDist));
        CurrentTestDisplay=floor(CurrentTestDisplay*Env.OList.size()/prevsize);
        FillHisto(HistoGram);
      }
    }else{
      GenSlide.Pos=EnvNumber*GenSlideDist;
    }
  }
  GenSlide.ChangeText("Gen-"+EnvNumber);
  GenSlide.Display();
  GenSlide.Max=(PastEnvs.size()-1)*GenSlideDist;
  
  Button Center= new Button(new PVector(200,10),new PVector(60,20),"Center");
   Center.Display(255);
  if(Center.IsPressed()){
    Cam.CamPos=new PVector(0,0);
  }  
  Button Follow= new Button(new PVector(200+80,10),new PVector(60,20),"Follow");
  if(FollowOrg){
     Follow.Display(color(255,200,200));
     float FollowRate=0.1;
     PVector Target=PVadd(Env.TestList.get(CurrentTestDisplay).O.CenterOfOrg(),PVextend(new PVector(-width*3/4.0,-height*3/4.0),1.0/Cam.Zoom));
     Cam.CamPos= PVlerp(Cam.CamPos,Target,FollowRate);
  }else{
    Follow.Display(255);
  }
  //Follow.Display(255);
  if(Follow.IsPressed()){
    FollowOrg=!FollowOrg;
  }  
  Button Overview= new Button(new PVector(200+3*80,10),new PVector(60,20),"Overview");
  if(OverviewOrgs){
     Overview.Display(color(255,200,200));
  }else{
    Overview.Display(255);
  }
  if(Overview.IsPressed()){
    OverviewOrgs=!OverviewOrgs;
  }
  Button ZoomIn= new Button(new PVector(20,80),new PVector(20,20),"+");
  ZoomIn.Display(255);
  if(ZoomIn.IsPressed()){
    Cam.Zoom*=1.2;
  }
  Button ZoomOut= new Button(new PVector(50,80),new PVector(20,20),"-");
  ZoomOut.Display(255);
  if(ZoomOut.IsPressed()){
    Cam.Zoom/=1.2;
  }
  Button Up= new Button(new PVector(35,105),new PVector(20,20),"^");
  Up.Display(255);
  Button Left= new Button(new PVector(15,125),new PVector(20,20),"<");
  Left.Display(255);
  Button Right= new Button(new PVector(55,125),new PVector(20,20),">");
  Right.Display(255);
  Button Down= new Button(new PVector(35,145),new PVector(20,20),"v");
  Down.Display(255);
  float Step=12;
  if(Up.IsIn()){
    Cam.CamPos.y-=Step;
  }if(Down.IsIn()){
    Cam.CamPos.y+=Step;
  }if(Left.IsIn()){
    Cam.CamPos.x-=Step;
  }if(Right.IsIn()){
    Cam.CamPos.x+=Step;
  }
  
  textSize(30);
  text("Generation "+PastEnvs.size(),105,80);
  textSize(14);
  
  ///_____________________________________________________________________________________________
  //Panel buttons
  PVector PanelPos=new PVector(105,140);//new PVector(105,110);
  fill(255);
  rect(PanelPos.x-5,PanelPos.y,510,60);
  Button Previous= new Button(new PVector(PanelPos.x+15,PanelPos.y+30),new PVector(60,20),"Previous");
  if(CurrentTestDisplay>0){
     //new Button(new PVector(120,140),new PVector(60,20),"Previous").Display();
     Previous.Display(255);
    if(Previous.IsPressed()){
      CurrentTestDisplay--;
      Env.TestList.get(CurrentTestDisplay).Reset();
      println("Current Display Back one");
      //Env.TestList.remove(0);
      //Env.ShiftToTest(CurrentTestDisplay);
    }  
  }
  Button Next= new Button(new PVector(PanelPos.x+95,PanelPos.y+30),new PVector(60,20),"Next");
  if(CurrentTestDisplay<Env.TestList.size()-1){
    Next.Display(255);
    if(Next.IsPressed()){
      CurrentTestDisplay++;
      println("Current Display Forward one");
    }
    if(PlayBackSpeed!=1){
      if(Env.TestList.get(CurrentTestDisplay).Finalized){
        CurrentTestDisplay++;
        Env.TestList.get(CurrentTestDisplay).Reset();
      }
    }
  }
  fill(SpeciesColor(Env.OList.get(CurrentTestDisplay).SpeciesNumber()));//Glitcgung
  text("Current Species-"+SpeciesName(Env.OList.get(CurrentTestDisplay).SpeciesNumber()),PanelPos.x,PanelPos.y);
  text("Mutability-"+nf(Env.OList.get(CurrentTestDisplay).MuteAmount,1,2),190+PanelPos.x,PanelPos.y);
  text("Fitness-"+floor( Env.TestList.get(CurrentTestDisplay).EvaluateSkill()),300+PanelPos.x,PanelPos.y);
  text("Parent Fit-"+floor(Env.TestList.get(CurrentTestDisplay).ParentFitness),400+PanelPos.x,PanelPos.y);
  text("Shows- "+CurrentTestDisplay+"/"+Env.TestList.size(),PanelPos.x,PanelPos.y+20);
  Button ChangeSpeed= new Button(new PVector(PanelPos.x+95,PanelPos.y+55),new PVector(60,20),"");
  ChangeSpeed.Display(255);
  text("Speed "+PlayBackSpeed,PanelPos.x+100,PanelPos.y+55+15);
  if(ChangeSpeed.IsPressed()){
    PlayBackSpeed*=2;
    if(PlayBackSpeed>200){
      PlayBackSpeed=1;
    }
  }
  
  Button Regen=new Button(new PVector(PanelPos.x+95,PanelPos.y+5),new PVector(60,20),"Regen");
  Regen.Display(255);
  if(Regen.IsPressed()){
      //Env.OList.remove(2);
      for(int i=0; i<NUMCREATURES;i++){
        Env.GenNewOrg();
        Env.ShiftToTest(Env.OList.size()-1);
      }
  }
  //new Button(new PVector(200,115),new PVector(60,20),"Regen").Display();
  
  Button Restart=new Button(new PVector(175+PanelPos.x,PanelPos.y+5),new PVector(60,20),"Restart");
  Restart.Display(255);
  if(Restart.IsPressed()){
    //Env.GenNewOrg();
      //Env.ShiftToTest(Env.OList.size()-1);
      //Tester T=Env.TestList.get(CurrentTestDisplay);
      //T.Reset();
      Env.TestList.get(CurrentTestDisplay).Reset();
      //T=new Tester(Env.OList.get(CurrentTestDisplay).CloneOrganism(),Env,60*30);
      //T.E=Env;
      //T.O=Env.OList.get(CurrentTestDisplay).CloneOrganism();
      //T.O.E=Env;
      //T.RunTime=60*30;
      //T.SetTester();
      //T.Finalized=false;
    //Env.ShiftToTest(CurrentTestDisplay);
  }
  Button Mutate=new Button(new PVector(175+PanelPos.x,PanelPos.y+30),new PVector(60,20),"Mutate");
  Mutate.Display(255);
  if(Mutate.IsPressed()){
      Env.OList.get(CurrentTestDisplay).MutateOrg();
      Tester T=Env.TestList.get(CurrentTestDisplay);
      //T=new Tester(Env.OList.get(CurrentTestDisplay).CloneOrganism(),Env,60*30);
      T.E=Env;
      T.O=Env.OList.get(CurrentTestDisplay).CloneOrganism();
      T.O.E=Env;
      T.RunTime=60*30;
      T.SetTester();
      T.Finalized=false;
  }
  Button TestAll =new Button(new PVector(255+PanelPos.x,5+PanelPos.y),new PVector(60,20),"Test all");
  TestAll.Display(255);
  if(TestAll.IsPressed()||frameCount==2){
    Env.TestAll();
    print("Delta time after testall:"+(millis()-LastTime));
  }
  Button Sort =new Button(new PVector(255+PanelPos.x,30+PanelPos.y),new PVector(60,20),"Sort");
  Sort.Display(255);
  if(Sort.IsPressed()){
    Env.SortTests();
  }
  
  Button Reproduce =new Button(new PVector(335+PanelPos.x,5+PanelPos.y),new PVector(60,20),"Nextgen");
  Reproduce.Display(255);
  if(Reproduce.IsPressed()){
    ResetEnv();
    Env.Reproduce();
  }
  
  Button Trim =new Button(new PVector(335+PanelPos.x,30+PanelPos.y),new PVector(60,20),"Trim");
  Trim.Display(255);
  if(Trim.IsPressed()){
    ResetEnv();
    Env.Trim(0.6);
    Env.ReshiftToTest();
    //for(int i=0; i<Env.OList.size();i++){
    //  Env.ShiftToTest(i);
    //}
  }
  
  
   Button QuickGen =new Button(new PVector(415+PanelPos.x,PanelPos.y+5),new PVector(60,20),"FastGen");
  QuickGen.Display(255);
  if(QuickGen.IsPressed()||ALAP){
    ResetEnv();
    Env.QuickGen();
    Env.SetInfo();
    AddEnv(Env);
    FillSpeciesFreq(SpeciesFreq);
    FillHisto(HistoGram);
    print("Delta time after quick Gen:"+(millis()-LastTime));
    //Env.Trim(0.5);
    //Env.TestList.clear();
    //for(int i=0; i<Env.OList.size();i++){
    //  Env.ShiftToTest(i);
    //}
    PVector Target=PVadd(Env.TestList.get(CurrentTestDisplay).O.CenterOfOrg(),PVextend(new PVector(-width*3/4.0,-height*3/4.0),1.0/Cam.Zoom));
    Cam.CamPos=Target;
  }
  Button Alap =new Button(new PVector(415+PanelPos.x,30+PanelPos.y),new PVector(60,20),"ALAP");
  if(ALAP){
    Alap.Display(color(255,200,200));
  }else{
    Alap.Display(255);
  }
  if(Alap.IsPressed()){
    ALAP=!ALAP;
  }
  Button ScriptTest =new Button(new PVector(415+PanelPos.x,70+PanelPos.y),new PVector(60,20),"(SCRIPTY GARBAG)");
  ScriptTest.Display(255);
  if(ScriptTest.IsPressed()){
   // print("SCRIPTTEST- OLIst in PastEnvs "+PastEnvs.get(EnvNumber).OList.size());
   //Env.SetInfo();
   //print("Current enviroment, species abundance info says there are "+Env.SpeciesAbundanceInfo.size());
   //println("TestList size-"+Env.TestList.size());
   //println("CurrentTestDisplay-"+CurrentTestDisplay);
    //int NumOrganisms=5000;
    ////  Trim+ Power function distribution
    //float trim=0.4;
    //float Power=0.3;
    //float SurvFract=0.90;
    //float Multiplier=SurvFract*(Power+1)/pow(1-trim,Power+1);
    //int PrevSize=Env.OList.size()-1;
    //for(int i=0; i<PrevSize;i++){
    //  float rank=lerp(0,1-trim,1-(float)i/PrevSize);
    //  int numOffspring=round(randomGaussian()*0.5+Multiplier*pow(rank,Power));//abs(round(randomGaussian()*(pow(rank,2)*2.7)))+1;
    //  for(int j=0; j<numOffspring;j++){
    //    Organism MutatedClone=Env.OList.get(i).CloneOrganism();
    //    MutatedClone.E=Env;
    //    MutatedClone.MutateOrg();
    //    Env.OList.add(MutatedClone);
    //  }
    //}
    //int targSize=Env.OList.size()-PrevSize;
    //while(Env.OList.size()>targSize){
    //  Env.OList.remove(Env.OList.size()-1);
    //}
    //Env.ReshiftToTest();
    //print(Env.SpeciesAbundance());
    String[]Test={"1 10jdnjivnr","2 3ujdbkv","100 eifhr","345 zzzzzzzzzz", "0 aaaaaA"};
    Test=sort(Test);
    println(join(Test,", "));
    
  }
  
}
void draw(){
  if(ScreenNumber==0){
    RunMainScreen(MainScreen,HistoGram, SpeciesFreq, BestOrg, MedianOrg, WorstOrg);
  }else if(ScreenNumber==1){
  }
  PrevMouse=mousePressed;
  LastTime=millis();
}
void mouseClicked(){
  //Env.OList.get(2).MutateOrg();
  //Env.TestList.remove(0);
  ////Env.OList.remove(2);
  ////Env.GenNewOrg();
  //Env.ShiftToTest(2);
  if(ALAP&&!PrevMouse){
   ALAP=false;
  }
}