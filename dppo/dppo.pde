class Player{
  PVector Pos;
  PVector Vel;
  PVector Acc=new PVector(0,1);
  Player(PVector dP,PVector dV){
    Pos=dP; Vel=dV;
  }
  PVector nextPos(){
    return PVadd(Pos,PVadd(Vel,PVmult(Acc,0.5)));
  }
  void CheckInput(){
  Acc.set(0,2);
    if(checkforPress(new input(119,87))){//up
      Acc.y-=3;
    }if(checkforPress(new input(100,68))){//right
      Acc.x+=.5;
    }if(checkforPress(new input(115,83))){//down
      Acc.y+=3;
    }if(checkforPress(new input(97,65))){//left
      Acc.x-=.5;
    } 
  }
  void UpdatePos(){
    text(PVstring(Pos)+"  +  "+PVstring(Vel)+"   +   "
    +PVstring(PVmult(Acc,0.5))+"  ==>" +PVstring(nextPos()),Pos.x-20,Pos.y+50);
    Pos=nextPos();
    Vel=PVadd(Vel,Acc);
    //text(PVsetmag(Acc,PVdist(Acc)/2).x,10,40);
  }
  void Display(){
    ellipse(Pos.x,Pos.y,3,3);
    line(Pos.x,Pos.y,nextPos().x,nextPos().y);
  }  
}
PVector Pn=new PVector(10,10,10);
class Barrier{
  PVector Pa;
  PVector Pb;
 
  Barrier(PVector dA,PVector dB){
   Pa=dA; Pb=dB;
  }
  float elas=.8;
  float frict=1;
  
  boolean sideUP=true;
  
