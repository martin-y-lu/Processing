//Nucleus N= new Nucleus(new PVector(200,200),30,60);
ArrayList<Nucleus> Nuclei= new ArrayList<Nucleus>();
ArrayList<Electron> Electrons=new ArrayList<Electron>();

void setup(){
   print("Log of e is"+ log(2.7182818285));
    frameRate(60);
    size(1500, 820);
    //Nuclei.add(new Nucleus(new PVector(200,200),1,100));
    //for(float i=0;i<PI*2;i+=2*PI/20){
    //  Electrons.add(new Electron(new PVector(200+130*sin(i),200+130*cos(i)),new PVector(2*cos(i),-2*sin(i))));
    //}
    
     //Nuclei.add(new Nucleus(new PVector(300,300),1,150));
    
    //for( float x=80;x<600;x+=80*2){
    //  for( float y=80;y<320;y+=80*2){
    //    Nuclei.add(new Nucleus(new PVector(x,y),10,60));
    //  }
    //}
    for( float x=1;x<36;x+=1){
      for( float y=1;y<8;y+=1){
        Nuclei.add(new Nucleus(new PVector(x*40,y*40),15,20));
        //for(float i=0;i<PI*2;i+=2*PI/1){
        //  Electrons.add(new Electron(new PVector(x*40+30*sin(i),y*40+30*cos(i)),new PVector(2*cos(i),-2*sin(i))));
        //}
      }
    }
    for( float x=1;x<8;x+=1){
      for( float y=8;y<14;y+=1){
        Nuclei.add(new Nucleus(new PVector(x*40,y*40),15,20));
        //for(float i=0;i<PI*2;i+=2*PI/1){
        //  Electrons.add(new Electron(new PVector(x*40+30*sin(i),y*40+30*cos(i)),new PVector(2*cos(i),-2*sin(i))));
        //}
      }
    }
    for( float x=1;x<36;x+=1){
      for( float y=14;y<22;y+=1){
        Nuclei.add(new Nucleus(new PVector(x*40,y*40),15,20));
        //for(float i=0;i<PI*2;i+=2*PI/1){
        //  Electrons.add(new Electron(new PVector(x*40+30*sin(i),y*40+30*cos(i)),new PVector(2*cos(i),-2*sin(i))));
        //}
      }
    }
    for( float x=30;x<36;x+=1){
      for( float y=8;y<16;y+=1){
        Nuclei.add(new Nucleus(new PVector(x*40,y*40),15,20));
        //for(float i=0;i<PI*2;i+=2*PI/1){
        //  Electrons.add(new Electron(new PVector(x*40+30*sin(i),y*40+30*cos(i)),new PVector(2*cos(i),-2*sin(i))));
        //}
      }
    }
    for(Electron E: Electrons){
       E.SetPotential(); 
    }
    
}

void draw(){
  background(240,245,255); 
  fill(0);
  //Electrons.get(0).Pos=new PVector(mouseX,mouseY);
  rect(500,0,300,300);
  for (Electron E:Electrons){
    if(FLtween(500,500+300,E.Pos.x)&&FLtween(0,300,E.Pos.y)){
      E.ApplyField(new PVector(3,0));
    }
  }
  for( Nucleus N:Nuclei){
    N.Draw();
    for( Electron E:Electrons){
      N.FieldOn(E);
    }
  }
  for( Electron E:Electrons){
    E.Draw();
  }
  for( Electron E:Electrons){
    for( Electron O:Electrons){
      if(O!=E){
        O.FieldOn(E);
      }
    }
    E.Update();
  }
  //saveFrame("video/clip_####.png");
}
class Nucleus{
  //Nuclei are fixed in position, and fixed in charge
  //They impart a "radus" onto the field
  PVector Pos;
  float Charge=1;
  float Radius=100;
  Nucleus(PVector dPos, float dCharge, float dRadius){
    Pos=dPos; Charge=dCharge; Radius=dRadius;
  }
  void Draw(){
    fill(255,255-10*Charge,255-8*Charge);
    ellipse(Pos.x,Pos.y,Radius*2,Radius*2);
    fill(200*Charge,0,0);
    ellipse(Pos.x,Pos.y,15,15);
    fill(0);
    text("+",Pos.x-5,Pos.y+4);
  }
  float strength=0.4;
  void FieldOn(Electron E){
    PVector VectToE=PVadd(Pos,PVminus(E.Pos));
    float Dist=PVmag(VectToE);
    float x=Dist/Radius;
    //float Len= Charge*(163.259799273*pow(x,-4.91388)-163.270782464*pow(x,-4.84569298823))/20.0; // 2 forces method
    float Len= max(-pow(x,-2),strength-strength*x);
    Len=Len*Charge;
    E.ApplyField(PVsetmag(VectToE,Len));
  }
  float PotentialOn(Electron E){
    PVector VectToE=PVadd(Pos,PVminus(E.Pos));
    float Dist=PVmag(VectToE);
    float x=Dist/Radius;
    float Potential=0;
    if(x<4){
      float inter= 0.61111*pow(strength,0.4444)+8.5555;
      if(x<inter){
        Potential=strength*x-0.5*strength*pow(x,2)-(strength*inter-0.5*strength*pow(inter,2))+1/inter;
      }else{
        Potential=1/x;
      }
    }
    return -Potential*E.Charge;
  }
}

