public class PolarTransform{
  //A parametrisation SU2 that preserves hyperbolic space.
  //Starts with rotation of n rad, translation in z of s, and a rotation of m;
  float n;
  float s;
  float m;
  PolarTransform(){ 
  }
  PolarTransform(float dN,float dS, float dM){
      n=dN; s=dS; m=dM;
  }
  PMatrix3D getMatrix(){
    PMatrix3D startTransform=RotationMatrix(n);
   startTransform.apply(TranslationMatrix(0,s));
   startTransform.apply(RotationMatrix(m));
   return startTransform;
  }
  void applyTranslationZ(float l){
     float N= atan2((cos(n)*sin(m)+cos(m)*sin(n)*cosh(s))*sinh(l)+sin(n)*sinh(s)*cosh(l),((cos(m)*cos(n)*cosh(s)-sin(m)*sin(n))*sinh(l)+cos(n)*cosh(l)*sinh(s)));
     float S= arcosh(cosh(l)*cosh(s)+cos(m)*sinh(l)*sinh(s));
     float M= atan2((sin(m)*sinh(s)),(cosh(s)*sinh(l)+cosh(l)*sinh(s)*cos(m)));
     n=N;
     s=S;
     m=M;
  }
  void applyTranslationY(float l){
     float N= atan2((cos(m)*cos(n)-cosh(s)*sin(m)*sin(n))*sinh(l)+cosh(l)*sinh(s)*sin(n),(-cos(n)*cosh(s)*sin(m)-cos(m)*sin(n))*sinh(l)+cosh(l)*sinh(s)*cos(n));
     float S= arcosh(cosh(l)*cosh(s)+sin(m)*sinh(l)*sinh(s));
     float M= atan2(-(cosh(s)*sinh(l)+cosh(l)*sinh(s)*sin(m)),(cos(m)*sinh(s)));
     n=N;
     s=S;
     m=M;
  }
  void applyRotation(float a){
     m= m+a;
  }
  void applyPolarTransform(PolarTransform pt){
    applyRotation(pt.n);
    applyTranslationZ(pt.s);
    applyRotation(pt.m);
  }
  void preApplyTranslationY(float l){
     float N= atan2(sin(n)*sinh(s),cosh(s)*sinh(l)+cos(n)*cosh(l)*sinh(s));
     float S= arcosh(cosh(l)*cosh(s)+cos(n)*sinh(l)*sinh(s));
     float M= atan2(cos(m)*sin(n)*sinh(l)+sin(m)*(cos(n)*sinh(l)*cosh(s)+cosh(l)*sinh(s)),cos(m)*(cos(n)*cosh(s)*sinh(l)+cosh(l)*sinh(s))-sin(m)*sin(n)*sinh(l));
     
     n=N;
     s=S;
     m=M;
  }
  void preApplyTranslationZ(float l){
     float N= atan2(cosh(s)*sinh(l)+cosh(l)*sinh(s)*sin(n),cos(n)*sinh(s));
     float S= arcosh(cosh(l)*cosh(s)+sin(n)*sinh(l)*sinh(s));
     float M= atan2(-cos(m)*cos(n)*sinh(l)+sin(m)*(cosh(s)*sinh(l)*sin(n)+cosh(l)*sinh(s)),cos(n)*sin(m)*sinh(l)+cos(m)*(cosh(s)*sinh(l)*sin(n)+cosh(l)*sinh(s)));
     n=N;
     s=S;
     m=M;
  }
  void preApplyRotation(float a){
     n+=a;
  }
  void preApplyPolarTransform(PolarTransform pt){
    preApplyRotation(pt.m);
    preApplyTranslationY(pt.s);
    preApplyRotation(pt.n);
  }
  
  PolarTransform inverse(){
    return new PolarTransform(-m,-s,-n);
  }
  float distanceTo(PolarTransform p){
    PolarTransform c= copy();
    //println(c+ ":"+ p);
    c.applyPolarTransform(p.inverse());
    
    return c.s;
  }
  PolarTransform copy(){
     return new PolarTransform(n,s,m); 
  }
  String toString(){
    return "<n-"+n+",s-"+s+",m-"+m+">";
  }
  PVector posOnScreen(){
    PMatrix3D transform= getMatrix();
    PVector p= new PVector(1,0,0);
    transform.mult(p,p);
    p= projectOntoScreen(p);
    return p;
  }
}

