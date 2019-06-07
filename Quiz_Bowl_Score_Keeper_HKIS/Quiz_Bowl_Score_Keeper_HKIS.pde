Player player1;
Player player2;
PFont font;
PFont font2;
PImage logo;
void setup(){
  fullScreen();
  frameRate(30);
  player1 = new Player("Teachers");
  player2 = new Player("Students");
  font = createFont("Poppins-MediumItalic.otf",80);
  font2 = createFont("Poppins-SemiBoldItalic.otf",80);
  logo = loadImage("logo.png");
  
}

void draw(){
   background(255);
   //Boredom repellent
  drawBG(((float)frameCount)/10.0);
   
   
   textFont(font);
   textSize(50);
   fill(0);
   textAlign(CENTER);
   image(logo, width/2-logo.width/5,height/2-logo.height/5,(int)logo.width/2.5, (int)logo.height/2.5);
   text("HKIS Quiz Bowl Teacher-Student Intramural", width/2, 150);
   textSize(80);
   fill(120,10,20);
   text(player1.name(), width/2 - 500, height/2 -200);
   fill(10,20,120);
   text(player2.name(), width/2 + 500, height/2 -200);
   textFont(font2);
   fill(0);
   textSize(200);
   if(player1.score() > player2.score()){
     fill(20, 200, 53);
     text(player1.score(), width/2 - 500, height/2 + 50);
   }else{
     fill(0);
     text(player1.score(), width/2 - 500, height/2 + 50); 
   }
   if(player2.score() > player1.score()){
     fill(20, 200, 53);
     text(player2.score(), width/2 + 500, height/2 + 50);
   }else{
     fill(0);
     text(player2.score(), width/2 + 500, height/2 + 50);
   }
   fill(0);
   textFont(font);
   textSize(40);
   text("regulars: " + player1.reg(), width/2 -500, height/2 + 200);
   text("powers: " + player1.powers(), width/2 -500, height/2 + 300);
   text("negs: " + player1.negs(), width/2 -500, height/2 + 400);
   text("regulars: " + player2.reg(), width/2 +500, height/2 + 200);
   text("powers: " + player2.powers(), width/2 +500, height/2 + 300);
   text("negs: " + player2.negs(), width/2 +500, height/2 + 400);
   

}

void keyPressed(){
 switch(key){
   case 'a':
     player1.answer("reg");
     break;
   case 's':
     player1.answer("power");
     break;
   case 'd':
     player1.answer("neg");
     break;
   case 'f':
     player2.answer("reg");
     break;
   case 'g':
     player2.answer("power");
     break;
   case 'h':
     player2.answer("neg");
     break;
   case '=':
     player1.scoreUpdate(5);
     break;
   case '-':
     player1.scoreUpdate(-5);
     break;
   case '+':
     player2.scoreUpdate(5);
     break;
   case '_':
     player2.scoreUpdate(-5);
     break;
 }
}