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