class LatticeTransform{
  //A parametrisation SU2 that preserves hyperbolic space.
  //Based off of a lattice point, and a polar transform on top of it. The relative lattice point is supposed to be the nearest lattic point to the transform.
  LatticeSystem system;
  LatticePoint basePoint;
  PolarTransform relativeTransform;
  LatticeTransform(PolarTransform transform,LatticeCoord coord,LatticeSystem dSystem){
    relativeTransform=transform;
    system=dSystem;

    basePoint=dSystem.getLatticePoint(coord);
        //resolveBasePoint();
  }
  void applyPolarTransform(PolarTransform T){
     relativeTransform.applyPolarTransform(T);
     resolveBasePoint();
  }
  boolean tryApplyPolarTransform(PolarTransform T){
     relativeTransform.applyPolarTransform(T);
     return tryResolveBasePoint();
  }
  LatticePoint getLatticePointInDirectionIfExists(int direction){
    return  system.getLatticePointIfExists(basePoint.coords.coordInDirection(direction));
  }
  void stepBasePointInDirection(int direction){//Steps the basePoint in a direction, without changing the actual transformation;
    LatticePoint newBasePoint= system.getLatticePoint(basePoint.coords.coordInDirection(direction));
    int turnAmount=basePoint.coords.directionAfterTravel(direction);
    basePoint=newBasePoint;
    //println(turnAmount);
    relativeTransform.applyPolarTransform(new PolarTransform(direction*TWO_PI/5,BRANCHLENGTH,PI-turnAmount*TWO_PI/5));
  }
  void stepBasePointInDirections(int[] directions){
     for(int i=0;i<directions.length;i++){
       stepBasePointInDirection(directions[i]);
     }
  }
  void stepBasePointInBranches(int[] directions){
     for(int i=0;i<directions.length;i++){
       stepBasePointInDirection(basePoint.coords.directionOfBranch(directions[i]));
     }
  }
  
