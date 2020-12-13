public class Timer{
   int starttime = 0;
   int time=0;
   boolean rolling=false;
   public Timer(int hour,int min, int sec){
     time=1000*(sec+ 60*(min+60*hour));
     starttime=millis()+time;
     rolling= false;
   }
   public int milli(){
     if(rolling){
       return starttime-millis(); 
     }else{
       return time; 
     }
   }   
   public int seconds(){
     return (milli()/1000)%60;
   }
   public int minutes(){
     return (milli()/(1000*60))%60;
   }
   public int hours(){
     return (milli()/(1000*60*60))%12;
   }

   public void startTimer(){
     rolling= true;
     starttime=millis()+time;
   }
   public void stopTimer(){
     time= milli();
     rolling= false;
   }
   public String toString(){
       return minutes()+":"+nf(seconds(),2);
   }
}
public class Texter{
  float index= 0;
  float rate;
  float pauseRate=0.058;
  String Target;
  boolean rolling=false;
  public Texter(String dTarget, float dRate){
     Target =dTarget;
     rate= dRate;
  }
  public void startTexter(){
     rolling=true;
  }
  public void update(){
    if(rolling){
      if(Target.charAt(floor(index))=='.'){
        index+=pauseRate; 
      }else{
        index+=rate;
      }
      
      if(index>Target.length()-1){
        index=Target.length()-1;
      }
    }
  }
  public void stopTexter(){
     rolling=false;
  }
  public void resetTexter(){
    index=0;
  }
  public String toString(){
    return Target.substring(0,floor(index));
  }
  
}