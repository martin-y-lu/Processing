float sinh(float x){// formula for hyperbolic sine
   return (exp(x)-exp(-x))/2f; 
}
float cosh(float x){// formula for hyperbolic cosine
   return (exp(x)+exp(-x))/2f; 
}
float arcosh(float a){// inverse of hyperbolic cosine
  return log(a+sqrt(a*a-1));
}
PVector polarVector(float r,float theta){ //vector given polar coordinates in hyperbolic space
   return new PVector(cosh(r),sinh(r)*cos(theta),sinh(r)*sin(theta)); 
}

PVector projectOntoPoincareDisc(PVector point){// Returns vector after projecting onto unit disc
  //Poincare disc
  float scale=1f/(point.x+1);
  return new PVector(point.y*scale,point.z*scale);
}
PVector PoincareDiscOntoParaboloid(PVector point){
  float scale=1f/(point.x+1);
  return new PVector(point.y*scale,point.z*scale);
}
PVector scaleToScreen(PVector point){
  return new PVector(point.x*Scale+Scale,point.y*Scale+Scale);
}
PVector projectOntoScreen(PVector point){
  return scaleToScreen(projectOntoPoincareDisc(point));
}
PMatrix3D TranslationMatrixZ(float yTrans){
  PMatrix3D P= new PMatrix3D();
  P.set(cosh(yTrans),sinh(yTrans),0f  ,0f,
        sinh(yTrans),cosh(yTrans),0f  ,0f,
        0f          ,0f          ,1f  ,0f,
        0f,0f,0f,0f);
  return P;
}
PMatrix3D TranslationMatrixY(float yTrans){
  PMatrix3D P= new PMatrix3D();
   P.set(cosh(yTrans),0f,sinh(yTrans)  ,0f,
        0f           ,1f,0f            ,0f,
        sinh(yTrans) ,0f,cosh(yTrans)  ,0f,
        0f,0f,0f,0f);
  return P;
}
PMatrix3D TranslationMatrix(PVector Translate){
  PMatrix3D P=new PMatrix3D();
  P.set(TranslationMatrixY(Translate.x));
  P.apply(TranslationMatrixZ(Translate.y));
   return P;
}
PMatrix3D TranslationMatrix(float translateX,float translateY){
  PMatrix3D P=new PMatrix3D();
  P.set(TranslationMatrixY(translateX));
  P.apply(TranslationMatrixZ(translateY));
   return P;
}


PMatrix3D RotationMatrix(float theta){
  PMatrix3D P= new PMatrix3D();
  P.set(1f,0f        ,0f           ,0f,
        0f,cos(theta),-sin(theta)  ,0f,
        0f,sin(theta),cos(theta)   ,0f,
        0f,0f,0f,0f);
  return P;
}
