/// PROCESSING 3D!!!
float x,y,z;
int[][][] state;
float[][][] drawState;
int[][][] nextState;
int[] rule={0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0};
int size=31;
void setup() {
  size(600,600,P3D);
  state=new int[size][size][size];
  
  //for(int i= size/2-3;i< size/2+ 3; i++){
  //  for(int j= size/2-3;j< size/2+ 3; j++){
  //    for(int k= size/2-3;k< size/2+ 3; k++){
  //      state[i][j][k]= random(1)>0.8? 1:0;
  //     }
  //  }
  //}
  for(int i= 0;i< size; i++){
    for(int j= 0;j< size; j++){
      for(int k= 0;k< size; k++){
        state[i][j][k]= random(1.0)>0.95? 1:0;
       }
    }
  }
  
  
  //for(int i=0; i<rule.length;i++){
  // rule[i]= random(1)>0.9? 1:0; 
  //}
  drawState=arrFloatCopy(state);
  nextState=arrCopy(state);
}
void draw(){
  x=(mouseX-0.5*width)/width;
  y=(mouseY-0.5*height)/height;
  background(0);
  //lights();
  spotLight(255, 0, 0, width/2, height/2, 400, 0, 0, -1, PI/4, 2);
  
  //Update
  int speed= 30;
  int wait= 50;
  if(frameCount%(speed+wait)==0){
    nextState=new int[size][size][size];
    for(int i=0;i<size;i++){
     for(int j=0;j<size;j++){
      for(int k=0;k<size;k++){
        nextState[i][j][k]=rule[numNeigbors(i,j,k)];
      }
     }
    }
  }else if(frameCount%(speed+wait)==speed){
   drawState=arrFloatCopy(nextState);
   state=nextState;
  }else if(frameCount%(speed+wait)<speed){//ease in
    float lerp=(float)(frameCount%(speed+wait))/(speed);
    println(lerp);
    for(int i=0;i<size;i++){
     for(int j=0;j<size;j++){
      for(int k=0;k<size;k++){
        drawState[i][j][k]=lerp((float)state[i][j][k],(float)nextState[i][j][k],lerp);
      }
     }
    }
    
  }
 
  //stroke(255);
  noStroke();
  
  
  pushMatrix();
  translate(width*0.5, height*0.5, -60);
  
  rotateX(-y*3.0);
  rotateY(x*3.0);
  
  translate(-((float)size)*10.0/2.0,-((float)size)*10/2.0,-((float)size)*10.0/2.0);
  for(int i=0;i<size;i++){
    pushMatrix();
    for(int j=0;j<size;j++){
      pushMatrix();
      for(int k=0;k<size;k++){
         if(drawState[i][j][k]>0){
           fill(255,0,0,drawState[i][j][k]*256);
           box(10);
         }
         translate(0,10,0);
      }
      popMatrix();
      translate(10,0,0);
    } 
    popMatrix();
    translate(0,0,10);
  }
  popMatrix();
}
int numNeigbors(int i,int j,int k){ // returns 0 through 26
  int count=0; 
  count+=getState(i+1,j,k);
  count+=getState(i-1,j,k);
  
  count+=getState(i,j+1,k);
  count+=getState(i,j-1,k);
  
  count+=getState(i,j,k+1);
  count+=getState(i,j,k-1);
  
  count+=getState(i+1,j+1,k);
  count+=getState(i+1,j-1,k);
  count+=getState(i-1,j+1,k);
  count+=getState(i-1,j-1,k);
  
  count+=getState(i+1,j,k+1);
  count+=getState(i+1,j,k-1);
  count+=getState(i-1,j,k+1);
  count+=getState(i-1,j,k-1);
  
  count+=getState(i,j+1,k+1);
  count+=getState(i,j+1,k-1);
  count+=getState(i,j-1,k+1);
  count+=getState(i,j-1,k-1);
  
  count+=getState(i+1,j+1,k+1);
  count+=getState(i+1,j+1,k-1);
  count+=getState(i+1,j-1,k+1);
  count+=getState(i-1,j+1,k+1);
  count+=getState(i-1,j-1,k+1);
  count+=getState(i-1,j+1,k-1);
  count+=getState(i+1,j-1,k-1);
  count+=getState(i-1,j-1,k-1);
  
  return count;
}
int getState(int i,int j,int k){
  if (i<0){ return 0;}
  if (i>=state.length){ return 0;}
  if (j<0){ return 0;}
  if (j>=state[0].length){ return 0;}
  if (k<0){ return 0;}
  if (k>=state[0][0].length){ return 0;}
  
  return state[i][j][k]; 
}
int[][][] arrCopy(int[][][] arr){
  int[][][] newArr=new int[arr.length][arr[0].length][arr[0][0].length];
  for(int i=0;i<arr.length;i++){
   for(int j=0;j<arr[0].length;j++){
     for(int k=0;k<arr[0][0].length;k++){
        newArr[i][j][k]=arr[i][j][k];
      }
    }
  }
  return newArr;
}
float[][][] arrFloatCopy(int[][][] arr){
  float[][][] newArr=new float[arr.length][arr[0].length][arr[0][0].length];
  for(int i=0;i<arr.length;i++){
   for(int j=0;j<arr[0].length;j++){
     for(int k=0;k<arr[0][0].length;k++){
        newArr[i][j][k]=(float)arr[i][j][k];
      }
    }
  }
  return newArr;
}