PVector PVadd(PVector A,PVector B){
  return new PVector(A.x+B.x,A.y+B.y);
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

  //float W= sqrt((P.x/abs(P.x)*P.x)/(2+(P.x/abs(P.x)*P.x)));
  //float L= (1+pow(W,2))/(2*W);
  //float  A=-pow(P.y,2)*pow(1-pow(W,2),2)*4*pow(L,2);
  //float B=2*L-2*W+pow(P.y,2)*pow(1-pow(W,2),2)*8*L;
  //float C=-1+pow(W,2)-pow(P.y,2)*pow(1-pow(W,2),2)*4;
  //float N=((-B+sqrt(pow(B,2)-4*A*C))/(2*A));
  //PVector F;
  //if((P.x==0)&&(P.y==0)){
  //  F=new PVector(0,0);
  //}else if(P.x==0){
  //  A=pow(P.y,2);
  //  B=-2*pow(P.y,2)-1;
  //  C=pow(P.y,2);
  //  N=1/sqrt((-B+sqrt(pow(B,2)-4*A*C))/(2*A));
  //  F= new PVector(0,P.y/abs(P.y)*N);
  //}else if((P.y==0)||(2*N*L-1-pow(N,2)<0)){
  //  F= new PVector(P.x/abs(P.x)*W,0);
  //}else{
  //  F= new PVector(P.x/abs(P.x)*N,P.y/abs(P.y)*sqrt(2*N*L-1-pow(N,2)));
  //}
  //return F;