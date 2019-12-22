class Square{
  PVector Pos;
  PVector Vel;
  Square( PVector dPos, PVector dVel){
    Pos= dPos; Vel= dVel; 
  }
  void Update(){
    Pos= Pos.add(Vel);
    if(mousePressed){
      Vel= Vel.add( new PVector( (mouseX-Pos.x)*0.04,(mouseY-Pos.y)*0.04));
    }
    if(Pos.x<0){
       Vel= new PVector(abs(Vel.x),Vel.y); 
    }
    if(Pos.x>200-20){
        Vel= new PVector(-abs(Vel.x),Vel.y); 
    }
    if(Pos.y<0){
      Vel= new PVector(Vel.x,abs(Vel.y)); 
    }
    if(Pos.y>200-20){
        Vel= new PVector(Vel.x,-abs(Vel.y)); 
    }
  }
  void Draw(){
    rect(Pos.x,Pos.y,20,20);
  }
}