class Electron{
  PVector Pos;
  PVector Vel;
  PVector Acc= new PVector(0,0);
  float Charge=-1;
  Electron(PVector dPos, PVector dVel){
    Pos=dPos; Vel= dVel;
    PrevE=KineticEnergy()+Potential();
  }
  void SetPotential(){
   PrevE=KineticEnergy()+Potential(); 
  }
  PVector NewPos(){
    return PVadd(PVadd(Pos,Vel),PVextend(Acc,0.5));
  }
  float KineticEnergy(){
    return -Charge*0.5*pow(PVmag(Vel),2);
  }
  void UpdateKinematics(){
    Pos=NewPos();
    Vel=PVadd(Vel,Acc);
    Acc= new PVector(0,0);
  }
  void ApplyField(PVector FieldVect){
    Acc=PVadd(Acc,PVextend(FieldVect,Charge));
  }
  float strength=3000;
  float PotentialOn(Electron E){
    PVector VectToE=PVadd(Pos,PVminus(E.Pos));
    float Dist=PVmag(VectToE);
    return Charge*strength/Dist;
  }
  float Potential(){
    float Total=0;
    for(Nucleus N:Nuclei){
      Total+=N.PotentialOn(this);
    }
    //for(Electron E:Electrons){
    //  if(E!=this){
    //    Total+= PotentialOn(E);
    //  }
    //}
    return Total;
  }
  void FieldOn(Electron E){
    PVector VectToE=PVadd(Pos,PVminus(E.Pos));
    float Dist=PVmag(VectToE);
    if(Dist<300){
      E.ApplyField(PVsetmag(VectToE,-Charge*pow(Dist,-2)*strength));
    }
  }
  float PrevE;
  void Update(){
    float TargKE=PrevE-Potential();
    //println("TargE="+PrevE);
    //println("TargKe ="+TargKE);
    float TargVel=sqrt(max(TargKE*2/abs(Charge),0));
    //println("Final Ke ="+KineticEnergy());
    //println("difference Ke ="+(TargKE-KineticEnergy()));
    //println("Final E="+KineticEnergy()+N.PotentialOn(this));
    //println("difference E ="+(PrevE-KineticEnergy()+N.PotentialOn(this)));
    Vel=PVsetmag(Vel,PVmag(Vel)*0.9+0.1*TargVel);
    UpdateKinematics();
    PrevE=(KineticEnergy()+Potential())*0.2;
  }
  void Draw(){
    float pot=Potential();
    float kin=KineticEnergy();
    text("potential= "+pot,10,10);
    text("kinetic= "+kin,10,20);
    text("total= "+(pot+kin),10,30);
    fill(0,10,200*abs(Charge));
    ellipse(Pos.x,Pos.y,8,8);
    fill(0);
    text("-",Pos.x-4,Pos.y+3);
  }
}

void mouseClicked(){
   Electrons.add(new Electron(new PVector(mouseX,mouseY),new PVector(0,0.001)));
}