class Level{
  ArrayList<Note> Notes= new ArrayList<Note>();
  float time=0;
  float doneTime=7;
  float scale=100;
  float count=1;
  float amountCorrect=0;
  char[] channels= {'a','s','d','f'};
  Level(){
    
  }
  void drawLevel(){
    if(time<doneTime){
     for( Note N: Notes){
        N.drawNote(time,scale);
        if(N.onAtTime(time)){
           fill(N.Color);
           rect(N.channel*50,400,50,-20);
        }
     }
     int channelpressed=0;
     if(keyPressed){
       for(int i=0;i<channels.length;i++){
         if(key==(channels[i])){
           fill(0,0,255);
           rect(i*50,400,50,-10);
           channelpressed=i;
         }
       }
     }
     for( Note N: Notes){
        if(N.onAtTime(time)&&(channelpressed==N.channel)){
          fill(0,255,0);
           rect(N.channel*50+25,400,25,-10);
           amountCorrect++;
        }if((!N.onAtTime(time))&&(channelpressed!=N.channel)){
           amountCorrect++; 
        }
     }
    }
     text("Acc:"+(amountCorrect/(count*4)),200,10);
     
  }
}
class Note{
  float startTime;
  float Time;
  int Color;
  int channel;
 Note(float dstartTime, float dtime, int dColor, int dChannel){
   startTime=dstartTime;
   Time=dtime;
   Color=dColor;
   channel=dChannel;
 }
 
 boolean onAtTime(float time){
  return  (time>startTime)&&(time<startTime+Time);
 }
 void drawNote(float time,float scale){
  fill(Color);
  rect(channel*50,(time-startTime)*scale+400,50,-Time*scale);
 }
}
Level L= new Level();
void setup(){
  size(400,400,P2D);
  L.Notes.add(new Note( 7, 0.4,color(250,0,0),3));
  L.Notes.add(new Note( 6.6, 0.4,color(250,0,0),2));
  L.Notes.add(new Note( 6.2, 0.4,color(250,0,0),1));
  L.Notes.add(new Note( 5.8, 0.4,color(250,0,0),0));
  L.Notes.add(new Note( 5.2, 0.2,color(250,0,0),0));
  L.Notes.add(new Note( 5, 0.2,color(250,0,0),1));
  L.Notes.add(new Note( 4.6, 0.2,color(250,0,0),0));
  L.Notes.add(new Note( 4.2, 0.2,color(250,0,0),1));
  L.Notes.add(new Note( 4, 0.2,color(250,0,0),0));
  L.Notes.add(new Note( 3, 0.2,color(250,0,0),1));
  L.Notes.add(new Note( 2, 0.2,color(250,0,0),0));
  L.Notes.add(new Note( 1, 0.2,color(250,0,0),1));
}

void draw(){
 background(255);
 //rect(10,10,100,100);
 //N.drawNote(0,100);
 L.drawLevel();
 L.time+=0.04;
 L.count++;
}