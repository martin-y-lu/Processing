import java.lang.reflect.Method;
PImage img;
PImage goo;
PImage grass;
PFont camuc;
//player P= new player(100,140,40,img);
player P;
battle B;
world W;
void setup(){
    frameRate(60);
    size(640, 360); 
    keysPressed.add(new input(0,0));
    img = loadImage("player.png");
    goo = loadImage("goo.png");
    grass= loadImage("grass.png");
    camuc= createFont("ComicSansMS",12);
    textFont(camuc);
    
    P= new player(img,10,10,10,10,100,140,40,30);
    
    attack A= new attack("HURT");
    A.actions.add(new effect(0,0,0,-3));
    A.actions.add(new effect(-20,0,0,0));
    
    attack Aa= new attack("WEAKEN");
    Aa.actions.add(new effect(0,0,0,-5));
    Aa.actions.add(new effect(0,0,-15,0));
    P.Alist.add(A);
    P.Alist.add(Aa);
    B=new battle(P);

    W=new world(P);
    W.addgrid();
    W.People.add(new person(goo,80,80,80,80,100,120,30,20));
    W.People.add(new person(goo,50,50,50,50,100,120,30,20));
    W.People.add(new person(goo,60,60,60,60,120,120,5,20));
    W.People.add(new person(goo,70,70,70,70,20,120,20,20));
}
int Pressed=0;
int UpPress=0;
int DownPress=0;
int LeftPress=0;
int RightPress=0;
int time;
void draw(){
  Pressed =justStart(mousePressed,Pressed);
  UpPress =justStart(keyPressed &&(key==CODED)&&(keyCode==UP),UpPress);
  DownPress =justStart(keyPressed &&(key==CODED)&&(keyCode==DOWN),DownPress);
  LeftPress =justStart(keyPressed &&(key==CODED)&&(keyCode==LEFT),LeftPress);
  RightPress =justStart(keyPressed &&(key==CODED)&&(keyCode==RIGHT),RightPress);
  time++;
  background(160,190,255); 
  fill(0);
  W.system();
  B.system();
}