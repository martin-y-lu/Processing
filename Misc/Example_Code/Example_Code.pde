// Define


ArrayList<Square> Squares = new ArrayList<Square>();
String Text;
void setup(){
  for( int i=0; i<10; i++){
    Squares.add( new Square(new PVector(random(200),random(200)),new PVector(2,1)));
  }
  //Initisalize
  size(200,200);
  //Pos= new PVector(50,100);
  //Vel= new PVector(2,1);
  Text= "hello world";
}
void draw(){
  
  //Update
  for( Square S: Squares){
    S.Update();
  }
  if(keyPressed){
   Text= Text+ key; 
  }
  
  // Draw
  background(255,255,255);
  fill(255,0,0);
  stroke(0,0,255);
  strokeWeight(3);
  text(Text,20,50,170,200);
  for( Square S: Squares){
    S.Draw();
  }
  line(100,100,mouseX,mouseY);
  noStroke();
  ellipse(100,100,50,50);
}