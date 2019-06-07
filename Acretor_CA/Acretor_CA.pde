int NumStates=9;
int scale=3;
int[][] stateArray;
color[] StateColors={color(0),color(255),color(255,0,0),color(0,255,0),color(0,0,255),color(255,255,0),color(255,0,255),color(0,255,255),color(255,255,100),color(255,100,255),color(100,255,255)};
int Type=0;
int[][][][] Rule;

int Width;
int Height;
int time=0;
void setup(){
    frameRate(60);
    //fullScreen();
    size(800, 800);
    
    Width=floor(width/scale);
    Height=floor(height/scale);
    stateArray= new int[Width][Height];
    if(Type==0){
     Rule= new int[5][5][1][1];
    }
    if(Type==1){
     Rule= new int[NumStates+1][NumStates+1][NumStates+1][NumStates+1];
    }
    if(Type==2){
     Rule= new int[2][2][2][2];
    }
    reset();
    
}
void reset(){
    if(Type==0){
      for(int a=0;a<5;a++){
        for(int b=0;b<5;b++){
           if(random(1)<0.10+0.08*(1.5*a+0.7*b)){
             Rule[a][b][0][0]=floor(random(NumStates+1));
           }else{
             Rule[a][b][0][0]=0;
           }
           
        }
      }
    }
    if(Type==1){
      for(int a=0;a<NumStates;a++){
        for(int b=0;b<NumStates;b++){
          for(int c=0;c<NumStates;c++){
            for(int d=0;d<NumStates;d++){
             if(random(1)<0.6){
               Rule[a][b][c][d]=floor(random(NumStates+1));
             }else{
               Rule[a][b][c][d]=0;
             }  
            }
          }
        }
      }
    }
    if(Type==2){
      for(int a=0;a<2;a++){
        for(int b=0;b<2;b++){
          for(int c=0;c<2;c++){
            for(int d=0;d<2;d++){
             if(random(1)<0.6){
               Rule[a][b][c][d]=floor(random(NumStates+1));
             }else{
               Rule[a][b][c][d]=0;
             }  
            }
          }
        }
      }
    }
    int center=floor(Height/2.0);
    for(int x=0;x<Width;x++){
      for(int y=0;y<Height;y++){
        stateArray[x][y]=0;
        if((x>center)&&(x<center+5)&&(y>center)&&(y<center+5)){
          //stateArray[x][y]=floor(random(NumStates))+1;//(x+y)%2+1;
          stateArray[x][y]=floor(random(NumStates+1));//(x+y)%2+1;
        }
      }
    }
}
void draw(){
  noStroke();
  background(10,10,20); 
  fill(120,12,0);
  for(int x=0;x<Width;x++){
    for(int y=0;y<Height;y++){
      fill(StateColors[stateArray[x][y]]);
      rect(x*scale,y*scale,scale,scale);
    }
  }
  int[][] newStateArray=new int[Width][Height];
  boolean grow=false;
  for(int x=1;x<Width-1;x++){
    for(int y=1;y<Height-1;y++){
       int State= stateArray[x][y];
       newStateArray[x][y]=State;
       if(State==0){
         newStateArray[x][y]=UpdatePixel(x,y);
         if(newStateArray[x][y]!=0){
          grow=true; 
         }
       }

    }
  }
  stateArray=newStateArray;
  time++;
  fill(255);
  if(grow){
    text("Growing",10,10);
  }
  if((time>200)||(!grow)){
    reset();
    time=0;
  }
}
int UpdatePixel(int x,int y){
  if(Type==0){
     int NumFace=0;
     int NumCorn=0;
     if(stateArray[x+1][y]!=0){NumFace++;};
     if(stateArray[x-1][y]!=0){NumFace++;};
     if(stateArray[x][y+1]!=0){NumFace++;};
     if(stateArray[x][y-1]!=0){NumFace++;};
     if(stateArray[x+1][y+1]!=0){NumCorn++;};
     if(stateArray[x-1][y+1]!=0){NumCorn++;};
     if(stateArray[x+1][y-1]!=0){NumCorn++;};
     if(stateArray[x-1][y-1]!=0){NumCorn++;};
     if((NumFace>0)||(NumFace>0)){
       return(Rule[NumFace][NumCorn][0][0]);
     }
   }if(Type==1){
     int right=stateArray[x+1][y];
     int left=stateArray[x-1][y];
     int down=stateArray[x][y+1];
     int up=stateArray[x][y-1];
     if(
     (right!=0)||
     (left!=0)||
     (down!=0)||
     (up!=0)
     ){
       return(Rule[right][left][down][up]);
     }
   }if(Type==2){
     int right=0;
     int left=0;
     int down=0;
     int up=0;
     if(stateArray[x+1][y]!=0){right=1;}
     if(stateArray[x-1][y]!=0){left=1;}
     if(stateArray[x][y+1]!=0){down=1;}
     if(stateArray[x][y-1]!=0){up=1;}
     
     if(
     (right!=0)||
     (left!=0)||
     (down!=0)||
     (up!=0)
     ){
       return(Rule[right][left][down][up]);
     }
   }
  return stateArray[x][y];
}
void keyPressed() {
  if (key==' ') {
    reset();
  }
}