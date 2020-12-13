boolean collision(object OA,object OB){
  return (OA.x>OB.x-40)&&(OA.x<OB.x+40)&&(OA.y>OB.y-40)&&(OA.y<OB.y+40);
}
class world{
  player P;
  ArrayList<person> People= new ArrayList<person>();
  boolean world=true;
  ArrayList<tile> space=new ArrayList<tile>();
  world(player dP){
    P=dP;
  }
  void persondelete(){
    for(int i=0;i<People.size();i++){
      if(People.get(i).alive==false){
        People.remove(i);
      }
    }
  }
  void addgrid(){
    for(int x=0;x<10;x++){
      for(int y=0;y<10;y++){
        space.add(new tile(grass,x*40,y*40,x*40,y*40));
      }
    }
  }
  void walk(){
    if(checkforPress(new input(119,87))){
      P.y-=5;
    }if(checkforPress(new input(115,83))){
      P.y+=5;
    }if(checkforPress(new input(97,65))){
      P.x-=5;
    }if(checkforPress(new input(100,68))){
      P.x+=5;
    }
  }
  
  void checkforbattle(person T){
    int collisionstart=0;
    collisionstart= justStart(collision(P,T),collisionstart);
    if(T.alive ==true){
      if(collisionstart==1){
        B.Tlist.add(T);
        world=false;
        B.fighting=true;
      }
    }
  }
  void roam(person T){
      if(T.derection==0){
        T.y-=1+T.Agro*5;
      }else if(T.derection==1){
        T.x+=1+T.Agro*5;
      }else if(T.derection==2){
        T.y+=1+T.Agro*5;
      }else if(T.derection==3){
        T.x-=1+T.Agro*5;
      }
      if(int(random(0,15-T.Agro*10))==0){
        T.derection=int(random(0,3));
      }  
  }
  void displayspace(){
    for(int i=0;i<space.size();i++){
      space.get(i).displaytile();
    }
  }
  void displayobj(object O){
    image(O.Image,O.x,O.y,50,50);
  }
  void system(){
    if(world){
      persondelete();
      displayspace();
      displayobj(P);
      for(int i=0; i<People.size();i++){
        displayobj(People.get(i));
        checkforbattle(People.get(i));
        roam(People.get(i));
      }
      walk();
    }
  }
}
class tile extends object{
  tile(PImage dtileart,float dx,float dy,float ddisplayx,float ddisplayy){
    super(dtileart,dx,dy,ddisplayx,ddisplayy);
  }
  void displaytile(){
    image(Image,displayx,displayy,50,50);
  }
}