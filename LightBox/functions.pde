boolean RayIntersect(PVector Pos,PVector Ray,PVector PoiA,PVector PoiB){
  PVector rotPoiA=PVDivide(PVadd(PoiA,PVminus(Pos)),Ray);
  PVector rotPoiB=PVDivide(PVadd(PoiB,PVminus(Pos)),Ray);
  PVector intersect=new PVector(rotPoiA.x-(rotPoiA.y*(rotPoiA.x-rotPoiB.x)/(rotPoiA.y-rotPoiB.y)),0);
  return (intersect.x>=0)&&FLtween(rotPoiA.x,rotPoiB.x,intersect.x);
}
PVector RayIntersectPos(PVector Pos,PVector Ray,PVector PoiA,PVector PoiB){
  PVector rotPoiA=PVDivide(PVadd(PoiA,PVminus(Pos)),Ray);
  PVector rotPoiB=PVDivide(PVadd(PoiB,PVminus(Pos)),Ray);
  PVector intersect=new PVector(rotPoiA.x-(rotPoiA.y*(rotPoiA.x-rotPoiB.x)/(rotPoiA.y-rotPoiB.y)),0);
  return PVadd(PVMult(intersect,Ray),Pos);
}
PVector PVadd(PVector A,PVector B){
  return new PVector(A.x+B.x,A.y+B.y);
}
PVector PVextend(PVector A,float B){
  return new PVector(A.x*B,A.y*B);
}

PVector PVsetmag(PVector P,float L){
  return PVextend(P,L/PVmag(P));
}
PVector PVminus(PVector P){
  return PVextend(P,-1);
}
float PVmag(PVector P){
  return dist(0,0,P.x,P.y);
}
PVector PVMult(PVector A,PVector B){
  return new PVector(A.x*B.x-A.y*B.y,A.x*B.y+A.y*B.x);
}
PVector PVDivide(PVector P,PVector C){
  return new PVector((C.x*P.x+C.y*P.y)/((C.x*C.x)+(C.y*C.y)),
  (C.x*P.y-C.y*P.x)/((C.x*C.x)+(C.y*C.y)));
}

String PVstring(PVector P){
  return " X:"+ P.x+" Y:"+P.y;
}

boolean FLtween(float A,float B,float M){
  return ((M>=A)&&(M<=B))||((M<=A)&&(M>=B));
}