void rect(PVector origin,float w,float h){
  rect(origin.x,origin.y,w,h); 
}
void rect(PVector origin,PVector size){
  rect(origin.x,origin.y,size.x,size.y); 
}
void rect(float x,float y,PVector size){
  rect(x,y,size.x,size.y); 
}
void square(float x, float y, float size){
  rect(x,y,size,size); 
}
void square(PVector origin,float size){
  rect(origin.x,origin.y,size,size); 
}
void ellipse(PVector origin,float w,float h){
  ellipse(origin.x,origin.y,w,h); 
}
void ellipse(PVector origin,PVector size){
  ellipse(origin.x,origin.y,size.x,size.y); 
}
void ellipse(float x,float y,PVector size){
  ellipse(x,y,size.x,size.y); 
}
void circle(float x, float y, float size){
  ellipse(x,y,size,size); 
}
void circle(PVector origin,float size){
  ellipse(origin.x,origin.y,size,size); 
}
static PVector vec(float x,float y){
  return new PVector(x,y); 
}
static PVector vec(){
  return vec(0,0); 
}
PVector vec(PVector vect){
  return new PVector(vect.x,vect.y); 
}
void line(PVector origin,float w,float h){
  line(origin.x,origin.y,w,h); 
}
void line(PVector origin,PVector size){
  line(origin.x,origin.y,size.x,size.y); 
}
void line(float x,float y,PVector size){
  line(x,y,size.x,size.y); 
}
void translate(PVector trans){
  translate(trans.x,trans.y); 
}
String repString(String str,int num){
  String rep="";
  for(int i=0;i<num;i++){
    rep+=str; 
  }
  return rep;
}
