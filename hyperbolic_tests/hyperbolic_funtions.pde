float sinh(float x){
   return (exp(x)-exp(-x))/2f; 
}
float cosh(float x){
   return (exp(x)+exp(-x))/2f; 
}
float arcosh(float a){
  return log(a+sqrt(a*a-1));
}
PVector polarVector(float r,float theta){
   return new PVector(cosh(r),sinh(r)*cos(theta),sinh(r)*sin(theta)); 
}

PVector projectOntoPoincareDisc(PVector point){
  //Poincare disc
  if( PROJECTION== Projection.POINCARE){
    float scale=1f/(point.x+1);
    return new PVector(point.y*scale,point.z*scale);
  }
  //Klien disc
  if( PROJECTION== Projection.KLEIN){
    float scale=1f/(point.x);
    return new PVector(point.y*scale,point.z*scale);
  }
  if( PROJECTION== Projection.GANS){
    return new PVector(point.y*0.2,point.z*0.2);
  }
  return new PVector();
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
PMatrix TranslationMatrixZ(float yTrans){
  PMatrix3D P= new PMatrix3D();
  P.set(cosh(yTrans),sinh(yTrans),0f,0f,
        sinh(yTrans),cosh(yTrans),0f,0f,
        0f,0f,1f,0f,
        0f,0f,0f,0f);
  return P;
}
PMatrix TranslationMatrixY(float yTrans){
  PMatrix3D P= new PMatrix3D();
   P.set(cosh(yTrans),0f,sinh(yTrans),0f,
        0f,1f,0f,0f,
        sinh(yTrans),0f,cosh(yTrans),0f,
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
  P.set(1f,0f,0f,0f,
        0f,cos(theta),-sin(theta),0f,
        0f,sin(theta),cos(theta),0f,
        0f,0f,0f,0f);
  return P;
}
