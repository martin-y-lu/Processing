class Cam{
  PVector Pos= new PVector(0,0);
  float Scale=1;
  Cam(PVector dPos,float dScale){
    Pos=dPos; Scale=dScale;
  }
  
  PVector RealToScreen(PVector real){
   return PVscale(PVadd(real,PVneg(Pos)),1/Scale); 
  }
  float RealToScreenX(float realX){
    return (realX-Pos.x)/Scale; 
  }
  float RealToScreenY(float realY){
    return (realY-Pos.y)/Scale; 
  }
  PVector ScreenToReal(PVector screen){
   return PVadd(PVscale(screen,Scale),Pos); 
  } 
  float ScreenToRealX(float screenX){
    return (screenX*Scale)+Pos.x; 
  }
  float ScreenToRealY(float screenY){
    return (screenY*Scale)+Pos.y; 
  }
}

class ChemSys{
 int NUMTYPES;
 ArrayList<PartType> Types;
 ArrayList<Particle> Particles;
 ArrayList<Bond> Bonds;
 float[][] hBondRadius;
 float[][] hBondForce;
 
 float[][] cBondLength;
 float[][] cBondK;
 float[][] cBondEnergy;
 float[][] cActivation;

 int SPEED=-3;
 PVector GRAV=new PVector(0,0.000);
 float ENERGY=0;
 PVector Size;
 
 ChemSys(ArrayList<PartType> dTypes, float[][] dHBondRadius,float[][] dHBondForce,float[][] dCBondLength, float[][] dCBondK, float[][] dCBondEnergy,float[][] dCActivation, PVector dSize){
  Types= dTypes;
  //Particles= dParticles;
  Particles= new ArrayList<Particle>( );
  Bonds= new ArrayList<Bond>();
  NUMTYPES=dTypes.size();
  hBondRadius= dHBondRadius;
  hBondForce= dHBondForce;
  cBondLength= dCBondLength;
  cBondK=dCBondK;
  cBondEnergy=dCBondEnergy;
  cActivation= dCActivation;
  Size=dSize;
 }
 PVector EField(PVector Pos){
    PVector field= new PVector(0,0);
    for( Particle P: Particles){
      field= PVadd(field,P.Field(Pos));
    }
    return field;
  }
  
