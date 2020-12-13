import processing.svg.*;
void setup(){
  //size(1754,1240,SVG,"filename.svg");
  size(1754,1240);
  background(255);
}
QuadTri quadTri= new QuadTri(new PVector(100*3,100*3),new PVector(200*3,50*3),new PVector(300*3,100*3),new PVector(200*3,150*3),0);
void draw(){
  background(255);
  quadTri.drawQuadTri();
  //  println("Finished.");
  //exit();
 
  //quadTri.apex=new PVector(mouseX,mouseY);
  //quadTri.recalc();
}

class QuadTri{
   PVector vert1;
   PVector vert2;
   PVector vert3;
   PVector apex;
   float lerpAmount=0.06;
   int depth;
   PVector apexLerpTo3;
   PVector apexLerpTo1;
   PVector center;
   QuadTri quadTri1;
   QuadTri quadTri2;
   QuadTri quadTri3;
   
   QuadTri(PVector vert1,PVector vert2,PVector vert3,PVector apex,int depth){
     this.vert1=vert1;
     this.vert2=vert2;
     this.vert3=vert3;
     this.apex=apex;
     this.depth= depth+1;
     recalc();
   }
   void recalc(){
     apexLerpTo3= vert3.copy().lerp(apex,1-lerpAmount);
     apexLerpTo1= vert1.copy().lerp(apex,1-lerpAmount);
     center=vert1.copy().lerp(vert3,0.5).lerp(vert2,0.2).lerp(apex,0.2);
     if(this.depth<8){
       quadTri1=new QuadTri(vert1.copy().lerp(apex,1-lerpAmount),vert1.copy(),vert1.copy().lerp(vert2,0.5-lerpAmount/2),center.copy().lerp(vert1,lerpAmount),this.depth);
       quadTri2=new QuadTri(vert2.copy().lerp(vert1,0.5-lerpAmount/2),vert2.copy(),vert2.copy().lerp(vert3,0.5-lerpAmount/2),center.copy().lerp(vert2,lerpAmount),this.depth);
       quadTri3=new QuadTri(vert3.copy().lerp(apex,1-lerpAmount),vert3.copy(),vert3.copy().lerp(vert2,0.5-lerpAmount/2),center.copy().lerp(vert3,lerpAmount),this.depth);
     }
   }
   void drawQuadTri(){
     noFill();
     if(quadTri1!=null){
       quadTri1.drawQuadTri();
     }
     if(quadTri2!=null){
       quadTri2.drawQuadTri();
     }
     if(quadTri3!=null){
       quadTri3.drawQuadTri();
     }
     strokeWeight(5*pow(depth,-1));
     stroke(0);
     beginShape();
     vertex(vert1.x,vert1.y);
     vertex(vert2.x,vert2.y);
     vertex(vert3.x,vert3.y);
     vertex(apexLerpTo3.x,apexLerpTo3.y);
     bezierVertex(apex.x,apex.y,apex.x,apex.y,apexLerpTo1.x,apexLerpTo1.y);
     endShape(CLOSE);
     circle(center.x,center.y,2);
    
   }
  
}
void MousePressed(){
 
}
