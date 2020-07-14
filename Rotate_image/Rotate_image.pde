PImage dolphin;
PImage bg;
void setup(){
 size(2000,2000);
 bg = loadImage("background.jpg");  
 dolphin = loadImage("dolphin.jpg");  
}
int x=400;
int y=300;
float r;
void draw(){
  r=float(mouseX)/100;
  background(0);
  pushMatrix();
  image(bg,0,0);
  popMatrix();
  pushMatrix();
  translate(x,y);
  rotate(r);
  image(dolphin,0,0);
  popMatrix();
}
