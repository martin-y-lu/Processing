PVector PVadd(PVector A,PVector B){
  return new PVector(A.x+B.x,A.y+B.y);
}
PVector PVsub(PVector A, PVector B){
  return new PVector(A.x-B.x,A.y-B.y);
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
PVector PVmult(PVector A,PVector B){
  return new PVector(A.x*B.x-A.y*B.y,A.x*B.y+A.y*B.x);
}
PVector PVdivide(PVector P,PVector C){
  return new PVector((C.x*P.x+C.y*P.y)/((C.x*C.x)+(C.y*C.y)),
  (C.x*P.y-C.y*P.x)/((C.x*C.x)+(C.y*C.y)));
}
PVector PVlerp(PVector A,PVector B,float L){
 return PVadd(PVextend(A,1-L),PVextend(B,L));
}
String PVstring(PVector P){
  return " X:"+ P.x+" Y:"+P.y;
}

boolean INrange(int A,int B,int M){
  return ((M>=A)&&(M<=B))||((M<=A)&&(M>=B));
}
boolean FLrange(float A,float B,float M){
  return ((M>=A)&&(M<=B))||((M<=A)&&(M>=B));
}
