int scale= 80;
float zoom= 0.18948996;
PVector pos= new PVector(-2603.8176,-2620.772);
void draw(){//Verbose
  if(keyPressed){
    if(key=='='){
      framerate+=1;
    }
    if(key=='-'){
      framerate-=1; 
    }
    if(key=='.'){
      zoom*=1.02;
    }
    if(key==','){
      zoom/=1.02;
    }
    if(zoom>1.7){
      zoom=1.7; 
    }
    if(zoom<0.10){
      zoom=0.10;
    }
    
    if(keyCode==RIGHT){
      pos.add(new PVector(-15/pow(zoom,0.5),0));
    }
    if(keyCode==LEFT){
      pos.add(new PVector(15/pow(zoom,0.5),0));
    }
    if(keyCode==UP){
      pos.add(new PVector(0,15/pow(zoom,0.5)));
    }
    if(keyCode==DOWN){
      pos.add(new PVector(0,-15/pow(zoom,0.5)));
    }
  }
  clear();
  translate(width/2,height/2);
  scale(zoom);
  translate(pos.x, pos.y);
  println("new");
  if(framerate>0){
    if(frameCount%framerate==0){
      if(r<D.length){
        i=D[r]/4-n;
        j=D[r]%4;
        if(j==0){D[d]=char(D[d]+i);println("Increment data by :"+i);}
        if(j==1){d=i;println("JUMP data pointer");}
        r++;
        if(j==2&&D[d]/4>n){r=i;println("Jump code pointer");}
        println("Data:"+d+"  Code:"+r);
      }
    }
  }else if(framerate<0){
    for( int count = 0; count<abs(framerate);count++){
      if(r<D.length){
        i=D[r]/4-n;
        j=D[r]%4;
        if(j==0){D[d]=char(D[d]+i);println("Increment data by :"+i);}
        if(j==1){d=i;println("JUMP data pointer");}
        r++;
        if(j==2&&D[d]/4>n){r=i;println("Jump code pointer");}
        println("Data:"+d+"  Code:"+r);
      }
    }
  }
  
  
  for(i=max(floor(-pos.y/(scale)-0.5*float(height)/(scale*zoom)),0);i<min(max(floor(-pos.y/scale+0.5*float(height)/(scale*zoom)+1),0),n);i++)for(j=max(floor(-pos.x/scale-0.5*float(width)/(scale*zoom)),0);j<min(max(floor(-pos.x/scale+0.5*float(width)/(scale*zoom)+5),0),n);j++){
      fill(255);
      if(i*n+j==r){
        fill(255,0,0);
      }if(i*n+j==d){
        fill(0,255,0);
      }
      if(i*n+j==r&&i*n+j==d){
        fill(0,0,255);
      }
      noFill();
      stroke(255);
      
      if(zoom>.7){
        strokeWeight(1.0/zoom);
        textSize(12);
        rect(j*scale,i*scale,scale,scale);
        rect(j*scale,i*scale,15,15);
        text(char(D[i*n+j]/4),j*scale+2,i*scale+10+2); 
        text("DAT:"+(D[i*n+j]/4-65),j*scale+2,i*scale+10+15+2);
        int NUM=(D[i*n+j]/4-65);
        String mode="";
        if(D[i*n+j]%4==0){
          mode= "dinc:";
          text(" inc dat by",j*scale+2,i*scale+10+15*2+2);
          text(""+NUM+"/4="+(NUM/4) ,j*scale+2,i*scale+10+15*3+2);
        }if(D[i*n+j]%4==1){
          mode= "pjmp:";
          text(" set datp to",j*scale+2,i*scale+10+15*2+2);
          text(" <"+NUM/n+","+NUM%n+">" ,j*scale+2,i*scale+10+15*3+2);
        }if(D[i*n+j]%4==2){
          mode= "cjmp:";
          text(" logic jmp to",j*scale+2,i*scale+10+15*2+2);
          text(" <"+NUM%n+","+NUM/n+">" ,j*scale+2,i*scale+10+15*3+2);
        }if(D[i*n+j]%4==3){
          text(" value:",j*scale+2,i*scale+10+15*2+2);
          textSize(30);
          text(char(D[i*n+j]/4),j*scale+2+45,i*scale+10+15*2+12);
          textSize(12);
          mode= "note:";
        }
        text(mode+(D[i*n+j]%4),j*scale+2+15+2,i*scale+10+2);
        text(" i:<"+i+","+j+">",j*scale+2,i*scale+10+15*4+2);
      }else{
        textSize(scale);
        text(char(D[i*n+j]/4),j*scale+10,i*scale+scale-10); 
      }
      
  }
  for(Bubble B: Bubbles){
    B.Draw(); 
  }
  stroke(0,0,255);
  noFill();
  strokeWeight(2.0/zoom);
  rect(0,scale,10*scale,10*scale);
  resetMatrix();
  noStroke();
  fill(0);
  rect(0,0,260,30);
  textSize(18);
  fill(255);
  text("Playback delay:"+framerate,10,20);
  text("Zoom:"+zoom,200,20);
  if(r>=D.length){text("Program halted",120,20);}
  stroke(255,100);
  strokeWeight(1);
  line(width/2-10,height/2,width/2+10,height/2);
  line(width/2,height/2-10,width/2,height/2+10);
}
//int i,j,r,d,n=65;char[]D;void setup(){D=loadStrings("D.txt")[0].toCharArray();}
//void draw(){
//  clear();
//  i=D[r]/4-n;
//  j=D[r]%4;
//  if(j==0){D[d]=char(D[d]+i);}
//  if(j==1){d=i;}
//  r++;
//  if(j==2&&D[d]/4>n){r=i;}
//  for(i=0;i<n;i++)for(j=0;j<n;j++){
//      text(char(D[i*n+j]/4),j*10,i*10+10); 
//  }
//}
