PVector  PoiIntersect(PVector Paa,PVector Pab,PVector Pba,PVector Pbb){
  float slopePa=0;
  float yintPa=0;
  if((Paa.x-Pab.x==0)==false){
  slopePa=(Paa.y-Pab.y)/(Paa.x-Pab.x);
  yintPa=Paa.y-Paa.x*slopePa;
  }
  float slopePb=0;
  float yintPb=0;
  if((Pba.x-Pbb.x==0)==false){
      slopePb=(Pba.y-Pbb.y)/(Pba.x-Pbb.x);
      yintPb=Pba.y-Pba.x*slopePb;
  }
  
  PVector Intersect= new PVector(0,0);
  if(Paa.x-Pab.x==0){
    Intersect.set(Paa.x,Paa.x*slopePb+yintPb);
  }else if(Pba.x-Pbb.x==0){
    Intersect.set(Pba.x,Pba.x*slopePa+yintPa);
  }else{
  Intersect.x=(yintPb-yintPa)/(slopePa-slopePb);
  Intersect.y=slopePa*Intersect.x+yintPa;
  }

  return Intersect;
}
int DoesIntersect(PVector Paa,PVector Pab,PVector Pba,PVector Pbb){
  int does=0;  //0- yes ,1- never,2- everywhere
  float slopePa=(Paa.y-Pab.y)/(Paa.x-Pab.x);
  float yintPa=Paa.y-Paa.x*slopePa;
  float slopePb=(Pba.y-Pbb.y)/(Pba.x-Pbb.x);
  float yintPb=Pba.y-Pba.x*slopePb;
  if(slopePa==slopePb){
    if(yintPa==yintPb){
      does=2;
    }else{
      does=1;
    }
  }else{
    does=0;
  }
  return does;
}
boolean IntersectTween(PVector Paa,PVector Pab,PVector Pba,PVector Pbb){
  boolean Intersect=false;
  if(DoesIntersect(Paa,Pab,Pba,Pbb)==2){
    Intersect=true;
  }else if(DoesIntersect(Paa,Pab,Pba,Pbb)==1){
    Intersect=false;
  }else{
    if(FLtween(Paa.x,Pab.x,PoiIntersect(Paa,Pab,Pba,Pbb).x)&&FLtween(Pba.x,Pbb.x,PoiIntersect(Paa,Pab,Pba,Pbb).x)
    && FLtween(Paa.y,Pab.y,PoiIntersect(Paa,Pab,Pba,Pbb).y)&&FLtween(Pba.y,Pbb.y,PoiIntersect(Paa,Pab,Pba,Pbb).y)){
      Intersect=true;
    }else{
      Intersect=false;
    }
  }
  return Intersect;
}
PVector PVcoordmod(PVector A,PVector x,PVector y){
  PVector Intersect=PoiIntersect(PV(),x,A,PVadd(A,y));
  PVector Result= new PVector(Intersect.x/x.x,(A.x-Intersect.x)/y.x);
  if((x.x==0)){ 
    if(y.x==0){
      Result.set(Intersect.y/x.y,(A.y-Intersect.y)/y.y);
    }else{
      Result.set(Intersect.y/x.y,(A.x-Intersect.x)/y.x);
    }
  }else{
    if(y.x==0){
      Result.set(Intersect.x/x.x,(A.y-Intersect.y)/y.y);
    }else if(y.y==0){
      Result.set(Intersect.x/x.x,(A.x-Intersect.x)/y.x);
    }
    
  }
  return Result;
}
PVector PVcoordchange(PVector P,PVector x,PVector y){
   return new PVector(PVmult(x,P.x).x+PVmult(y,P.y).x,PVmult(x,P.x).y+PVmult(y,P.y).y);
}
boolean FLtween(float up,float down,float poi){
  return (((poi>=up)&&(poi<=down))||((poi<=up)&&(poi>=down)));
}
float PVmag(PVector Po){
  return dist(0,0,Po.x,Po.y);
}
float PVang(PVector Po){
  return atan2(Po.x,Po.y);
}
PVector PVrotate(PVector Po,float A){
  return new PVector(sin(PVang(Po)+A)*PVmag(Po),cos(PVang(Po)+A)*PVmag(Po));
}
PVector PVsetmag(PVector A,float mag){
  return PVmult(A,mag/PVmag(A));
}
PVector PVmult(PVector A, float mult){
  return new PVector(A.x*mult,A.y*mult);
}
PVector PVadd(PVector A,PVector B){
  return new PVector(A.x+B.x,A.y+B.y);
}
String PVstring(PVector P){
  return "x| "+P.x+"   y| "+ P.y;
}
PVector PV(){
  return new PVector(0,0);
}