class Team{
  String TeamName;
  int Score;
  int Negs=0;
  int Tossups=0;
  int Powers=0;
  ArrayList<String> Questions;
  ArrayList<String> Console;
  Team(String dTeamName,int dScore){
    TeamName=dTeamName; 
    Score=dScore;
    Questions=new ArrayList<String>();
    Console=new ArrayList<String>();
    
  }
  public void Display(PVector Pos,color BG){
    int Width=600;
    fill(BG);
    strokeWeight(7);
    rect(Pos.x,Pos.y,Width,800);
    fill(0);
    textFont(Lato);
    
    textSize(80);
    textAlign(LEFT);
    text(TeamName,Pos.x+25,Pos.y+85);
    
    textAlign(CENTER);
    textSize(210);
    text(Score,Pos.x+Width*0.5,Pos.y+140+125);
    textSize(60);
    text("Tossups: "+Negs,Pos.x+Width*0.5,Pos.y+340);
    text("Power: "+Powers,Pos.x+Width*0.5,Pos.y+340+50);
    text("Negs: "+Negs,Pos.x+Width*0.5,Pos.y+340+100);
    
    textSize(45);
    textAlign(LEFT);
    for(int i=0;i<Console.size();i++){
      text(Console.get(i),Pos.x+25,Pos.y+510+50*i);
      
    }
    
    //text("row2",Pos.x+25,Pos.y+500+50);
    //text("row3",Pos.x+25,Pos.y+500+100);
  }
}

PImage QBLogo;
PFont Lato;
Team Team1;
Team Team2;
void setup(){
  Team1=new Team("HKIS Students",9991);
  Team2=new Team("HKIS Teachers",9991);
  
  Team1.Console.add("ROW 1");
  Team1.Console.add("ROW 2");
  Team1.Console.add("ROW 3");
  
  frameRate(60);
  fullScreen();
  QBLogo=loadImage("quiz bowl.jpg");
  Lato=createFont("Lato-Semibold.ttf",34);
}



void draw(){
  background(255);
  image(QBLogo,(width-QBLogo.width)/2,30);
  Team1.Display(new PVector(75,250),color(200,255,255));
  Team2.Display(new PVector(width-500-175,250),color(255,200,200));
}