/// PROCESSING 3D!!!
float x,y,z;
int[][][] state;
float[][][] drawState;
int[][][]ageState;
int[][][] nextState;
int[] rule={0,1,0,0,0,0,1,0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0};
int size=31;
int[] colors={color(255,0,0),color(0,255,0),color(0,0,255),color(255,255,0),color(255,0,255),color(0,255,255),color(120,120,255),color(120,225,120),color(255,120,120)};
//{color(255,0,0),color(200,55,0),color(100,155,0),color(0,255,0),color(0,200,55),color(0,100,155),color(0,0,255),color(55,0,100),color(155,0,100)};

void Set(){
  state=new int[size][size][size];
    for(int i= size/2-3;i< size/2+ 3; i++){
    for(int j= size/2-3;j< size/2+ 3; j++){
      for(int k= size/2-3;k< size/2+ 3; k++){
        state[i][j][k]= random(1)>0.8? 1:0;
       }
    }
  }
  nextState=arrCopy(state);
  for(int i=1; i<rule.length;i++){
   rule[i]= random(1)>0.9? 1:0; 
  }
}
void setup() {
  size(600,600,P3D);
  state=new int[size][size][size];
  
  Set();

  //for(int i= 0;i< size; i++){
  //  for(int j= 0;j< size; j++){
  //    for(int k= 0;k< size; k++){
  //      state[i][j][k]= random(1.0)>0.97? 1:0;
  //     }
  //  }
  //}
  
  
  ageState=new int[size][size][size];
  drawState=arrFloatCopy(state);
  nextState=arrCopy(state);
}
void draw(){
  //x=(mouseX-0.5*width)/width;
  //y=(mouseY-0.5*height)/height;
  x+=0.002;
  y+=sin(x)*0.002+0.001;
  background(0);
  //lights();
  spotLight(255, 255, 255, width/2, height/2, 400, 0, 0, -1, PI/4, 2);
  
  //Update
  int speed= 15;
  int wait= 25;
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
   updateAgeState(state);
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
           //fill(255,0,0,drawState[i][j][k]*256);
           color c=colors[ageState[i][j][k]%9];
           fill(red(c),green(c),blue(c),drawState[i][j][k]*256);
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
void updateAgeState(int[][][] arr){
   for(int i=0;i<arr.length;i++){
     for(int j=0;j<arr[0].length;j++){
       for(int k=0;k<arr[0][0].length;k++){
         if(arr[i][j][k]==1){
            ageState[i][j][k]++; 
         }else{
            ageState[i][j][k]=0; 
         }
       }
     }
   }
}
void mousePressed(){  
  Set();
}