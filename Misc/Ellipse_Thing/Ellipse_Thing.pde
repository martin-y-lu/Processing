

class Ellipse{
  PVector Pos;//= new PVector(100,100);
  PVector Vel;//= new PVector(5,0);
  Ellipse(PVector dPos,PVector dVel){
     Pos= dPos;
     Vel= dVel;
  }
  void Draw(){
    ellipse(Pos.x,Pos.y,20,40);
  }
  void Update(){
    Pos= Pos.add(Vel);
    Vel= new PVector((Vel.x)+0.1*(mouseX-Pos.x),(Vel.y)+0.1*(mouseY-Pos.y));
    if( mousePressed){
      Vel= new PVector(Vel.x*0.95,Vel.y*0.95);
    }
    if(Pos.x>500){
      Vel= new PVector(-Vel.x,Vel.y);
    }
  }
}

//Ellipse E= new Ellipse(new PVector(100,100), new PVector(5,0));
ArrayList<Ellipse> Elist= new ArrayList<Ellipse>();

void setup(){
  size(500,500);
  for(int i=0; i<20;i++){
    Elist.add(new Ellipse(new PVector(random(0,500),random(0,500)), new PVector(5,0)));
  }
}
float x=0;

String Text= "HI";
void draw(){
  background(255,0,0);
  text(Text,20,100);
  //if (mousePressed){
  for( Ellipse E: Elist){
    E.Update();
    E.Draw();
  }
  
  
    
    //Pos= new PVector((Pos.x*10+mouseX)/11,(Pos.y*10+mouseY)/11);
  //}
  if(keyPressed){
    Text+= key;
  }
  
  fill(0,255,0);
  stroke(0,0,255);
  strokeWeight(5);
  rect(10,10,20,40);
  
  line(100,100,200,200);
}