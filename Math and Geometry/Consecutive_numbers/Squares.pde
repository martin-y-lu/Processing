import processing.core.PVector;
final Squares nullSquare= new Squares(vec(0,0),0,0,new int[0][0])._Visible(false); 
class Squares{
  float size=0.15f;
  final float fillFactor=0.9f;
  boolean visible=true;
  PVector origin;
  float angle=0;
  int xShift=0;
  int yShift=0;
  int[][] shape;
  //int[][] shape= new int[][]{new int[]{0,-1},new int[]{0,0},new int[]{0,1},new int[]{0,2}};
  //new int[][]{new int[]{0,-1+2},new int[]{0,0+2},new int[]{0,1+2},new int[]{0,2+2}};
  public Squares(PVector _origin, int _xShift,int _yShift, int[][] _shape){
    //, int _xShift, int[][] _shape
    origin=_origin;
    xShift=_xShift;
    yShift=_yShift;
    shape=_shape;
  }
   public Squares(PVector _origin, int _xShift,int _yShift){
    //, int _xShift, int[][] _shape
    origin=_origin;
    xShift=_xShift;
    yShift=_yShift;
  }
  public Squares _Visible(boolean _visible){
    visible=_visible;
    return this;
  }
  public void draw(){
    if(!visible) return;
    push();
    translate(origin);
    rotate(angle);
    for(int i=0;i<shape.length;i++){
      int yOffset= shape[i][0];
      int h=shape[i][1];
      boolean up=true;
      if(h<0){
        yOffset+=h;
        h=-h;
        up=false;
      }
      for(int j=0;j<h;j++){
        if(up){
          if(yOffset<0&yOffset+j<0){
            fill(0,255,0);
          }else{
            fill(255);
          }
        }else{
          fill(255,0,0);
        }
         //square(PVadd(origin,vec(xShift+i,yOffset+yShift+j).mult(size)),size*fillFactor);
         square(vec(xShift+i+(1-fillFactor)/2,yOffset+yShift+j+(1-fillFactor)/2).mult(size),size*fillFactor);
      }
      if(yOffset==0&&h==0&&(i+xShift>=0)){
         stroke(255);
         strokeWeight(0.02);
         line(vec(xShift+i,yOffset).mult(size),vec(xShift+i+fillFactor,yOffset+yShift).mult(size));
         noStroke();
      }
       //debug:{
        fill(0,255,0);
        circle(vec(),0.05);
      //}
    }
    pop();
  }
  public Squares split_diag(int rip){
    int[][] new_shape= new int[shape.length][2];
    for(int i=0; i<shape.length;i++){
      shape[i][1]-=rip;
      new_shape[i][0]=shape[i][1];
      new_shape[i][1]=rip;
    }
    return new Squares(vec(origin),xShift,yShift,new_shape);
  }
  public Squares split_left(int rip){
    int[][] new_shape= new int[rip][2];
    for(int i=0; i<new_shape.length;i++){
      new_shape[i][0]=shape[i][0];
      new_shape[i][1]=shape[i][1];
      shape[i][0]=0;
      shape[i][1]=0;
    }
    return new Squares(vec(origin),xShift,yShift,new_shape)._Visible(visible);
  }
  public Squares split_top(int y){
    println("HELLO");
    int[][] new_shape= new int[shape.length][2];
    for(int i=0; i<new_shape.length;i++){
       if(shape[i][0]+shape[i][1]>y){
         new_shape[i][0]=y;
         new_shape[i][1]=shape[i][0]+shape[i][1]-y;
         shape[i][1]=y-shape[i][0];
       }else{
         new_shape[i][0]=1;
         new_shape[i][1]=0;
       }
    }
    return new Squares(vec(origin),xShift,yShift,new_shape)._Visible(visible);
  }
  public void set(Squares squares){
    origin=squares.origin;
    xShift=squares.xShift;
    visible=squares.visible;
    shape=new int[squares.shape.length][2];
    for(int i=0;i<shape.length;i++){
      for(int j=0;j<2;j++){
        shape[i][j]=squares.shape[i][j]; 
      }
    }
  }
  public Squares clone(){
    PVector _origin=vec(origin);
    boolean _visible=visible;
    int[][] _shape=new int[shape.length][2];
    for(int i=0;i<shape.length;i++){
      for(int j=0;j<2;j++){
        _shape[i][j]=shape[i][j]; 
      }
    }
    return new Squares(_origin,xShift,yShift,_shape)._Visible(_visible);
  }
  public Squares merge(Squares squares){
    int leftX= min(xShift,squares.xShift);
    //print("leftX: "+ leftX);
    int rightX=max(xShift+shape.length,squares.xShift+squares.shape.length);
    int wide= rightX-leftX;
    //print("wide: "+wide);
    int[][] newShape= new int[wide][2];
    for(int i=0;i<wide;i++){
      int maxY=0;
      int minY=100000000;
      {
        int indexIn= i+leftX-xShift; 
        if(INrange(0,shape.length-1,indexIn)){
          int a= shape[indexIn][0]+yShift;
          int b= shape[indexIn][0]+shape[indexIn][1]+yShift;
          if(a>maxY){maxY=a;}
          if(a<minY){minY=a;}
          if(b>maxY){maxY=b;}
          if(b<minY){minY=b;}
        }
      }
      {
        int indexIn= i+leftX-squares.xShift; 
        if(INrange(0,squares.shape.length-1,indexIn)){
          int a= squares.shape[indexIn][0]+squares.yShift;
          int b= squares.shape[indexIn][0]+squares.shape[indexIn][1]+squares.yShift;
          if(a>maxY){maxY=a;}
          if(a<minY){minY=a;}
          if(b>maxY){maxY=b;}
          if(b<minY){minY=b;}
        }
      }
      if(minY<0){
        newShape[i][0]=maxY;
        newShape[i][1]=minY-maxY;
      }else{
        newShape[i][0]=minY;
        newShape[i][1]=maxY-minY;
      }
    }
    return new Squares(vec(origin),leftX,0,newShape);
    //xShift=leftX;
    //yShift=0;
    //shape=newShape;
  }
  Squares _SetShapeSum(int n,int c){
    int[][] _shape= new int[n][2];
    for(int i=0;i<n;i++){
      _shape[i][0]=0;
      _shape[i][1]=c+i;
    }
    shape=_shape;
    return this;
  }
  Squares _SetShapeRect(int n,int c){
    int[][] _shape= new int[n][2];
    for(int i=0;i<n;i++){
      _shape[i][0]=0;
      _shape[i][1]=c;
    }
    shape=_shape;
    return this;
  }
}
