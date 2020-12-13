int x,y;float t,k=360;
float s=100;
float scale=100;
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
  if(mousePressed){
    t+=.005;
  }
     
 cx=cos(t);
 cy=sin(t);
 if(keyPressed){
   if(key=='.'){
     scale*=1.04;
   }else if(key==','){
     scale/=1.04;
   }
   float speed= 0.08*100/scale;
   if(keyCode==UP){
     Y-=speed;
   }
   if(keyCode==DOWN){
     Y+=speed;
   }
   if(keyCode==LEFT){
     X-=speed;
   }
   if(keyCode==RIGHT){
     X+=speed;
   }
 }
  //scale+=10;
  loadPixels();
  float dist=10;
  for(y=0;y<720;y++){
    for(x=0;x<720;x++){
      float ys=(y-k)/scale+Y;
      float xs=(x-k)/scale+X;
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
  //X=closestX;  
  //Y=closestY;
  fill(255);
  stroke(0);
  updatePixels();
    float ys=(mouseY-k)/scale+Y;
    float xs=(mouseX-k)/scale+X;
    float nextx=xs;
    float nexty=ys;
    int count=0;
    ellipse((xs-X)*scale+k,(ys-Y)*scale+k,10,10);
    while((dist(xs,ys,0,0)<2)&&(count<30)){
      
      float s=xs;
      xs=xs*xs-ys*ys;
      ys=2*s*ys;
      ellipse((xs-X)*scale+k,(ys-Y)*scale+k,10,10);
      line((nextx-X)*scale+k,(nexty-Y)*scale+k,(xs-X)*scale+k,(ys-Y)*scale+k);
      float squaredx=xs;
      float squaredy=ys;
      xs+=cx;
      ys+=cy;
      ellipse((xs-X)*scale+k,(ys-Y)*scale+k,10,10);
      line((squaredx-X)*scale+k,(squaredy-Y)*scale+k,(xs-X)*scale+k,(ys-Y)*scale+k);
      nextx=xs;
      nexty=ys;
      count++;
    }
    fill(0);
    stroke(0);
    rect(0,0,200,200);
    stroke(255);
    circle(100+(0)*100/2,100+(0)*100/2,200);
    stroke(100);
    fill(255,0,0);
    circle(100+(cx)*100/2,100+(cy)*100/2,10);
  
}
void mousePressed(){

}
