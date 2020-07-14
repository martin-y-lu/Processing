void drawLine(PMatrix3D currentTransform,float lineLength,PGraphics graphic){
  PMatrix3D transformCopy= new PMatrix3D();
  transformCopy.set(currentTransform);
  PVector prev=new PVector();
  for(float i=0;i<lineLength;i+=0.3){
     PVector p= polarVector(i,0);
     transformCopy.mult(p,p);
     
     
     p=projectOntoScreen(p);

     if(i>0){
     graphic.line(prev.x,prev.y,p.x,p.y);
     }
     prev=p;
   }
   PVector p= polarVector(0,0);
     //RotationMatrix(0.2).mult(p,p);
     TranslationMatrix(new PVector(0,lineLength)).mult(p,p);
     transformCopy.mult(p,p);
      p=projectOntoScreen(p);
     graphic.line(prev.x,prev.y,p.x,p.y);
}
void drawLine(PMatrix3D currentTransform,float lineLength,float angleShift,PGraphics graphic){
  PMatrix3D transformCopy= new PMatrix3D();
  transformCopy.set(currentTransform);
  transformCopy.apply(RotationMatrix(angleShift));
  
  PVector prev=new PVector();
  for(float i=0;i<lineLength;i+=0.3){
     PVector p= polarVector(i,0);
     transformCopy.mult(p,p);
     
     
     p=projectOntoScreen(p);
     
     if(i>0){
     graphic.line(prev.x,prev.y,p.x,p.y);
     }
     prev=p;
   }
   PVector p= polarVector(0,0);
     //RotationMatrix(0.2).mult(p,p);
     TranslationMatrix(new PVector(0,lineLength)).mult(p,p);
     transformCopy.mult(p,p);
}
void drawLine3D(PMatrix3D currentTransform,float lineLength){
   drawLine3D(currentTransform,lineLength,0); 
}
void drawLine3D(PMatrix3D currentTransform,float lineLength,float angleShift){
  PMatrix3D transformCopy= new PMatrix3D();
  transformCopy.set(currentTransform);
  transformCopy.apply(RotationMatrix(angleShift));
  
  PVector prev=new PVector();
  for(float i=0;i<lineLength;i+=0.3){
     PVector p= polarVector(i,0);
     transformCopy.mult(p,p);
     
     
     //p=projectOntoScreen(p);
     
     if(i>0){
     line(prev.y*Scale3D,prev.z*Scale3D,prev.x*Scale3D,p.y*Scale3D,p.z*Scale3D,p.x*Scale3D);
     }
     prev=p.copy();
   }
   PVector p= polarVector(0,0);
     //RotationMatrix(0.2).mult(p,p);
     TranslationMatrix(new PVector(0,lineLength)).mult(p,p);
     transformCopy.mult(p,p);
}
