class Bubble{
  int BubbleStart;
  int BubbleEnd;
  color Color;
  String Text;
  float alpha = 0.2;
  Bubble(int dStart,int dEnd,String dText,int dColor){
    BubbleStart=dStart;
    BubbleEnd=dEnd;
    Color= dColor;
    Text=dText;
    Color=dColor;
  }
  Bubble(int dStart,int dEnd,String dText){
    BubbleStart=dStart;
    BubbleEnd=dEnd;
    Color= color(150,0,0,200);
    Text=dText;
  }
  void Draw(){
    float bright=0;
    if(r>=BubbleStart && r<=BubbleEnd){
      strokeWeight(10);
      stroke(255,0,0,100*alpha);
      bright=0.5;
    }else{
      strokeWeight(2);
      stroke(255,100*alpha);
    }
    
    float trans=0.06;
    float transpow=0.3;
    float transition= map(pow(BubbleEnd-BubbleStart-1,transpow),pow(65*3,transpow),0,1,0);
    if(transition>1){transition=1;}
    alpha= map(map(zoom,0.28,1.7,1,0),transition-trans,transition,0,1);
    fill(color(map(bright,0,1,red(Color),255),map(bright,0,1,green(Color),255),map(bright,0,1,blue(Color),255),alpha(Color)*alpha));
    
    float inMargin=0.1;
    float bezel=0.2;
    PVector StartOrigin=new PVector(BubbleStart%65,BubbleStart/65);
    PVector EndOrigin=new PVector(BubbleEnd%65,BubbleEnd/65);
    
    if(StartOrigin.y==EndOrigin.y){
      beginShape();
      vertex((StartOrigin.x+inMargin)*scale,(StartOrigin.y+inMargin+bezel)*scale);
      vertex((StartOrigin.x+inMargin+bezel)*scale,(StartOrigin.y+inMargin)*scale);
      
      vertex((EndOrigin.x+1-inMargin-bezel)*scale,(StartOrigin.y+inMargin)*scale);
      vertex((EndOrigin.x+1-inMargin)*scale,(StartOrigin.y+inMargin+bezel)*scale);
      
      vertex((EndOrigin.x+1-inMargin)*scale,(EndOrigin.y+1-inMargin-bezel)*scale);
      vertex((EndOrigin.x+1-inMargin-bezel)*scale,(EndOrigin.y+1-inMargin)*scale);
      
      vertex((StartOrigin.x+inMargin+bezel)*scale,(EndOrigin.y+1-inMargin)*scale);
      vertex((StartOrigin.x+inMargin)*scale,(EndOrigin.y+1-inMargin-bezel)*scale);
      endShape();
      
      fill(255,255*alpha);
      textSize(0.7*scale);
      textAlign(LEFT, CENTER);
      text(Text,(StartOrigin.x+0.2)*scale,(StartOrigin.y-0.1)*scale,(EndOrigin.x-StartOrigin.x+1-0.2)*scale,scale);
      textAlign(LEFT,BOTTOM);
    }else if((StartOrigin.y+1==EndOrigin.y)&&(StartOrigin.x>EndOrigin.x)){
      beginShape();
      vertex((StartOrigin.x+inMargin)*scale,(StartOrigin.y+inMargin+bezel)*scale);
      vertex((StartOrigin.x+inMargin+bezel)*scale,(StartOrigin.y+inMargin)*scale);
      
      vertex((65.5-bezel)*scale,(StartOrigin.y+inMargin)*scale);
      vertex((65.5)*scale,(StartOrigin.y+inMargin+bezel)*scale);
      
      vertex((65.5)*scale,(StartOrigin.y+1-inMargin-bezel)*scale);
      vertex((65.5-bezel)*scale,(StartOrigin.y+1-inMargin)*scale);
      
      vertex((StartOrigin.x+inMargin+bezel)*scale,(StartOrigin.y+1-inMargin)*scale);
      vertex((StartOrigin.x+inMargin)*scale,(StartOrigin.y+1-inMargin-bezel)*scale);
      endShape();
      
      beginShape();
      vertex((-0.5)*scale,(EndOrigin.y+inMargin+bezel)*scale);
      vertex((-0.5+bezel)*scale,(EndOrigin.y+inMargin)*scale);
      
      vertex((EndOrigin.x+1-inMargin-bezel)*scale,(EndOrigin.y+inMargin)*scale);
      vertex((EndOrigin.x+1-inMargin)*scale,(EndOrigin.y+inMargin+bezel)*scale);
      
      vertex((EndOrigin.x+1-inMargin)*scale,(EndOrigin.y+1-inMargin-bezel)*scale);
      vertex((EndOrigin.x+1-inMargin-bezel)*scale,(EndOrigin.y+1-inMargin)*scale);
      
      vertex((-0.5+bezel)*scale,(EndOrigin.y+1-inMargin)*scale);
      vertex((-0.5)*scale,(EndOrigin.y+1-inMargin-bezel)*scale);
      endShape();
      
      fill(255,255*alpha);
      textSize(0.7*scale);
      textAlign(LEFT, CENTER);
      text(Text,(StartOrigin.x+0.2)*scale,(StartOrigin.y-0.1)*scale,(65-StartOrigin.x+1-0.2)*scale,scale);
      textAlign(LEFT,BOTTOM);
    }else{
       beginShape();
      vertex((StartOrigin.x+inMargin)*scale,(StartOrigin.y+inMargin+bezel)*scale);
      vertex((StartOrigin.x+inMargin+bezel)*scale,(StartOrigin.y+inMargin)*scale);
      
      vertex((65.5-bezel)*scale,(StartOrigin.y+inMargin)*scale);
      vertex((65.5)*scale,(StartOrigin.y+inMargin+bezel)*scale);
      
      vertex((65.5)*scale,(EndOrigin.y-inMargin-bezel)*scale);
      vertex((65.5-bezel)*scale,(EndOrigin.y-inMargin)*scale);
      
      vertex((EndOrigin.x-inMargin+bezel)*scale,(EndOrigin.y-inMargin)*scale);
      vertex((EndOrigin.x-inMargin)*scale,(EndOrigin.y-inMargin+bezel)*scale);
      
      vertex((EndOrigin.x-inMargin)*scale,(EndOrigin.y+1-inMargin-bezel)*scale);
      vertex((EndOrigin.x-inMargin-bezel)*scale,(EndOrigin.y+1-inMargin)*scale);
      
      vertex((-0.5+bezel)*scale,(EndOrigin.y+1-inMargin)*scale);
      vertex((-0.5)*scale,(EndOrigin.y+1-inMargin-bezel)*scale);
      
      vertex((-0.5)*scale,(StartOrigin.y+1+inMargin+bezel)*scale);
      vertex((-0.5+bezel)*scale,(StartOrigin.y+1+inMargin)*scale);
      
      vertex((StartOrigin.x+inMargin-bezel)*scale,(StartOrigin.y+1+inMargin)*scale);
       vertex((StartOrigin.x+inMargin)*scale,(StartOrigin.y+1+inMargin-bezel)*scale);
      //vertex((EndOrigin.x+1-inMargin)*scale,(StartOrigin.y+inMargin)*scale);
      //vertex((EndOrigin.x+1-inMargin)*scale,(EndOrigin.y+1-inMargin)*scale);
      //vertex((StartOrigin.x+inMargin)*scale,(EndOrigin.y+1-inMargin)*scale);
      endShape();
      fill(255,255*alpha);
      textSize(0.7*scale);
      textAlign(LEFT, CENTER);
      text(Text,(StartOrigin.x+0.2)*scale,(StartOrigin.y-0.1)*scale,(65-StartOrigin.x+1-0.2)*scale,scale);
      textAlign(LEFT,BOTTOM);
      
    }
    //for(int I=BubbleStart;I<=BubbleEnd;I++){ 
    //  rect((I%65)*scale,floor(I/65)*scale,scale,scale);
    //}
  }
}
