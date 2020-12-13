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
HE_Mesh generateMeshLine(PMatrix3D currentTransform,float lineLength){
   return generateMeshLine(currentTransform,lineLength,0); 
}
HE_Mesh generateMeshLine(PMatrix3D currentTransform,float lineLength,float angleShift){
  PMatrix3D transformCopy= new PMatrix3D();
  transformCopy.set(currentTransform);
  transformCopy.apply(RotationMatrix(angleShift));
  
  
//Mesh
  WB_BSpline C;
  WB_Point[] points;
  points=new WB_Point[ceil(lineLength/0.3)+1]; 
  
  PVector prev=new PVector();
  int ind=0;
  for(float i=0;i<lineLength;i+=0.3){
     PVector p= polarVector(i,0);
     transformCopy.mult(p,p);
     //p=projectOntoScreen(p);
//p.y*Scale3D,p.z*Scale3D,p.x*Scale3D
     points[ind]=new WB_Point(p.y*ScaleMesh,p.z*ScaleMesh,p.x*ScaleMesh);
     ind++;
     prev=p.copy();
   }
   PVector p= polarVector(0,0);
   //RotationMatrix(0.2).mult(p,p);
   TranslationMatrix(new PVector(0,lineLength)).mult(p,p);
   transformCopy.mult(p,p);
   points[points.length-1]=new WB_Point(p.y*ScaleMesh,p.z*ScaleMesh,p.x*ScaleMesh);
   
   C=new WB_BSpline(points, 4);
   HEC_SweepTube creator=new HEC_SweepTube();
   creator.setCurve(C);//curve should be a WB_BSpline
   creator.setRadius(45);
   creator.setSteps(10);
   creator.setFacets(6);
   creator.setCap(true, true); // Cap start, cap end?
   return new HE_Mesh(creator);
}

HE_Mesh generateMeshSphere(PMatrix3D currentTransform,float radius){
   PVector p= polarVector(0,0);
   currentTransform.mult(p,p);
   HEC_Sphere end= new HEC_Sphere();
   end.setRadius(radius);
   end.setCenter(new WB_Point(p.y*ScaleMesh,p.z*ScaleMesh,p.x*ScaleMesh));
   return new HE_Mesh(end);
}
