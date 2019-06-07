float Scale=65;
Boolean start=false;
//int[][] arr={{1,2,3,4},{3,4,2,1},{4,3,1,2},{2,1,4,3}};
//int[][] arr={{-1,-1,3,4},{3,-1,2,-1},{4,-1,1,-1},{2,1,4,-1}};
//int[][] arr={{8,7,6,9,-1,-1,-1,-1,-1}
//,{-1,1,-1,-1,-1,6,-1,-1,-1}
//,{-1,4,-1,3,-1,5,8,-1,-1}
//,{4,-1,-1,-1,-1,-1,2,1,-1}
//,{-1,9,-1,5,-1,-1,-1,-1,-1}
//,{-1,5,-1,-1,4,-1,3,-1,6}
//,{-1,2,9,-1,-1,-1,-1,-1,8}
//,{-1,-1,4,6,9,-1,1,7,3}
//,{-1,-1,-1,-1,-1,1,-1,-1,4}};

int[][] arr={
{1,-1,-1,4,8,9,-1,-1,6}
,{7,3,-1,-1,-1,-1,-1,4,-1}
,{-1,-1,-1,-1,-1,1,2,9,5}
,{-1,-1,7,1,2,-1,6,-1,-1}
,{5,-1,-1,7,-1,3,-1,-1,8}
,{-1,-1,6,-1,9,5,7,-1,-1}
,{9,1,4,6,-1,-1,-1,-1,-1}
,{-1,2,-1,-1,-1,-1,-1,3,7}
,{8,-1,-1,5,1,2,-1,-1,4}};
//int[][] arr={
//{-1,1,9,12,-1,5,-1,-1,6,-1,-1,-1,-1,3,13,-1}
//,{-1,-1,3,-1,1,12,-1,-1,9,16,-1,5,-1,4,-1,-1}
//,{7,6,-1,10,-1,-1,-1,-1,-1,1,8,-1,14,-1,2,-1}
//,{16,15,-1,-1,11,-1,4,8,-1,-1,-1,-1,-1,-1,12}
//,{-1,10,8,11,-1,3,-1,-1,-1,-1,7,13,-1,9,14,6}
//,{-1,12,15,-1,-1,10,8,-1,-1,-1,-1,-1,16,2,5,-1}
//,{-1,2,-1,3,9,13,7,-1,-1,10,-1,1,-1,8,-1,-1}
//,{-1,-1,-1,16,-1,15,-1,6,8,-1,-1,14,-1,-1,-1,-1}
//,{-1,-1,-1,-1,5,-1,-1,15,13,-1,9,-1,7,-1,-1,-1}
//,{-1,-1,1,-1,3,-1,14,-1,-1,2,5,10,11,-1,16,-1}
//,{-1,14,11,15,-1,-1,-1,-1,-1,7,3,-1,-1,13,4,-1}
//,{5,9,16,-1,13,2,-1,-1,-1,-1,1,-1,8,15,3,-1}
//,{15,-1,-1,-1,-1,-1,-1,-1,3,14,-1,2,-1,-1,7,8}
//,{-1,16,-1,5,-1,6,3,-1,-1,-1,-1,-1,2,-1,12,4}
//,{-1,-1,14,-1,8,-1,2,13,-1,-1,15,7,-1,5,-1,-1}
//,{-1,8,2,-1,-1,-1,-1,14,-1,-1,11,-1,1,10,6,-1}};
SudokuGame Game=new SudokuGame(arr);
float Temp=4;
float decay=0.9995;
void setup(){
    frameRate(60);
    size(1200, 700);
    
}
void draw(){
  background(255); 
  fill(0);
  
  int HLX=floor((mouseX-100)/Scale);
  int HLY=floor((mouseY-100)/Scale);
  text(HLX+" :"+HLY,10,840);
  Game.DrawBG();
  fill(200);
  rect(HLX*Scale+100,HLY*Scale+100,Scale,Scale);
  if (keyPressed) {
    try {
      int num= Integer.parseInt((key+"").trim());
      Game.WriteValue(HLX,HLY,num);
    } catch (NumberFormatException e) {
    }
  }
  Game.Draw();
  text(Game.Size,30,35);
  if(Game.Solved()){
    text("Solved",100,35);
  }else{
    text("Not Solved",100,35);
    
  }
  text(Game.Cost(),400,35);
  text(Temp,480,35);
  if(start){
    for(int i=0;i<1000;i++){
      Anneal();
    }
  }
  
  //text(ArrToString(Game.Square(0,0)),10,320);
}
void Anneal(){
  if(Game.Cost()!=0){
    int X1=0;
    int Y1=0;
    X1=floor(random(1)*Game.Size*Game.Size);
    Y1=floor(random(1)*Game.Size*Game.Size);
    while(!Game.Playable(X1,Y1)){
      X1=floor(random(1)*Game.Size*Game.Size);
      Y1=floor(random(1)*Game.Size*Game.Size);
    }
    
    int X2=0;
    int Y2=0;
    X2=floor(random(1)*Game.Size*Game.Size);
    Y2=floor(random(1)*Game.Size*Game.Size);
    while(!Game.Playable(X2,Y2)||((X1==X2)||(Y1==Y2))){
      X2=floor(random(1)*Game.Size*Game.Size);
      Y2=floor(random(1)*Game.Size*Game.Size);
    }
    print(X1+" : "+Y1+"   -   "+X2+" : "+Y2+"        ");
    int oldCost=Game.Cost();
    Game.Swap(X1,Y1,X2,Y2);
    int newCost=Game.Cost();
    if(newCost>oldCost){
      if(random(1)>exp(-float(newCost-oldCost)/Temp)){
        Game.Swap(X1,Y1,X2,Y2);
      }
    }
    if(newCost==oldCost){
      Temp+=3.5*(1-decay);
    }
    Temp*=decay;
  }
}
void mousePressed(){
  Game.FillGrid();
  start= true;
}