  float TotEnergy(){
    //float totEnergy=0;
    //for(int i=0;i<Particles.size();i++){
    // totEnergy+=Particles.get(i).energy(); 
    //}
    return TotPotential()+TotKinetic();
  }
  float TotPotential(){
    float totPot=0;
    for(int p=0;p<Particles.size();p++){
     totPot+=Particles.get(p).potential(); 
    }
    for(int b=0;b<Bonds.size();b++){
     totPot+=Bonds.get(b).potential();
    }
    return totPot;
  }
  float TotKinetic(){
    float totKin=0;
    for(int i=0;i<Particles.size();i++){
     totKin+=Particles.get(i).kinetic(); 
    }
    return totKin;
  }
  void RescaleVel(){
      //Collections.sort(Particles);
      //float pow=0;
      //float skew=1;
      float actualKinetic= TotKinetic();
      float targetKinetic= ENERGY-TotPotential();
      
      //float integ=(pow(skew+1,pow+1)-pow(skew,pow+1))/(pow+1);
      for(int i=0;i<Particles.size();i++){//Fix velocities to conserve energy
        //float rank=((float) i)/(Particles.size()-1);
        float scale=max(targetKinetic/actualKinetic,0);//*pow(rank+skew,pow)/integ;
        scale=pow(scale,0.5);
        
        Particles.get(i).vel=PVscale(Particles.get(i).vel,scale);
        Particles.get(i).angVel*=scale;
      }
  }
  void DrawFieldLines(Cam Camera){
    for( int x=0; x<width;x+=30){
      for( int y=0; y<height; y+=30){
         PVector F=EField(Camera.ScreenToReal(new PVector(x,y)));
         F= PVscale(F,400);
         if(PVmag(F)>20){
           F=PVsetMag(F,20);
         }
         line(x,y,x+F.x,y+F.y);
      }
    }
  }
  void DrawParticles(Cam Camera){
    for(int p=0;p<Particles.size();p++){
      Particle P= Particles.get(p);
      P.Draw(Camera);
      for(int j=p+1;j<Particles.size();j++){
         Particle J= Particles.get(j);
         float dist= PVmag(PVadd(P.pos,PVneg(J.pos)));
         if(dist<hBondRadius[P.type][J.type]){
           strokeWeight(hBondForce[P.type][J.type]*3.0/Camera.Scale);
           line(Camera.RealToScreenX(P.pos.x),Camera.RealToScreenY(P.pos.y),Camera.RealToScreenX(J.pos.x),Camera.RealToScreenY(J.pos.y));
         }
      }
    } 
  }
  void Draw(Cam Camera){
    //DrawFieldLines(Camera);
    DrawParticles(Camera);
    for( int b=0;b<Bonds.size();b++){
      Bonds.get(b).Draw(Camera);
    }
    noStroke();
    fill(100);
    rect(0,0,Camera.RealToScreenX(0),height);
    rect(0,0,width,Camera.RealToScreenY(0));
    rect(width,0,Camera.RealToScreenX(Size.x)-width,height);
    rect(0,height,width,Camera.RealToScreenY(Size.y)-height);
  }
  float PotentialBondEnergy( Particle A, int AInd, Particle B, int BInd){
    float bondLength= cBondLength[A.type][B.type];
    float bondK= cBondK[A.type][B.type];
    float bondEnergy= cBondEnergy[A.type][B.type];
    
    
    float pot=-bondEnergy;
     float dist=PVmag(PVadd(A.pos,PVneg(B.pos)));
     float disp=dist-bondLength;
     pot+= 0.5*bondK*(disp*disp);
     
     float bondAngle= atan2(B.pos.x-A.pos.x,B.pos.y-A.pos.y);
     float angDisp= (A.angle+A.bondAngles[AInd]-bondAngle)%TWO_PI;
     if(angDisp>PI){
       angDisp=angDisp-TWO_PI;
     }
     pot+= 0.5*A.bondAngKs[AInd]*(angDisp*angDisp); 
     float bondDisp= (bondAngle-B.angle-B.bondAngles[BInd])%TWO_PI;
     if(bondDisp>PI){
       bondDisp=bondDisp-TWO_PI;
     }
     pot+= 0.5*B.bondAngKs[BInd]*(bondDisp*bondDisp);
     return pot;
  }
  void Update(){
    for(int s=0;s<SPEED;s++){
      OneUpdate();
    } 
    if(SPEED<0){
      if(frameCount%-SPEED==0){
        OneUpdate(); 
      }
    }
  }
  void OneUpdate(){
      for(int i=0;i<Particles.size();i++){
        for(int j=0; j<i;j++){
          Particles.get(i).Affect(Particles.get(j)); 
        }
      }
      for(int b=0;b<Bonds.size();b++){
         Bonds.get(b).Update(); 
      }
      for(int i=0;i<Particles.size();i++){
        Particles.get(i).CollideWall();
      }
      for ( int i=Bonds.size()-1;i>=0;i--){
        Bond BOND= Bonds.get(i);
        if(BOND.potential()>-2){
          RemoveBond(i);
        }
      }
      for(int i=0;i<Particles.size();i++){
        for(int j=0; j<i;j++){
          Particle A=Particles.get(i);
          Particle B=Particles.get(j);
          if(A.Collides(B)){
            float maxEnergy=0;
            int Asite=0;
            int Bsite=0;
             
            if(!A.BondedTo(B)){
               println("Collision:::::");
              for(int a=0; a<A.NumSites;a++){
                for(int b=0; b<B.NumSites; b++){
                  float EnergyReleased= PotentialBondEnergy(A,a,B,b);
                  float EnergyDepleted= 0;
                  if(A.Sites[a]!=null){
                    EnergyDepleted+= A.Sites[a].potential();
                    println("Site A:"+A.Sites[a].potential());
                  }
                  if(B.Sites[b]!=null){
                    if(B.Sites[b]!=A.Sites[a]){
                      EnergyDepleted+= B.Sites[b].potential();
                      println("Site B:"+B.Sites[b].potential());
                    }
                  }
                  float energy=-(EnergyReleased-EnergyDepleted);
                  println("SiteA:"+ a+"  SiteB:" +b+ "  Energy released:" +EnergyReleased+ "  Energy depleted:" +EnergyDepleted+" Tot energ:"+energy);
                  if(energy>maxEnergy){
                    maxEnergy=energy;
                    Asite=a;
                    Bsite=b;
                  }
                }
              }
                 println("Collision: TypeA "+ A.type+" TypeB "+ B.type+"SiteA:"+ Asite+"  SiteB:" +Bsite+ "  Energy released:" + maxEnergy);
                if(maxEnergy>cActivation[A.type][B.type]){
                  println("Bonds");
                  if(A.Sites[Asite]!=null){
                    //A.Sites[Asite]=null;
                    Bonds.remove(A.Sites[Asite]);
                  }
                  if(B.Sites[Bsite]!=null){
                    //B.Sites[Bsite]=null;
       
                    Bonds.remove(B.Sites[Bsite]);
                  }
                  Bond BOND =AddBondBetween(A,Asite,B,Bsite);
                  //A.Sites[Asite]=BOND;
                  //B.Sites[Bsite]=BOND;
                  //Bonds.add(BOND);
                  if(BOND.A.Sites[BOND.AInd]!=BOND){
                         Bonds.remove(i);
                     println("WRONG BOND");
                   }else if(BOND.B.Sites[BOND.BInd]!=BOND){
                     Bonds.remove(i);
                     println("WRONG BOND");
                   }
                  A.Collide(B,maxEnergy);
                }else{
                  A.Collide(B,0);
                }
                println("__________________");
              }else{
                 A.Collide(B,0);
              }
          }
        }
      }
      //for( int i=Bonds.size()-1;i>=0;i--){
      //   Bond BOND= Bonds.get(i);
      //   if(BOND.A.Sites[BOND.AInd]!=BOND){
      //     Bonds.remove(i);
      //     println("WRONG BOND");
      //   }else if(BOND.B.Sites[BOND.BInd]!=BOND){
      //     Bonds.remove(i);
      //     println("WRONG BOND");
      //   }
      //}
      for(int i=0; i<Particles.size(); i++){
         Particles.get(i).UpdateVel();
      }
      RescaleVel();
      for(int i=0; i<Particles.size(); i++){
         Particles.get(i).UpdatePos();
      } 
  }
  void RemoveBond(int i){
    Bond BOND=Bonds.get(i);
    BOND.A.Sites[BOND.AInd]=null;
    BOND.B.Sites[BOND.BInd]=null;
    Bonds.remove(BOND);
  }
  void AddParticle(Particle P){
    Particles.add(P);
  }
  void FixEnergy(){
    ENERGY= TotEnergy();
  }
  Bond AddBondBetween(Particle A,int AInd,Particle B,int BInd){
    Bond BOND=new Bond(cBondLength[A.type][B.type],cBondK[A.type][B.type],cBondEnergy[A.type][B.type],A,AInd,B,BInd);
    A.Sites[AInd]=BOND;
    B.Sites[BInd]=BOND;
    Bonds.add(BOND);
    return BOND;
  }
}



class PartType{
  float radius;
    float mass;
    float charge;
    float momInert;
    
    float[] bondAngles;
    float[] bondAngKs;
    
    int type;
    PartType(int dType, float dRad,float dMass,float dCharge,float dMomInert,float[] dBondAngles,float[] dBondAngKs){
       radius= dRad; mass= dMass; charge= dCharge; momInert=dMomInert;  bondAngles=dBondAngles;  bondAngKs=dBondAngKs;
       type = dType;
    }
    Particle Gen(ChemSys dSys,PVector dPos,PVector dVel,float dAngle, float dAngVel, float dAngAcc){
      return new Particle(dSys,type,dPos,dVel,radius,mass,charge,
      dAngle, dAngVel, dAngAcc,momInert,
      bondAngles,bondAngKs); 
    }
    Particle Gen(ChemSys dSys,PVector dPos,PVector dVel,float dAngle, float dAngVel, float dAngAcc, Particle dP){
      return new Particle(dSys,type,dPos,dVel,radius,mass,charge,
      dAngle, dAngVel, dAngAcc,momInert,
      bondAngles,bondAngKs); 
    }
}