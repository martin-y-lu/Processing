class Element{
   int x;
   int y;
   int w=80;
   int h=100;
   int c;
   int atomicNum;
   String name;
   String symbol;
   int start;
   Element(int dX,int dY, int dC, int dnum, String dName, String dsym){
     x=dX; y=dY;
     c=dC;
     atomicNum=dnum;
     name=dName;
     symbol=dsym;
     start= millis();
   }
   void drawElement(){
    fill(c);
    rect(x,y,w,h);
    fill(0);
    textSize(15);
    textAlign(CENTER);
    text(""+atomicNum,x,y+6,w,30);
    text(name,x,y+26,w,30);
    textSize(35);
    text(symbol,x,y+45,w,50);
   }
   //void update(){
   //  if(millis()-start>3000){
   //    RList.remove(this); 
   //  }
   //}
}
//Rectangle R= new Rectangle(100,100,100,100,color(255,0,0));
//Rectangle R1= new Rectangle(300,100,100,100,color(0,255,0));
ArrayList<Element> elements= new ArrayList<Element> ();
//Rectangle[][] RArray= new Rectangle[100][20];


void setup() {
  size(1100, 360);
  //for(int i=0;i<100;i++){
  // int x= floor(random(1)*width);
  // int y= floor(random(1)*height);
  // int w= floor(random(1)*200);
  // int h= floor(random(1)*200);
  // int c= color(floor(random(1)*255),floor(random(1)*255),floor(random(1)*255));
  // RList.add(new Rectangle(x,y,w,h,c));
  //}
  
  //RList.add(new Rectangle(300,100,100,100,color(0,255,0)));
  elements.add(new Element(10,10,color(0,255,0),1,"Hydrogen","H"));
  elements.add(new Element(10+11*90,10,color(0,255,0),2,"Helium","He"));
  elements.add(new Element(10,120,color(0,255,0),3,"Lithium","Li"));
  elements.add(new Element(10+90,120,color(0,255,0),4,"Beryllium","Be"));
  int sep=6;
  elements.add(new Element(10+sep*90,120,color(0,255,0),5,"Boron","B"));
  elements.add(new Element(10+(sep+1)*90,120,color(0,255,0),6,"Carbon","C"));
  elements.add(new Element(10+(sep+2)*90,120,color(0,255,0),7,"Nitrogen","N"));
  elements.add(new Element(10+(sep+3)*90,120,color(0,255,0),8,"Oxygen","O"));
  elements.add(new Element(10+(sep+4)*90,120,color(0,255,0),9,"Fluorine","F"));
  elements.add(new Element(10+(sep+5)*90,120,color(0,255,0),10,"Neon","Ne"));
  
  elements.add(new Element(10+0,10+110*2,color(0,255,0),11,"Sodium","Na"));
  elements.add(new Element(10+1*90,10+110*2,color(0,255,0),11,"Magnesium","Mg"));
  
  elements.add(new Element(10+sep*90,10+110*2,color(0,255,0),5,"Aluminium","Al"));
  elements.add(new Element(10+(sep+1)*90,10+110*2,color(0,255,0),6,"Silicon","Si"));
  elements.add(new Element(10+(sep+2)*90,10+110*2,color(0,255,0),7,"Phosphorus","P"));
  elements.add(new Element(10+(sep+3)*90,10+110*2,color(0,255,0),8,"Sulfur","S"));
  elements.add(new Element(10+(sep+4)*90,10+110*2,color(0,255,0),9,"Chlorine","Cl"));
  elements.add(new Element(10+(sep+5)*90,10+110*2,color(0,255,0),10,"Argon","Ar"));

  
}

void draw(){
 background(0);
 for( Element E: elements){
   E.drawElement(); 
 }
 //for(int i=RList.size()-1;i>=0;i--){
 //  RList.get(i).update();
 //}
 //if(frameCount%20==0){
 //  int x= floor(random(1)*width);
 //  int y= floor(random(1)*height);
 //  int w= floor(random(1)*200);
 //  int h= floor(random(1)*200);
 //  int c= color(floor(random(1)*255),floor(random(1)*255),floor(random(1)*255));
 //  RList.add(new Rectangle(x,y,w,h,c));
 //}
 //R.drawRect();
 //R1.drawRect();
}