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
color addColor(color A,color B){
  return color(red(A)+red(B),green(A)+green(B),blue(A)+blue(B));
}
color lightenColor(color A,float factor){
  return color(red(A)*factor,green(A)*factor,blue(A)*factor);
}
float QuadLerp(float v0,float v1,float v2,float v3,float x,float y){
  float Top=v0+x*(v1-v0);
  float Bottom=v2+x*(v3-v2);
  return Top+y*(Bottom-Top);
}