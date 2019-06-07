boolean MouseIn(float x,float y,float Width,float Height){
  return (MouseX>x)&&(MouseX<x+Width)&&(MouseY>y)&&(MouseY<y+Height);
}
boolean MouseIn(PVector Pos, PVector Size){
  return MouseIn(Pos.x,Pos.y,Size.x,Size.y);
}