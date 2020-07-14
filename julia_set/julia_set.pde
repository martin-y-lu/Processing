int x,y;float t,k=360;
float s=50;
float X=0;
float Y=0;
void setup(){
 size(720,720);
 colorMode(HSB);
}
float cx=-1;
float cy=2;
  float closestX=0;
  float closestY=0;
void draw(){
     t+=.005;
 cx=cos(t);
 cy=sin(t);
  s+=10;
  loadPixels();
  float dist=10;
  for(y=0;y<720;y++){
    for(x=0;x<720;x++){
      float ys=(y-k)/s+Y;
      float xs=(x-k)/s+X;
      int count=0;
      while((dist(xs,ys,0,0)<2)&&(count<30)){
        float s=xs;
        xs=xs*xs-ys*ys+cx;
        ys=2*s*ys+cy;
        count++;
      }
      
      
      if(count>10){
        float d=dist(0,0,(x-k)/s,(y-k)/s);
        if(d<dist){
          dist=d;
          closestX=(x-k)/s+X;
          closestY=(y-k)/s+Y;
        }
      }
      pixels[y*720+x]=color(count*10,255,255);
    }
  }
  println(dist+" "+X+" "+Y+" "+closestX+" "+closestY);
  updatePixels();
  X=closestX;  
  Y=closestY;

}