  PVector StrCoord(PVector P){
    return PVcoordmod(P,PVsetmag(new PVector(Pb.x-Pa.x,Pb.y-Pa.y),1),PVsetmag(new PVector(-Pb.y+Pa.y,Pb.x-Pa.x),1));
  }
  PVector SetCoord(PVector P){
    return PVcoordchange(P,PVsetmag(new PVector(Pb.x-Pa.x,Pb.y-Pa.y),1),PVsetmag(new PVector(-Pb.y+Pa.y,Pb.x-Pa.x),1));
  }
  boolean Colliding(){
    return ((sideUP)&&((StrCoord(P.nextPos()).y>=StrCoord(Pa).y))&&(StrCoord(P.Pos).y<=StrCoord(Pa).y))||
    ((sideUP==false)&&((StrCoord(P.nextPos()).y<=StrCoord(Pa).y))&&(StrCoord(P.Pos).y>=StrCoord(Pa).y));
   // ((sideUP==false)&&((StrCoord(P.nextPos()).y>=StrCoord(Pb).y)));
    
    //((sideUP)&&(((P.nextPos().y>Pb.y)&&(P.Pos.y<=Pb.y))))||
     // ((sideUP==false)&&(((P.nextPos().y<Pb.y)&&(P.Pos.y>=Pb.y))));
  }
  void CheckCollide(Player P){
    text(PVstring(StrCoord(Pa)),10,110);
    text(PVstring(StrCoord(Pb)),10,120);
     text("X THING "+PVstring(new PVector(Pb.x-Pa.x,Pb.y-Pa.y)),10,130);
     text("Y THING "+PVstring(new PVector(-Pb.y+Pa.y,Pb.x-Pa.x)),10,140);
     
      text(PVstring(P.Pos)+"  "+PVstring(StrCoord(P.Pos)),10,150);
      text(PVstring(P.Vel)+"  "+PVstring(StrCoord(P.Vel)),10,160);
      text(PVstring(new PVector(mouseX,mouseY)),10,180);
      text(PVstring(SetCoord(StrCoord(new PVector(mouseX,mouseY)))),10,190);
    //text(PVstring(StrCoord(Pb)),10,120);
    if(Colliding()){
      //P.Pos=PVmult(P.Pos,0.5);//StrCoord(P.Pos);
      P.Pos=StrCoord(P.Pos);
      P.Vel=StrCoord(P.Vel);
     
      P.Pos.y=StrCoord(Pa).y;
      P.Vel.y*=-elas;
      P.Vel.x*=frict;
      if(Colliding()){
        text( "what",P.Pos.x,P.Pos.y-22);
        P.Acc=StrCoord(P.Acc);
        P.Acc.y=0;
        P.Vel.y=0;
        P.Acc=SetCoord(P.Acc);
      }
      P.Pos=SetCoord(P.Pos);
      P.Vel=SetCoord(P.Vel);
      
    }
  }
  void DisplayB(){
    line(Pa.x,Pa.y,Pb.x,Pb.y);
    if(sideUP){
    line((Pa.x+Pb.x)/2,(Pa.y+Pb.y)/2,
    (Pa.x+Pb.x)/2+PVsetmag(PVrotate(PVadd(Pa,PVmult(Pb,-1)),PI/2),10).x,
    (Pa.y+Pb.y)/2+PVsetmag(PVrotate(PVadd(Pa,PVmult(Pb,-1)),PI/2),10).y);
    }else{
          line((Pa.x+Pb.x)/2,(Pa.y+Pb.y)/2,
    (Pa.x+Pb.x)/2+PVsetmag(PVrotate(PVadd(Pa,PVmult(Pb,-1)),-PI/2),10).x,
    (Pa.y+Pb.y)/2+PVsetmag(PVrotate(PVadd(Pa,PVmult(Pb,-1)),-PI/2),10).y);
    }
  }
}
/*
    P.Pos=PVcoordmod(P.Pos,new PVector(Pb.x-Pa.x,Pb.y-Pa.y),new PVector(-Pb.y+Pa.y,Pb.x-Pa.x));
    P.Vel=PVcoordmod(P.Vel,new PVector(Pb.x-Pa.x,Pb.y-Pa.y),new PVector(-Pb.y+Pa.y,Pb.x-Pa.x));
    P.Acc=PVcoordmod(P.Acc,new PVector(Pb.x-Pa.x,Pb.y-Pa.y),new PVector(-Pb.y+Pa.y,Pb.x-Pa.x));
    if((FLtween(P.Pos.y-PVadd(P.nextPos(),PVmult(P.Pos,0.01)).y,P.nextPos().y,
    PVcoordmod(Pa,new PVector(Pb.x-Pa.x,Pb.y-Pa.y),new PVector(-Pb.y+Pa.y,Pb.x-Pa.x)).y))){
      text("hit  x-"+P.Pos.x+" y-"+P.Pos.y+ "   x-"+P.Vel.x+" y-"+P.Vel.y,P.Pos.x,P.Pos.y-2);
      P.Pos.y=PVcoordmod(Pa,new PVector(Pb.x-Pa.x,Pb.y-Pa.y),new PVector(-Pb.y+Pa.y,Pb.x-Pa.x)).y;
      P.Vel.y*=-elas;
      P.Vel.x*=frict;
      if(FLtween(P.Pos.y-PVadd(P.nextPos(),PVmult(P.Pos,0.01)).y,P.nextPos().y,Pa.y)){
        P.Acc.y=0;
        P.Vel.y=0;
      }
    }
       
     P.Pos=PVcoordchange(P.Pos,new PVector(Pb.x-Pa.x,Pb.y-Pa.y),new PVector(-Pb.y+Pa.y,Pb.x-Pa.x));
    P.Vel=PVcoordchange(P.Vel,new PVector(Pb.x-Pa.x,Pb.y-Pa.y),new PVector(-Pb.y+Pa.y,Pb.x-Pa.x));
    P.Acc=PVcoordchange(P.Acc,new PVector(Pb.x-Pa.x,Pb.y-Pa.y),new PVector(-Pb.y+Pa.y,Pb.x-Pa.x));
*/
Player P=new Player(new PVector(200,100),new PVector(0,0));
Barrier B=new Barrier(new PVector(10,300),new PVector(400,300));
void setup(){
    frameRate(60);
    size(640, 360);
    keysPressed.add(new input(32,32));
}
float time=0;
void draw(){
  time++;
  background(160,190,255); 
  stroke(0);
  fill(0);
  for(int i=0;i<keysPressed.size();i++){
    text(keysPressed.get(i).keynum+"  "+keysPressed.get(i).keyCodenum,10,i*10+10);
  }
  
 /* POS.x=mouseX-100;
  POS.y=mouseY-100;
  line(100,100,BBB.x+100,BBB.y+100);
  line(100,100,POS.x+100,POS.y+100);
  text(PVstring(POS),100,110);
  text(PVstring(BBB),100,120);
  text(PVstring(PoiIntersect(PV(),BBB,POS,PVadd(POS,YYY))),100,130);
  ellipse(PoiIntersect(PV(),BBB,POS,PVadd(POS,YYY)).x+100,
  PoiIntersect(PV(),BBB,POS,PVadd(POS,YYY)).y+100,3,3);
  text(PVstring(PVcoordmod(POS,BBB,YYY)),100,140);
  text(PVstring(PVcoordchange(PVcoordmod(POS,BBB,YYY),BBB,YYY)),100,150);*/
  
    //S.SetBarriers();
  //S.UpdateShape();
  //S.DisplayBarriers();
  P.CheckInput();
  B.CheckCollide(P);
  
  P.UpdatePos();
  P.Display();
  B.DisplayB();
  

}