PVector PVadd(PVector A,PVector B){
  return new PVector(A.x+B.x,A.y+B.y);
}
PVector PVneg(PVector A){
  return new PVector(-A.x,-A.y);
}
float PVmag(PVector Po){
  return dist(0,0,Po.x,Po.y);
}
PVector PVextend(PVector A, float mult){
  return new PVector(A.x*mult,A.y*mult);
}
PVector PVsetmag(PVector A,float mag){
  return PVextend(A,mag/PVmag(A));
}
PVector PVMult(PVector A,PVector B){
  return new PVector(A.x*B.x-A.y*B.y,A.x*B.y+A.y*B.x);
}
PVector PVDivide(PVector P,PVector C){
  return new PVector((C.x*P.x+C.y*P.y)/((C.x*C.x)+(C.y*C.y)),
  (C.x*P.y-C.y*P.x)/((C.x*C.x)+(C.y*C.y)));
}
float PVAng(PVector P){
  return atan2(P.y,P.x);
}
String PVstring(PVector P){
  return "x| "+P.x+"   y| "+ P.y;
}
PVector PV(){
  return new PVector(0,0);
}