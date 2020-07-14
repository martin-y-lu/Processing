//Iteration #1- Matrices
float Scale=400;//Radius of poincare disc in pixels

PolarTransform camTransform= new PolarTransform();
public void setup(){
  size(800,800,P3D);
}
public void draw(){
  background(0);
  stroke(255,0,0);
  strokeWeight(4);
  float scaledMouseY=mouseY/Scale-1;
  float scaledMouseX=mouseX/Scale-1;
  //Draw poincare disc background.
  circle(Scale,Scale,Scale*2);
  
  //Draw a order5SquareTessilation  
  drawOrder5Tiling(camTransform.getMatrix());
  //circle at mouse
  circle(mouseX,mouseY,3);
  
  //check keypresses:
  if(keyPressed){
     if(keyCode==UP){
        camTransform.preApplyTranslationZ(0.04);// Translate Up (down because inverseA)
     }else if(keyCode== DOWN){
       camTransform.preApplyTranslationZ(-0.04);//Translate down
     }else if(keyCode== RIGHT){
         camTransform.preApplyRotation(-0.04);//Rotate clockwise
     }else if(keyCode== LEFT){
       camTransform.preApplyRotation(0.04);// Rotatate counterclockwise
     }
   }
}
public void drawLine(PMatrix currentTransform,float angle,float lineLength){
  PVector prevPoint= new PVector();
  float inc=0.1f;
  for(float i=0;i<lineLength;i+=inc){
    PVector nextPoint= polarVector(i,angle);
    //Apply currentTransform on nextPoint and save the result in nextPoint 
    currentTransform.mult(nextPoint,nextPoint);
    nextPoint=projectOntoScreen(nextPoint);
    if(i>=inc){
      line(prevPoint.x,prevPoint.y,nextPoint.x,nextPoint.y);
    }
    prevPoint=nextPoint;
  }
}
