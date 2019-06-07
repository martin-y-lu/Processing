PShape Or;
PShape And;
PShape Not;
OrGate Gate;
void setup(){
    frameRate(60);
    size(640, 360);
    Or=createShape();
    Or.beginShape();
    Or.fill(102);
    Or.stroke(255);
    Or.strokeWeight(2);
    // Here, we are hardcoding a series of vertices
    Or.vertex(0,0);
    Or.vertex(30,0);
    Or.vertex(45,5);
    Or.vertex(60,20);
    Or.vertex(45,40-5);
    Or.vertex(30,40);
    Or.vertex(0,40);
    Or.vertex(15,20);
    Or.endShape(CLOSE);
    
    And=createShape();
    And.beginShape();
    And.fill(102);
    And.stroke(255);
    And.strokeWeight(2);
    // Here, we are hardcoding a series of vertices
    And.vertex(5,0);
    And.vertex(30,0);
    And.vertex(47,5);
    And.vertex(60,20);
    And.vertex(47,40-5);
    And.vertex(30,40);
    And.vertex(5,40);
    And.endShape(CLOSE);
    
    Not=createShape();
    Not.beginShape();
    Not.fill(102);
    Not.stroke(255);
    Not.strokeWeight(2);
    Not.vertex(0,0);
    //Not.vertex(30,15);
    for(float ang=0.2;ang<PI*2-0.2;ang+=0.3){
      Not.vertex(30+3-cos(ang)*5,15-sin(ang)*5);
    }
    Not.vertex(0,30);
    Not.endShape(CLOSE);
    
    Gate= new OrGate(new PVector(100,100));
}
void draw(){
  background(15,10,10); 
  fill(0);
  Gate.Draw();
  //translate(mouseX,mouseY);
  //shape(Or);
  //translate(100,0);
  //shape(And);
  // translate(100,0);
  //shape(Not);
}