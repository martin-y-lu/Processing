class Shape{
  PVector defPos;
  PVector Vel;
  float Ang;
  float AngVel;
  ArrayList<Barrier> TempBarriers=new ArrayList<Barrier>();
  Shape(PVector DdefPos,PVector DVel,float DAng,float DAngVel){
    defPos=DdefPos; Vel=DVel; Ang= DAng; AngVel=DAngVel;
  }
  ArrayList<Barrier> BarrierList=new ArrayList<Barrier>();

  /*void SetBarriers(){
    BarrierList.clear();
    for(int I=0;I<TempBarriers.size();I++){
      Barrier dn=TempBarriers.get(I);
      Barrier dB= new Barrier(new PVector(),new PVector());
      dB.Pa.x=PVrotate(dn.Pa,Ang).x+defPos.x;
      dB.Pa.y=PVrotate(dn.Pa,Ang).y+defPos.y;
      dB.Pb.x=PVrotate(dn.Pb,Ang).x+defPos.x;
      dB.Pb.y=PVrotate(dn.Pb,Ang).y+defPos.y;
      BarrierList.add(dB);
    }
  }*/

  void UpdateShape(){
    defPos.add(Vel);
    Ang+=AngVel;
    while(Ang>2*PI){
      Ang-=2*PI;
    }
  }
  PVector PoiVelocity(PVector Po){
  return new PVector(cos(atan2(Po.x,Po.y)+Ang)*PVmag(Po),
  -sin(atan2(Po.x,Po.y)+Ang)*PVmag(Po));
  }
  void DisplayBarriers(){
    for(int I=0;I<BarrierList.size();I++){
       Barrier sB= BarrierList.get(I);
       sB.DisplayB();
       Barrier dB= TempBarriers.get(I);
       line(sB.Pa.x,sB.Pa.y,sB.Pa.x+PoiVelocity(dB.Pa).x*5,sB.Pa.y+PoiVelocity(dB.Pa).y*5);
    }
  }
}