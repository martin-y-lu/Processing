public static class IntVector{
  int x;
  int y;
  IntVector(int dX,int dY){
     x=dX; y = dY;
  }
  IntVector(){
     x=0; y=0; 
  }
  public void set(int dX,int dY){
    x=dX; y= dY; 
  }
  void add(IntVector v){
    x+=v.x;
    y+=v.y;
  }
  
  void scale(int s){
     x*=s;
     y*=s;
  }
  void neg(){
     scale(-1);
  }
  int magnatude(){
     return mag(); 
  }
  int mag(){
    return abs(x)+abs(y); 
  }
  IntVector normalise(){//Normalising to a intVector of length 2
    if(x>0&&y==0){
      return new IntVector(2,0);  
    }else if(x>0&&y>0){
      return new IntVector(1,1); 
    }else if(x==0&&y>0){
      return new IntVector(0,2); 
    }else if(x<0&&y>0){
      return new IntVector(-1,1); 
    }else if(x<0&&y==0){
      return new IntVector(-2,0); 
    }else if(x<0&&y<0){
      return new IntVector(-1,-1);
    }else if(x==0&&y<0){
      return new IntVector(0,-2);
    }else if(x>0&&y<0){
      return new IntVector(1,-1); 
    }
    return new IntVector();
  }
  IntVector copy(){
    return new IntVector(x,y); 
  }
  static IntVector add(IntVector a,IntVector b){
    return new IntVector(a.x+b.x,a.y+b.y);
  }
   static IntVector subtract(IntVector a,IntVector b){
    return new IntVector(a.x-b.x,a.y+-b.y);
  }
}
