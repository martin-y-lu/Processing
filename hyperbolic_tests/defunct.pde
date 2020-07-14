//void drawTreeType1(PMatrix3D currentTransform,int depth){
//  drawLine(currentTransform,branchLength);
//  PMatrix3D transformCopy= new PMatrix3D();
//  transformCopy.set(currentTransform);
//   transformCopy.apply(TranslationMatrix(new PVector(0,branchLength)));
//   transformCopy.apply(RotationMatrix(PI));
//   if(depth<Depth){
//       transformCopy.apply(RotationMatrix(TWO_PI/5));
// drawLine(transformCopy,branchLength);
//       transformCopy.apply(RotationMatrix(TWO_PI/5));
//       drawTreeType1(transformCopy,depth+1);
//       transformCopy.apply(RotationMatrix(TWO_PI/5));
//       drawTreeType2(transformCopy,depth+1);
//   }
  
//} 
//void drawTreeType2(PMatrix3D currentTransform,int depth){
//  drawLine(currentTransform,branchLength);
//    PMatrix3D transformCopy= new PMatrix3D();
//  transformCopy.set(currentTransform);
//   transformCopy.apply(TranslationMatrix(new PVector(0,branchLength)));
//   transformCopy.apply(RotationMatrix(PI));
//   if(depth<Depth){
//     transformCopy.apply(RotationMatrix(TWO_PI/5));
//     drawTreeType1(transformCopy,depth+1);
//     transformCopy.apply(RotationMatrix(TWO_PI/5));
//     drawTreeType2(transformCopy,depth+1);
//     transformCopy.apply(RotationMatrix(TWO_PI/5));
//     drawTreeType2(transformCopy,depth+1);
//   }
//}
//void drawOrder5Tiling(PMatrix3D currentTransform){
//  PMatrix3D transformCopy= new PMatrix3D();
//  transformCopy.set(currentTransform);
//  for(int i=0;i<5;i++){
//    transformCopy.apply(RotationMatrix(TWO_PI/5));
//    drawTreeType2(transformCopy,0);
//  }
//}
