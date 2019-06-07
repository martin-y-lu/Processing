PGraphics sourceImage;
PGraphics maskImage;

void drawBG(float cycle){
  // create source
  sourceImage = createGraphics(width,height);
  sourceImage.beginDraw();
  sourceImage.fill(255,0,0);
  
  sourceImage.rect(0,0,width,height);
  sourceImage.endDraw();
 
  // create mask
  maskImage = createGraphics(width,height);
  maskImage.beginDraw();
  maskImage.translate(width/2,height/2);
  maskImage.fill(255);
  float rad= cycle*300;
  maskImage.ellipse(0,0,2*rad,2*rad);
  //maskImage.triangle(30, 480, 256, 30, 480, 480);
  maskImage.endDraw();
 
  // apply mask
  sourceImage.mask(maskImage);
  
  // show masked source
  image(sourceImage, 0, 0);
  
}