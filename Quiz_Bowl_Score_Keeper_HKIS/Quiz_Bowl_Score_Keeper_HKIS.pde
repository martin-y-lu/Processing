Player player1;
Player player2;
PFont font;
PFont font2;
PImage logo;
Timer timer;
Texter texter;

String[] Questions;
int questionNumber=0;
String[] CurrentQuestion;
void setup(){
  fullScreen();
  player1 = new Player("Teachers");
  player2 = new Player("Students");
  font = createFont("Poppins-MediumItalic.otf",80);
  font2 = createFont("Poppins-SemiBoldItalic.otf",80);
  logo = loadImage("logo.png");
   timer= new Timer(0,12,0);
   //timer.startTimer();
   Questions= loadStrings("questions.txt");
   
   printArray(Questions);
   texter= new Texter(Questions[0],0.9);
}

void draw(){
   background(255);
   textFont(font);
   textSize(50);
   fill(0);
   int scoreHeight=630;
   textAlign(CENTER);
   float logoScale=0.15;
   image(logo, width/2-logo.width*logoScale,scoreHeight*0.4-logo.height*logoScale,(int)logo.width*logoScale*2, (int)logo.height*logoScale*2);
   text("Intramural 2", width/2, scoreHeight*0.15);
   textSize(160);
   text(timer.toString(), width/2, scoreHeight*0.85);
   textSize(80);
   text(player1.name(), width/2 - 500, scoreHeight*0.15 +20);
   text(player2.name(), width/2 + 500, scoreHeight*0.15 +20);
   textFont(font2);
   //textSize(200);
   //if(player1.score() > player2.score()){
   //  fill(20, 200, 53);
   //  text(player1.score(), width/2 - 500, scoreHeight/2 + 50);
   //  fill(0);
   //  text(player2.score(), width/2 + 500, scoreHeight/2 + 50);
   //}
   //else if(player2.score() > player1.score()){
   //  fill(20, 200, 53);
   //  text(player2.score(), width/2 + 500, scoreHeight/2 + 50);
   //  fill(0);
   //  text(player1.score(), width/2 - 500, scoreHeight/2 + 50);
     
   //}
   //else{
   //  text(player1.score(), width/2 - 500, scoreHeight/2 + 50);
   //  text(player2.score(), width/2 + 500, scoreHeight/2 + 50);
   //}
   
   textSize(190);
   if(player1.score() > player2.score()){
     fill(20, 200, 53);
   }else if(player2.score() > player1.score()){
     fill(0);
   }else{
     fill(0);
   }
   text(player1.score(), width/2 - 500, scoreHeight*0.42 + 50);
   
   if(player1.score() > player2.score()){
     fill(0);
   }else if(player2.score() > player1.score()){
     fill(20, 200, 53);
   }else{
     fill(0);  
   }
   text(player2.score(), width/2 + 500, scoreHeight*0.42 + 50);
     
   textFont(font);
   fill(0);
   textSize(42);
   text("regulars:"+ player1.reg(), width/2 -500, scoreHeight*0.7 -20);
   text("powers: " + player1.powers(), width/2 -500, scoreHeight*0.8 -20);
   text("negs: " + player1.negs(), width/2 -500, scoreHeight*0.9 -20);
   text("regulars: " + player2.reg(), width/2 +500, scoreHeight*0.7 -20);
   text("powers: " + player2.powers(), width/2 +500, scoreHeight*0.8 -20);
   text("negs: " + player2.negs(), width/2 +500, scoreHeight*0.9 -20);
   
   textSize(30);
   texter.update();
   textAlign(LEFT);
   text("Question "+questionNumber+": " + texter.toString(), 50, scoreHeight*1-10 ,width-100,300);
}

void keyPressed(){
 switch(key){
   case ' ':
     if(timer.rolling){
       timer.stopTimer();
     }else{
       timer.startTimer();
     }
     break;
   case 'r':
     timer=new Timer(0,12,0);
     break;
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
   case 'j':
     player1.scoreUpdate(5);
     break;
   case 'k':
     player1.scoreUpdate(-5);
     break;
   case 'l':
     player2.scoreUpdate(5);
     break;
   case ';':
     player2.scoreUpdate(-5);
     break;  
 }
 switch (keyCode){
      case UP:
         if(texter.rolling){
           texter.stopTexter(); 
         }else{
           texter.startTexter(); 
         }
         break;
      case DOWN:
        texter.resetTexter();
        texter.stopTexter(); 
        break;
      case RIGHT:
         questionNumber++;
         if(questionNumber>Questions.length-1){
           questionNumber=Questions.length-1;
         }
         texter=new Texter(Questions[questionNumber],0.9);
         break;
       case LEFT:
         questionNumber--;
         if(questionNumber<0){
          questionNumber=0; 
         }
         texter=new Texter(Questions[questionNumber],0.9);
          
    }
}