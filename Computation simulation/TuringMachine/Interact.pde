boolean MouseIn(int x,int y,int Width,int Height){
  return (mouseX>x)&&(mouseX<x+Width)&&(mouseY>y)&&(mouseY<y+Height);
}