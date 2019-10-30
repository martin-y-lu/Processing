PVector PutOnPlane(PVector P){
  float L= (pow(P.x,2)+pow(P.y,2)+1)/(2*P.x);
  float W= L- P.x/abs(P.x)*sqrt(pow(L,2)-1);
  //PVector F;
  //if((P.x==0)&&(P.y==0)){
  //  F=new PVector(0,0);
  //}else if(P.y==0){
  //  F=new PVector(P.x/(1-pow(P.x,2)),0);
  //}else if(P.x==0){
  //   F=new PVector(0,P.y/(1-pow(P.y,2)));
  //}else{
  //  F=new PVector(W/(1-pow(W,2)),P.y/abs(P.y)*sqrt(pow(P.x-W,2)+pow(P.y,2))/((1-pow(P.x,2)-pow(P.y,2))*(1-pow(W,2))));
  //}
  PVector F=new PVector(P.x/(1-pow(P.x,2)-pow(P.y,2)),P.y/(1-pow(P.x,2)-pow(P.y,2)));
  return F;
}
PImage IMG;
PImage IMGF;
void setup(){
    frameRate(60);
    size(500,800);
    //IMGF=loadImage("POINCARKY.jpg");
        IMGF=loadImage("COWERS.jpg");
    IMG=createImage(800,800,RGB);
}
float SensorWidth=50;
PVector SensorPos=new PVector(785/2-SensorWidth/2,560/2-SensorWidth/2);
boolean PressRect=false;
boolean PressWidth=false;
void draw(){
  background(0); 
  fill(255);
  noFill();
  if(PressRect==false){
    if(mousePressed&&(mouseX>SensorPos.x+(height-500-IMGF.height)/2-20)&&(mouseX<SensorPos.x+(height-500-IMGF.height)/2+20)&&
    (mouseY>SensorPos.y+(height-500-IMGF.height)/2-20)&&(mouseY<SensorPos.y+(height-500-IMGF.height)/2+20)){
      PressRect=true;
    }
  }
  if(PressRect==true){
    if(mousePressed){
        SensorPos.set(new PVector(mouseX-(height-500-IMGF.height)/2,mouseY-(height-500-IMGF.height)/2));
    }else{
      PressRect=false;
    }
  }
  if(PressWidth==false){
    if(mousePressed&&(mouseX>SensorPos.x+(height-500-IMGF.height)/2+SensorWidth-20)&&(mouseX<SensorPos.x+(height-500-IMGF.height)/2+SensorWidth+20)&&
    (mouseY>SensorPos.y+(height-500-IMGF.height)/2+SensorWidth-20)&&(mouseY<SensorPos.y+(height-500-IMGF.height)/2+SensorWidth+20)){
      PressWidth=true;
    }
  }
  if(PressWidth==true){
    if(mousePressed){
        SensorWidth=max(mouseX-(height-500-IMGF.height)/2-SensorPos.x,mouseY-(height-500-IMGF.height)/2-SensorPos.y);
    }else{
      PressWidth=false;
    }
  }
  IMG.loadPixels();
  for(int i=0; i<IMG.pixels.length;i++){
    IMG.pixels[i]=color(0);
    float x= i% IMG.width;
    float y= floor(i/IMG.width);
    PVector Pos= new PVector(x,y);
    Pos=PVadd(Pos,new PVector(-IMG.width/2,-IMG.height/2));
    Pos=PVextend(Pos,float(1)/(IMG.width/2));
    Pos=PutOnPlane(Pos);
    Pos=PVextend(Pos,(SensorWidth/2));
    Pos=PVadd(Pos,new PVector((SensorWidth/2),(SensorWidth/2)));
    Pos.x=floor(Pos.x);
    Pos.y=floor(Pos.y);
    if((Pos.x>-SensorPos.x)&&(Pos.x<IMGF.width-SensorPos.x)&&(Pos.y>-SensorPos.y)&&(Pos.y<IMGF.height-SensorPos.y)){
      IMG.pixels[i]=IMGF.pixels[int(Pos.y+SensorPos.y)*IMGF.width+int(Pos.x+SensorPos.x)];
    } 
  }
  IMG.updatePixels();
  image(IMG,0,height-500,500,500);
  image(IMGF,(height-500-IMGF.height)/2,(height-500-IMGF.height)/2);
  stroke(255);
  strokeWeight(4);
  rect(SensorPos.x+(height-500-IMGF.height)/2,SensorPos.y+(height-500-IMGF.height)/2,SensorWidth,SensorWidth);
  ellipse(SensorPos.x+(height-500-IMGF.height)/2+1,SensorPos.y+(height-500-IMGF.height)/2+1,6,6);
  ellipse(SensorPos.x+(height-500-IMGF.height)/2+SensorWidth,SensorPos.y+(height-500-IMGF.height)/2+SensorWidth,6,6);

}