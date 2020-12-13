static PVector UPPER_LEFT;
static PVector UPPER_RIGHT;
static PVector LOWER_LEFT;
static PVector LOWER_RIGHT;
static float SCALE=100;
static EaseFunction EASE=new SineEaseFunction().iterate(2);
static abstract class EaseFunction{
  abstract float ease(float x);
  float ease_iterate(float x,int iter){
    if(iter<=0){ iter=1; }
    for(int i=0;i<iter;i++){
      x=ease(x);
    }
    return x;
  }
  EaseFunction iterate(int iter){
    return new IterateEase(this,iter); 
  }
  boolean verify(){
    if(abs(ease(0))>0.05){
      return false;
    }
    if(abs(ease(1)-1)>0.05){
      return false;
    }
    return true;
  }
}
class EaseException extends Exception{
}
static class IterateEase extends EaseFunction{
  EaseFunction ease;
  int iter=1;
  IterateEase(EaseFunction _ease, int _iter){
    ease=_ease;
    iter=_iter;
  }
  float ease(float x){
    return ease.ease_iterate(x,iter); 
  }
}

static class LinearEaseFunction extends EaseFunction{  
  float ease(float x){
    return x; 
  }
}
static class SineEaseFunction extends EaseFunction{
  float ease(float x){
    return (1-cos(PI*x))/2; 
  }
}