  PolarTransform relativeTransformInDirection(int direction){
    PolarTransform p=relativeTransform.copy();
    p.applyPolarTransform(new PolarTransform(direction*TWO_PI/5,BRANCHLENGTH,PI));
    return p;
  }
  void shiftToNearerBasePoint(){// Changes base point so that the relativeTransform has a shorter magnatude. if there is no shorteer one, it does nothibg.
    float transformLength=abs(relativeTransform.s);
    for(int i=0;i<5;i++){
      if(abs(relativeTransformInDirection(i).s)<transformLength){
        stepBasePointInDirection(i);
        return;
      }
    }
    return;
  }
  boolean shiftToNearerBasePointIfExists(){//returns true if the nearer basepoint (or same basepoint) exists;
    float transformLength=abs(relativeTransform.s);
    boolean nearerExists=true;
    for(int i=0;i<5;i++){
        if(abs(relativeTransformInDirection(i).s)<transformLength){
          if(getLatticePointInDirectionIfExists(i)!=null){
            stepBasePointInDirection(i);
            return true;
          }else{
            nearerExists=false;
          }
        }
    }
    return nearerExists;
  }
  void resolveBasePoint(){
    boolean stepped;
    do{
      stepped = false;
      float transformLength=abs(relativeTransform.s);
      for(int i=0;i<5;i++){
        if(abs(relativeTransformInDirection(i).s)<transformLength){
          stepBasePointInDirection(i);
          stepped=true;
        }
      }
    }while(stepped);
  }
  boolean tryResolveBasePoint(){//Tries to resolve base point, but if a base point doesn't exist, return false;
    boolean stepped;
    do{
      stepped = false;
      float transformLength=abs(relativeTransform.s);
      for(int i=0;i<5;i++){
        if(abs(relativeTransformInDirection(i).s)<transformLength){
          if(getLatticePointInDirectionIfExists(i)!=null){
            stepBasePointInDirection(i);
            stepped=true;
          }else{
            return false;
            //Doesn't exist
          }
        }
      }
    }while(stepped);
    return true;
  }
 void applyPolarTransformContravariant(PolarTransform T){
     relativeTransform.applyPolarTransform(T);
     resolveBasePointContravariant();
  }
  boolean tryApplyPolarTransformContravariant(PolarTransform T){
     relativeTransform.applyPolarTransform(T);
     return tryResolveBasePointContravariant();
  }
  void stepBasePointInDirectionContravariant(int direction){//Steps the basePoint in a direction, without changing the actual transformation;
    LatticePoint newBasePoint= system.getLatticePoint(basePoint.coords.coordInDirection(direction));
    int turnAmount=basePoint.coords.directionAfterTravel(direction);
    basePoint=newBasePoint;
    //println(turnAmount);
    relativeTransform.preApplyPolarTransform(new PolarTransform(turnAmount*TWO_PI/5-PI,-BRANCHLENGTH,-direction*TWO_PI/5));
  }
  void stepBasePointInDirectionsContravariant(int[] directions){
     for(int i=0;i<directions.length;i++){
       stepBasePointInDirectionContravariant(directions[i]);
     }
  }
  void stepBasePointInBranchesCovarianant(int[] directions){
     for(int i=0;i<directions.length;i++){
       stepBasePointInDirectionContravariant(basePoint.coords.directionOfBranch(directions[i]));
     }
  }
  // PolarTransform relativeTransformInDirectionContravariant(int direction){
  //  PolarTransform p=relativeTransform.copy();
  //  p.applyPolarTransform(new PolarTransform(direction*TWO_PI/5,BRANCHLENGTH,PI));
  //  return p;
  //}
  PolarTransform relativeTransformInDirectionContravariant(int direction){
    PolarTransform p=relativeTransform.copy();
    p.preApplyPolarTransform(new PolarTransform(direction*TWO_PI/5,BRANCHLENGTH,PI).inverse());
    return p;
  }
  void shiftToNearerBasePointContravariant(){// Changes base point so that the relativeTransform has a shorter magnatude. if there is no shorteer one, it does nothibg.
    float transformLength=abs(relativeTransform.s);
    for(int i=0;i<5;i++){
      if(abs(relativeTransformInDirectionContravariant(i).s)<transformLength){
        stepBasePointInDirectionContravariant(i);
        return;
      }
    }
    return;
  }
  boolean shiftToNearerBasePointIfExistsContravariant(){//returns true if the nearer basepoint (or same basepoint) exists;
    float transformLength=abs(relativeTransform.s);
    boolean nearerExists=true;
    for(int i=0;i<5;i++){
        if(abs(relativeTransformInDirectionContravariant(i).s)<transformLength-0){
          if(getLatticePointInDirectionIfExists(i)!=null){
            stepBasePointInDirectionContravariant(i);
            return true;
          }else{
            nearerExists=false;
          }
        }
    }
    return nearerExists;
  }
  void resolveBasePointContravariant(){
    boolean stepped;
    do{
      stepped = false;
      float transformLength=abs(relativeTransform.s);
      for(int i=0;i<5;i++){
        if(abs(relativeTransformInDirectionContravariant(i).s)<transformLength){
          stepBasePointInDirectionContravariant(i);
          stepped=true;
          i+=100;
        }
      }
    }while(stepped);
  }
  boolean tryResolveBasePointContravariant(){//Tries to resolve base point, but if a base point doesn't exist, return false;
    boolean stepped;
    do{
      stepped = false;
      float transformLength=abs(relativeTransform.s);
      for(int i=0;i<5;i++){
        if(abs(relativeTransformInDirectionContravariant(i).s)<transformLength){
          if(getLatticePointInDirectionIfExists(i)!=null){
            stepBasePointInDirectionContravariant(i);
            stepped=true;
            i+=1000;
          }else{
            return false;
            //Doesn't exist
          }
        }
      }
    }while(stepped);
    return true;
  }
  String toString(){
     return "<c-"+basePoint.coords.toString()+" t-"+relativeTransform.toString()+" >"; 
  }
  //float distanceTo(LatticeTransform t){// Actually quite an expensive function! don't use unless it's the only sol'n and dont expect it to be super accurate for large distances
  //  LatticeTransform c= copy();
  //  int root=ancestorIndex(basePoint.coords.coord,t.basePoint.coords.coord);
  //  //println("root:"+root+"  f "+c.basePoint.coords.coord.length);
  //  int prevLength=c.basePoint.coords.coord.length;
  //  if(root>=0){
  //    for(int i=0;i<prevLength-root-1;i++){
  //      //println("step 0");
  //      c.stepBasePointInDirection(0);
  //    }
  //  }else{
  //    for(int i=0;i<prevLength;i++){
  //      //println("step 0 wtf");
  //      c.stepBasePointInDirection(0);
  //    } 
  //  }
  //  printArray(section(t.basePoint.coords.coord,root+1,t.basePoint.coords.coord.length));
  //  c.stepBasePointInBranches(section(t.basePoint.coords.coord,root+1,t.basePoint.coords.coord.length));
  //  if(c.basePoint.compareTo(t.basePoint)!=0){
  //     println(" something was impmenebted wrong in distanceTo, fix it :"+c.basePoint.toString()+ "  :"+t.basePoint.toString());
  //     return 0;
  //  }
  //  return c.relativeTransform.distanceTo(t.relativeTransform);
  //}
  float distanceToContravariant(LatticeTransform t){// Actually quite an expensive function! don't use unless it's the only sol'n and dont expect it to be super accurate for large distances
    LatticeTransform c= copy();
    int root=ancestorIndex(basePoint.coords.coord,t.basePoint.coords.coord);
    //println("root:"+root+"  f "+c.basePoint.coords.coord.length);
    int prevLength=c.basePoint.coords.coord.length;
    if(root>=0){
      for(int i=0;i<prevLength-root-1;i++){
        //println("step 0");
        c.stepBasePointInDirectionContravariant(0);
      }
    }else{
      for(int i=0;i<prevLength;i++){
        //println("step 0 wtf");
        c.stepBasePointInDirectionContravariant(0);
      } 
    }
    //printArray(section(t.basePoint.coords.coord,root+1,t.basePoint.coords.coord.length));
    c.stepBasePointInBranchesCovarianant(section(t.basePoint.coords.coord,root+1,t.basePoint.coords.coord.length));
    if(c.basePoint.compareTo(t.basePoint)!=0){
       println(" something was impmenebted wrong in distanceTo, fix it :"+c.basePoint.toString()+ "  :"+t.basePoint.toString());
       return 0;
    }
    return c.relativeTransform.distanceTo(t.relativeTransform);
  }
  
  LatticeTransform copy(){
    return new LatticeTransform(relativeTransform.copy(),basePoint.coords.copy(),system); 
  }

}
