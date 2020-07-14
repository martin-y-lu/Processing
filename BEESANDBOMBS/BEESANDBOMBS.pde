int prevCount;
int SCENE;
int[]SceneLength={40,40,40,40,40,40,40,40};
int[]SceneWait={0,0,0,0,0,0,0,0};
int numScenes=8;
boolean DONE=false;
void setup(){
  size(1000,1000);
  noStroke();
  colorMode(MULTIPLY);
}
void draw(){
  float n= float(frameCount-prevCount)/SceneLength[SCENE];
  if(n>1){n=1;}
  //float s= n<.5 ? 4*n*n*n : (n-1)*(2*n-2)*(2*n-2)+1;
  float s= n<.5 ? 8*n*n*n*n : 1-8*(--n)*n*n*n;
  float t=0;
  scale(100);
  switch(SCENE){
    case 0:
      fill(0);
      rect(0,0,10,10);
      //background(255,0,0);
      translate(-5,-5);
      for(int x=-4;x<9;x++){
        pushMatrix();
        for(int y=-4;y<9;y++){
          if((x+y+10)%2==1){
            fill(255);
            rect(-1,-1,2,2);
          }
          translate(0,2);
        }
        popMatrix();
        translate(2,0);
      }
    case 1:
      t=map(s,0,1,1,2.0/(1+sqrt(3)));
      fill(255);
      rect(0,0,10,10);
      translate(-5,-5);
      for(int x=-4;x<9;x++){
        pushMatrix();
        for(int y=-4;y<9;y++){
          if((x+y+10)%2==1){
            fill(255);
            rect(-t,-t,2*t,2*t);
            fill(0);
            triangle(-t,-t,t,-t,0,-2);
            triangle(t,-t,t,t,2,0);
            triangle(t,t,-t,t,0,2);
            triangle(-t,t,-t,-t,-2,0);
          }
          translate(0,2);
        }
        popMatrix();
        translate(2,0);
      }
    case 2:
      t=2.0/(1+sqrt(3));
      fill(255);
      rect(0,0,10,10);
      translate(-5,-5);
      for(int x=-4;x<9;x++){
        pushMatrix();
        for(int y=-4;y<9;y++){
          if((x+y+10)%2==1){
            pushMatrix();
            if((x+10)%2==0&&(y+10)%2==1){
              rotate(n*PI/2); 
            }else{
              rotate(TWO_PI-n*PI/2);
            }
            fill(255);
            rect(-t,-t,2*t,2*t);
            fill(0);
            triangle(-t,-t,t,-t,0,-2);
            triangle(t,-t,t,t,2,0);
            triangle(t,t,-t,t,0,2);
            triangle(-t,t,-t,-t,-2,0);
            popMatrix();
          }
          translate(0,2);
        }
        popMatrix();
        translate(2,0);
      }
    case 3:
      t=map(s,1,0,1,2.0/(1+sqrt(3)));
      fill(255);
      rect(0,0,10,10);
      translate(-5,-5);
      for(int x=-4;x<9;x++){
        pushMatrix();
        for(int y=-4;y<9;y++){
          if((x+y+10)%2==1){
            fill(255);
            rect(-t,-t,2*t,2*t);
            fill(0);
            triangle(-t,-t,t,-t,0,-2);
            triangle(t,-t,t,t,2,0);
            triangle(t,t,-t,t,0,2);
            triangle(-t,t,-t,-t,-2,0);
          }
          translate(0,2);
        }
        popMatrix();
        translate(2,0);
      }
    case 4:
     fill(255);
      rect(0,0,10,10);
      //background(255,0,0);
      translate(-3,-5);
      for(int x=-4;x<9;x++){
        pushMatrix();
        for(int y=-4;y<9;y++){
          if((x+y+10)%2==1){
            fill(0);
            rect(-1,-1,2,2);
          }
          translate(0,2);
        }
        popMatrix();
        translate(2,0);
      }
    case 5:
      t=map(s,0,1,1,2.0/(1+sqrt(3)));
      fill(0);
      rect(0,0,10,10);
      translate(-3,-5);
      for(int x=-4;x<9;x++){
        pushMatrix();
        for(int y=-4;y<9;y++){
          if((x+y+10)%2==1){
            fill(0);
            rect(-t,-t,2*t,2*t);
            fill(255);
            triangle(-t,-t,t,-t,0,-2);
            triangle(t,-t,t,t,2,0);
            triangle(t,t,-t,t,0,2);
            triangle(-t,t,-t,-t,-2,0);
          }
          translate(0,2);
        }
        popMatrix();
        translate(2,0);
      }
    case 6:
      t=2.0/(1+sqrt(3));
      fill(0);
      rect(0,0,10,10);
      translate(-3,-5);
      for(int x=-4;x<8;x++){
        pushMatrix();
        for(int y=-4;y<8;y++){
          if((x+y+10)%2==1){
            pushMatrix();
            if((x+10)%2==0&&(y+10)%2==1){
            rotate(n*PI/2);
            }else{
            rotate(TWO_PI-n*PI/2);
            }
            fill(0);
            rect(-t,-t,2*t,2*t);
            fill(255);
            triangle(-t,-t,t,-t,0,-2);
            triangle(t,-t,t,t,2,0);
            triangle(t,t,-t,t,0,2);
            triangle(-t,t,-t,-t,-2,0);
            popMatrix();
          }
          translate(0,2);
        }
        popMatrix();
        translate(2,0);
      }
    case 7:
      t=map(s,1,0,1,2.0/(1+sqrt(3)));
      fill(0);
      rect(0,0,10,10);
      translate(-3,-5);
      for(int x=-4;x<9;x++){
        pushMatrix();
        for(int y=-4;y<9;y++){
          if((x+y+10)%2==1){
            fill(0);
            rect(-t,-t,2*t,2*t);
            fill(255);
            triangle(-t,-t,t,-t,0,-2);
            triangle(t,-t,t,t,2,0);
            triangle(t,t,-t,t,0,2);
            triangle(-t,t,-t,-t,-2,0);
          }
          translate(0,2);
        }
        popMatrix();
        translate(2,0);
      }
  }
  if(frameCount-prevCount>SceneLength[SCENE]+SceneWait[SCENE]){
    prevCount=frameCount;
    SCENE++;
    if(SCENE>=numScenes){
      SCENE=0; 
      DONE=true;
      print("DONE");
    }
  }
  if(!DONE){
    //saveFrame("gif/image_#####.png");
  }
}
