class effect{
  float HealthMod;
  float TopHealthMod;
  float DamageMod;
  float EnergyMod;
  effect(float dHealthMod,float dTopHealthMod, float dDamageMod,float dEnergyMod){
    HealthMod=dHealthMod; TopHealthMod=dTopHealthMod; DamageMod=dDamageMod; EnergyMod=dEnergyMod;
  }
  
  void doEffect(person P){
    P.Health+=HealthMod;
    P.TopHealth+=TopHealthMod;
    P.Damage+=DamageMod;
    P.Energy+=EnergyMod;
  }
}
class attack{
  String Name;
  ArrayList <person> affectedPPL= new ArrayList <person>();
  ArrayList <effect> actions= new ArrayList <effect>();
  attack(String dName){
    Name=dName;
  }
  void doAttack(){
    for(int i=0;i<actions.size();i++){
      actions.get(i).doEffect(affectedPPL.get(i));
    }
  }
  void display(float x,float y){
    text(Name,x,y);
    for(int i=0;i<actions.size();i++){
      effect E= actions.get(i);
      text(E.HealthMod,x,y+i*50+10);
      text(E.TopHealthMod,x,y+i*50+20);
      text(E.DamageMod,x,y+i*50+30);
      text(E.EnergyMod,x,y+i*50+40);
    }
  }
}
class battle{
  player P;
  ArrayList <person> Tlist=new ArrayList <person>();
  boolean fighting=false;
  int round;
  battle(player dP){
    P=dP;
  }
  
  int select=0;
  int attacksel=0;
  void buttonToAttack(){
    if(P.Health>0){
      if((round % (Tlist.size()+1))==0){
          while(Tlist.get(select).Health<=0){
              select=(select+1)%Tlist.size();            
          }
        
        if((DownPress==1)){
          select=(select+1)%Tlist.size();            
          while(Tlist.get(select).Health<=0){
            select=(select+1)%Tlist.size();            
          }
        }
        if(UpPress==1){
            select=(select-1+Tlist.size())%Tlist.size();            
          while(Tlist.get(select).Health<=0){
             select=(select-1+Tlist.size())%Tlist.size();            
          }
        }
        if(RightPress==1){
          attacksel=(attacksel+1)%P.Alist.size();
        }
        if(LeftPress==1){
          attacksel=(attacksel-1+P.Alist.size())%P.Alist.size();
        }
        if(Pressed==1){
          attack at =P.Alist.get(attacksel);
          at.affectedPPL.add(P);
          at.affectedPPL.add(Tlist.get(select));
          at.doAttack();
          while(at.affectedPPL.size()>0){
            at.affectedPPL.remove(0);
          }
          if(P.Damage<=0){
            P.Damage=0;
          }
          round++;
        }
      }
    }
  }
  int attackWait=0;
  void personAttack(int n){
    person t= Tlist.get(n);
    if((round % (Tlist.size()+1))==n+1){
      if(t.Health>0){
        if(attackWait>=20){
          t.attack(P);
          round++;
          attackWait=0;
        }else{
         attackWait++;
        }
      }else{
        round++;
      }
    }
  }
  void allAttack(){
    buttonToAttack();
    for(int i=0;i<Tlist.size();i++){
      personAttack(i);
      if( Tlist.get(i).Damage<0){
        Tlist.get(i).Damage=0;
      }
    }
  }
  int outcome(){
    int result=2;
    for(int i=0;i<Tlist.size();i++){
      person pr=Tlist.get(i);
      if(pr.Health<=0){
        if ((result==0)==false){
          result =2;
        }
      }else{
        if(result==2){
          result =0;
        }
      }
    }
    if(P.Health<=0){
      result=1;
    }
    return result;
  }
  void displaybattle(person p,float x, float y){
    text(p.Health+"/"+p.TopHealth+"  _"+p.Damage+"  "+p.Energy,x,y);
    image(p.Image,x,y,50,50);
  }
  
  void battleimage(){
    text("round- "+round,100,130);
    if(Pressed==1){
      text("CLICK",10,10);
    }
    text(Tlist.size(),10,20);
    displaybattle(P,40,170);
    for(int i=0;i<Tlist.size();i++){
      person t= Tlist.get(i);
      if(t.Health>0){displaybattle(t,400,(8*i+2)*10);}else{text("dead",400,(8*i+2)*10);}
    }
    if((round % (Tlist.size()+1))==0){
      text("<-",100,200);
      text("Attack ->",330,(8*((select+1) % (Tlist.size()+1)))*10-30);
      text("^",120+70*attacksel,350);
    }else{
      text("<-",480,(8*(round % (Tlist.size()+1)))*10-30);
    }
    for(int i=0; i<P.Alist.size();i++){
      attack A=P.Alist.get(i);
      A.display(120+70*i,230);
    }
    
  }
  int winwait=0;
  void endCard(){
    if(outcome()==2){
      if(winwait>120){
        for(int i=0;i<Tlist.size();i++){
          Tlist.get(0).alive=false;
          Tlist.remove(0);
        }
        fighting=false;
        W.world=true;
        winwait=0;
      }else{
        textSize(60);
        text("WIN YAY",220,200);
        winwait++;
        textSize(14);
      }
    }else{
      textSize(50);
      text("YOU DID THE DIE",20,200);
      textSize(14);
    }
  }
  void system(){
    if(fighting){
      if(outcome() ==0){
        battleimage();
        allAttack();
      }else {
        endCard();
      }
    }
  }
}