float branchLength=1.255;
int Depth=3;
void draw2BranchSector(PMatrix3D currentTransform,int depth){
  drawLine(currentTransform,0,branchLength);
  PMatrix3D transformCopy= new PMatrix3D();
  transformCopy.set(currentTransform);
   transformCopy.apply(TranslationMatrixZ(branchLength));
   transformCopy.apply(RotationMatrix(PI));
   if(depth<Depth){
       transformCopy.apply(RotationMatrix(TWO_PI/5));
       drawLine(transformCopy,0,branchLength);
       transformCopy.apply(RotationMatrix(TWO_PI/5));
       draw2BranchSector(transformCopy,depth+1);
       transformCopy.apply(RotationMatrix(TWO_PI/5));
       draw3BranchSector(transformCopy,depth+1);
   }
  
} 
void draw3BranchSector(PMatrix3D currentTransform,int depth){
  drawLine(currentTransform,0,branchLength);
    PMatrix3D transformCopy= new PMatrix3D();
  transformCopy.set(currentTransform);
   transformCopy.apply(TranslationMatrixZ(branchLength));
   transformCopy.apply(RotationMatrix(PI));
   if(depth<Depth){
     transformCopy.apply(RotationMatrix(TWO_PI/5));
     draw2BranchSector(transformCopy,depth+1);
     transformCopy.apply(RotationMatrix(TWO_PI/5));
     draw3BranchSector(transformCopy,depth+1);
     transformCopy.apply(RotationMatrix(TWO_PI/5));
     draw3BranchSector(transformCopy,depth+1);
   }
}
void drawOrder5Tiling(PMatrix3D currentTransform){
  PMatrix3D transformCopy= new PMatrix3D();
  transformCopy.set(currentTransform);
  for(int i=0;i<5;i++){
    transformCopy.apply(RotationMatrix(TWO_PI/5));
    draw3BranchSector(transformCopy,0);
  }
}
