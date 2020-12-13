
float time=0;
void drawTetra(int a){
  //fill(255);
  beginShape(TRIANGLE_STRIP);
  vertex(a,0  ,0);  // vertex 1
  vertex(a*0.5, a*sqrt(0.5), a*sqrt(3)/6);    // vertex 2
  vertex(0,0,0);  // vertex 3
  
  vertex(a*0.5,0,a*sqrt(3)/2);   // vertex 4
  vertex(a,0  ,0);  // vertex 1
  
  vertex(a*0.5, a*sqrt(0.5), a*sqrt(3)/6);    // vertex 2
  vertex(a*0.5,0,a*sqrt(3)/2);   // vertex 4
  
  //vertex(0,0,0);  // vertex 3
  //vertex(a*0.5, a*sqrt(0.5), a*sqrt(3)/6);    // vertex 2
  endShape(CLOSE);
  
}
float k=0.4;
float s=100;
int prevCount;
int SCENE;
int[]SceneLength={int(120*(1-k)),int(120*k),int(120*(1-k)),int(120*k),int(120*(1-k)),int(120*k),int(120*(1-k)),int(120*k)};
int[]SceneWait={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
int numScenes=8;
boolean DONE=false;
void setup(){
  //frameRate(10);
  size(800,800,P3D);
  //noStroke();
  //colorMode(MULTIPLY);
}
void setScale(){
  noFill();
  stroke(255,0,0);
  //strokeWeight(5);
  //rect(0.5*(width-width*s/100),0.5*(height-height*s/100),width*s/100,height*s/100);
  //stroke(0,255,0);
  //rect(0.5*(width-width*s/200),0.5*(height-height*s/200),width*s/200,height*s/200);
   ortho(-width/2, width/2, -height/2, height/2); // Same as ortho()
      
      translate(width/2, height/2, -height*0.7);
      scale(s);
}
void drawWhiteForm(float m){
  fill(255);
  stroke(0);
  fill(255);
  
  translate(-7.5,0,(10+1.0/3)*sqrt(3)/2);
  for(int i=0;i<11;i++){
    translate(0.5,0,-sqrt(3)/2);
    pushMatrix();
    for(int j=0; j<14;j++){
      fill(255); 
      drawTetra(1);
      translate(1,0,0);
    }
    popMatrix();
        translate(-0.5,0,-sqrt(3)/2);
    pushMatrix();
    for(int j=0; j<15;j++){
      if(j%2!=i%2){
        pushMatrix();
        //fill(255,0,0);
        translate(0,sqrt(0.5)*m,m*(1+1./3)*sqrt(3)/2);
        drawTetra(1);
        popMatrix();
      }else{
        fill(255); 
        drawTetra(1);
      }
      translate(1,0,0);
    }
    popMatrix();
  }
}
void drawWhiteFin(){
  fill(255);
  stroke(0);
  fill(255);
  
  translate(-4.5,0,(5+2.0/3)*sqrt(3)/2);
  for(int i=0;i<6;i++){

    
    translate(0.5,0,-sqrt(3)/2);
    pushMatrix();
    for(int j=0; j<8;j++){
      fill(255); 
      drawTetra(1);
      translate(1,0,0);
    }
    popMatrix();
        translate(-0.5,0,-sqrt(3)/2);
    pushMatrix();
    for(int j=0; j<9;j++){
      fill(255); 
      drawTetra(1);
      translate(1,0,0);
    }
    popMatrix();
  }
}
void drawBlackForm(float m){

  stroke(255);
  fill(0);
  
  translate(-6.5,0,(10+1.0/3)*sqrt(3)/2);
  for(int i=0;i<10;i++){
    translate(0.5,0,-sqrt(3)/2);
    pushMatrix();
    for(int j=0; j<12;j++){
      fill(0); 
      drawTetra(1);
      translate(1,0,0);
    }
    popMatrix();
        translate(-0.5,0,-sqrt(3)/2);
    pushMatrix();
    for(int j=0; j<13;j++){
      if(j%2!=i%2){
        pushMatrix();
        //fill(255,0,0);
        translate(0,sqrt(0.5)*m,m*(1+1./3)*sqrt(3)/2);
        drawTetra(1);
        popMatrix();
      }else{
        fill(0); 
        drawTetra(1);
      }
      translate(1,0,0);
    }
    popMatrix();
  }
}
void drawBlackFin(){
  
      stroke(255);
      fill(0);
      
      translate(-4.5,0,(5+2.0/3)*sqrt(3)/2);
      for(int i=0;i<6;i++){
        translate(0.5,0,-sqrt(3)/2);
        pushMatrix();
        for(int j=0; j<8;j++){
          fill(0); 
          drawTetra(1);
          translate(1,0,0);
        }
        popMatrix();
            translate(-0.5,0,-sqrt(3)/2);
        pushMatrix();
        for(int j=0; j<9;j++){
          fill(0); 
          drawTetra(1);
          translate(1,0,0);
        }
        popMatrix();
      }
}
     //rotateX(-0.005*float(mouseY-height/2));
      //rotateY(0.005*float(mouseX-width/2));
void draw(){
  float n= float(frameCount-prevCount)/SceneLength[SCENE];
  if(n>1){n=1;}
  //float s= n<.5 ? 4*n*n*n : (n-1)*(2*n-2)*(2*n-2)+1;
  float a=n;
  float m= a<.5 ? 8*a*a*a*a : 1-8*(--a)*a*a*a;
  float t=0;
  
  background(new int[]{color(0),color(0),color(255),color(255),color(0),color(0),color(255),color(255),color(0),color(0),color(255),color(255)}[SCENE]);
      
  if(n<0.2){
    strokeWeight(0.015*(n/0.2)*(n/0.2));
  }else if(n<0.8){
    strokeWeight(0.015);
  }else{
    strokeWeight(0.01*((1-n)/0.2)*((1-n)/0.2));
  }
  //ambientLight(255,255,255,width/2,height/2,500);
  switch(SCENE){
    case 0:
      s=map(n,0.0,1.,200,200*(1+k)/2);
      setScale();

      
      rotateX(-1.04*sin(PI*n*n/2));
      rotateY(-0.4*sin(PI*n));
      rotateX(PI/2);
      //rotateY(PI/3);
      println(n);
      //if(n<0.2){
      //  strokeWeight(0.015*(n/0.2)*(n/0.2));
      //}else if(n<0.8){
      //  strokeWeight(0.015);
      //}else{
      //  strokeWeight(0.01*((1-n)/0.2)*((1-n)/0.2));
      //}
      drawWhiteForm(m);
      break;
    case 1:
      s=map(n,0.0,1.,200*(1+k),200);
      setScale();
      rotateX(-1.04*sin(PI*(1-n)*(1-n)/2));
      rotateY(0.4*sin(PI*(1-n)));
      rotateX(PI/2);
      //rotateY(PI/3);
      drawWhiteFin();
      break;
    case 2:
      s=map(n,0.0,1.,200,200*(1+k)/2);
      setScale();
      rotateX(PI/2);
      rotateY(PI/3);
      rotateX(-1.04*sin(PI*n*n/2));
      rotateZ(0.4*sin(PI*n));
      drawBlackForm(m);
      break;
    case 3:
      s=map(n,0.0,1.,200*(1+k),200);
      setScale();
      rotateX(PI/2);
      rotateY(PI/3);
      rotateX(-1.04*sin(PI*(1-n)*(1-n)/2));
      rotateZ(-0.4*sin(PI*(1-n)));
      drawBlackFin();
      break;
    case 4:
      s=map(n,0.0,1.,200,200*(1+k)/2);
      setScale();
      rotateX(-1.04*sin(PI*n*n/2));
      rotateY(-0.4*sin(PI*n));
      rotateX(PI/2);
      rotateY(2*PI/3);
      drawWhiteForm(m);
      break;
    case 5:
      s=map(n,0.0,1.,200*(1+k),200);
      setScale();
      rotateX(-1.04*sin(PI*(1-n)*(1-n)/2));
      rotateY(0.4*sin(PI*(1-n)));
      rotateX(PI/2);
      rotateY(2*PI/3);
      drawWhiteFin();
      break;
    case 6:
      s=map(n,0.0,1.,200,200*(1+k)/2);
      setScale();
      rotateX(PI/2);
      rotateY(PI/3);
      rotateY(2*PI/3);
      rotateX(-1.04*sin(PI*n*n/2));
      rotateZ(0.4*sin(PI*n));
      drawBlackForm(m);
      break;
    case 7:
      s=map(n,0.0,1.,200*(1+k),200);
      setScale();
      rotateX(PI/2);
      rotateY(PI/3);
      rotateY(2*PI/3);
      rotateX(-1.04*sin(PI*(1-n)*(1-n)/2));
      rotateZ(-0.4*sin(PI*(1-n)));
      drawBlackFin();
      break;
   case 8://
      s=map(n,0.0,1.,200,200*(1+k)/2);
      setScale();
      rotateX(-1.04*sin(PI*n*n/2));
      rotateY(-0.4*sin(PI*n));
      rotateX(PI/2);
      rotateY(-2*PI/3);
      drawWhiteForm(m);
      break;
    case 9:
      s=map(n,0.0,1.,200*(1+k),200);
      setScale();
      rotateX(-1.04*sin(PI*(1-n)*(1-n)/2));
      rotateY(0.4*sin(PI*(1-n)));
      rotateX(PI/2);
      rotateY(-2*PI/3);
      drawWhiteFin();
      break;
    case 10:
      s=map(n,0.0,1.,200,200*(1+k)/2);
      setScale();
      rotateX(PI/2);
      rotateY(PI/3);
      rotateY(-2*PI/3);
      rotateX(-1.04*sin(PI*n*n/2));
      rotateZ(0.4*sin(PI*n));
      drawBlackForm(m);
      break;
    case 11:
      s=map(n,0.0,1.,200*(1+k),200);
      setScale();
      rotateX(PI/2);
      rotateY(PI/3);
      rotateY(-2*PI/3);
      rotateX(-1.04*sin(PI*(1-n)*(1-n)/2));
      rotateZ(-0.4*sin(PI*(1-n)));
      drawBlackFin();
      break;
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
    saveFrame("final_0/image_#####.png");
  }
}
