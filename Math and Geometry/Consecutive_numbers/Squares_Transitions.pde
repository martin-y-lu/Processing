


class SquareLerpTransition extends AnimTransition{
  Squares squares;
  float speed=-1;
  PVector startPos;
  float startAngle;
  
  PVector endPos;
  float endAngle=-10;
  
  PVector translate;
  EaseFunction ease=new LinearEaseFunction();
  SquareLerpTransition(int _len,Squares _squares){
     super(_len);
     squares=_squares;
  }
  SquareLerpTransition _EndPos(PVector _endPos){
    endPos=_endPos;
    return this;
  }
  SquareLerpTransition _EndAngle(float _endAngle){
    endAngle=_endAngle%(TAU);
    return this;
  }
  SquareLerpTransition _Translate(PVector _translate){
    translate= _translate;
    return this;
  }
  SquareLerpTransition _Speed(float _speed){
    speed=abs(_speed);
    return this;
  }
  SquareLerpTransition _Ease(EaseFunction _ease){
    ease=_ease;
    return this;
  }
  SquareLerpTransition _Ease(){
    ease=EASE;
    return this;
  }
  void start(){
    startPos=squares.origin;
    startAngle=squares.angle;
    if(endPos==null){
      if(translate!=null){
        endPos=PVadd(startPos,translate);
      }else{
        endPos=startPos;
      }
    }
    commitAngle();
    commitSpeed();
  }
  void commitAngle(){
    if(endAngle==-10){
      //println("setting as start angle");
      endAngle=startAngle; 
    }
  }
  void commitSpeed(){
    if(translate==null){
      translate=PVsub(endPos,startPos); 
    }
    if(speed!=-1){
      _Len(round(PVmag(translate)/speed)); 
    }
  }
  void play(int frame, float fract){
    fract= ease.ease(fract);
    squares.origin=PVlerp(startPos,endPos,fract);
    squares.angle= lerp(startAngle,endAngle,fract);
  }
  void end(){
    squares.origin=endPos;
    squares.angle=endAngle;
  }
}
class SquareModifyTransition extends SquareLerpTransition{
  Squares squares;
  int new_xShift=-1000000;
  int new_yShift=-1000000;
  boolean maintainPos=false;
  SquareModifyTransition(int _len,Squares _squares){
    super(_len,_squares);
    squares=_squares;
  }
  SquareModifyTransition _XShift(int _new_xShift){
    new_xShift=_new_xShift;
    return this;
  }
  SquareModifyTransition _YShift(int _new_yShift){
    new_yShift=_new_yShift;
    return this;
  }
  SquareModifyTransition _MaintainPos(){
    return _MaintainPos(true);
  }
  SquareModifyTransition _MaintainPos(boolean _maintainPos){
    maintainPos=_maintainPos;
    return this;
  }
  void start(){
    startPos=squares.origin;
    if(new_xShift<=-1000000){
      new_xShift=squares.xShift; 
    }
    if(new_yShift<=-1000000){
      new_yShift=squares.yShift; 
    }
    //if(maintainPos){
    //  endPos=startPos;
    //}else{
      endPos=PVadd(startPos,vec((new_xShift-squares.xShift)*squares.size,(new_yShift-squares.yShift)*squares.size));
    //}
    commitAngle();
    commitSpeed();
  }
  void end(){
    //if(maintainPos){
    //  squares.origin=  PVadd(startPos,vec(-(new_xShift)*Squares.size,-(new_yShift)*Squares.size));
    //}else{
      squares.origin=startPos;
    //}
    squares.xShift=new_xShift;
    squares.yShift=new_yShift;
    squares.angle=endAngle;
    int rot= round(squares.angle/(PI*0.5));
    switch(rot){
      case 0:
        break;
      case 1:
        //todo
        int store_xShift=squares.xShift;
        squares.xShift=squares.yShift;
        squares.yShift=-store_xShift;
        break;
      case 2:
        squares.xShift*=-1;
        squares.yShift*=-1;
        break;
      case 3:
        store_xShift=squares.xShift;
        squares.xShift=-squares.yShift;
        squares.yShift=store_xShift;
    }
    //squares.commitAngle();x
  }
}
class SquareModifyEvent extends AnimEvent{
  Squares squares;
  SquareModifyEvent(Squares _squares){
    squares=_squares;  
  }
  int new_xShift=-1000000;
  int new_yShift=-1000000;
    SquareModifyEvent _XShift(int _new_xShift){
    new_xShift=_new_xShift;
    return this;
  }
  SquareModifyEvent _YShift(int _new_yShift){
    new_yShift=_new_yShift;
    return this;
  }
  public void occur(){
    if(new_xShift==-1000000){
      new_xShift=squares.xShift;
    }
    if(new_yShift==-1000000){
      new_yShift=squares.yShift;
    }
    squares.origin=PVadd(squares.origin,vec((new_xShift-squares.xShift)*squares.size,(new_yShift-squares.yShift)*squares.size));
    squares.xShift=-new_xShift;
    squares.yShift=-new_yShift;
  }
}
