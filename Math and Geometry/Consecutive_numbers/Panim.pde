abstract class AnimController{
  ArrayList<Transition> transitions= new ArrayList<Transition>();
  ArrayList<Transition> completed= new ArrayList<Transition>();
  int lastFrame=0;
  boolean end=false;
  int depth(){
    return 0; 
  }
  Transition currentTransition;
  int frame;
  void setFrame(){
    frame = frameCount; 
  }
  abstract void setup();
  abstract void draw();
  void run(){
    setFrame(); 
    if(!end){
      if(currentTransition==null){
        currentTransition=transitions.remove(0);
        currentTransition.start();
        currentTransition.set(this);
      }
      currentTransition.commitLen();
      currentTransition.run(frame);
      if(currentTransition.after(frame)){
        currentTransition.end();
        do{
          if(transitions.size()>=1){
            println(repString("  ",depth())+"Transition ended, currently "+transitions.size()+" transitions +depth "+depth()+":");
            //println(repString("  ",depth())+"CurrntTransition completed:"
            completed.add(currentTransition);
            currentTransition=transitions.remove(0);
            currentTransition.start();
            currentTransition.set(this);
            currentTransition.commitLen();
            if(currentTransition.getLen()!=0){
              break;
            }
          }else{
            println(repString("  ",depth())+"Ending controller");
            end=true;
            break;
          }
        }while(currentTransition.getLen()==0);
      }
    }
  }
  void add(Transition ... anims){
    for(Transition anim: anims){
      add(anim); 
    }
  }
  void add(Transition anim){
    transitions.add(anim); 
  }
  int totalLength(){
    int len=0;
    for(Transition trans:transitions){
      len+=trans.getLen();
    }
    for(Transition trans:completed){
      len+=trans.getLen();
    }
    if(currentTransition!=null){
      len+=currentTransition.getLen();
    }
    return len;
  }
  int numTransitions(){
    return transitions.size()+completed.size()+(currentTransition!=null?1:0);
  }
  void render(){
    draw();
    drawProcedures();
  }
  void drawProcedures(){
    if(currentTransition instanceof AnimProcedure){
       ((AnimProcedure) currentTransition).render(); 
    }
  }
}
abstract class AnimProcedure extends AnimController implements Transition{
  AnimController controller;
  private int len=1;
  private int startFrame;
  private int endFrame;
  int depth(){
    if(controller==null) return -1;
    return controller.depth()+1; 
  }
  void set(AnimController _controller){
    controller= _controller;
    startFrame= controller.lastFrame;
  }
  void commitLen(){
    len=getLen();
    endFrame=startFrame+len;
    controller.lastFrame=endFrame;
  }
  void setFrame(){
    //print(controller+"   "+this);
    if(controller==null){
      frame=frameCount; 
    }else{
      frame= controller.frame-startFrame;
    }
    
  }
  void start(){
    println(repString("  ",depth())+"Starting a procedure +depth "+depth()+":");
    setup();
    len=totalLength();
    println("Length:"+ getLen());
  }
  void play(int frame,float fract){
    run();
  }
  void end(){
    currentTransition.end();
    println(repString("  ",depth())+"Ending a procedure+depth "+depth()+":");
  };
  void run(int framecount){
    //commitLen();
    if(framecount>startFrame&&framecount<startFrame+len){
      play(framecount-startFrame,float( framecount-startFrame)/len);
    }
  }
  int getLen(){
    len=totalLength();
    return len+1; 
  }
  boolean after(int framecount){
    //print("Total length:"+totalLength());
    return framecount>startFrame+totalLength();
    //return end;
  }
  void draw(){};
  
}
//abstract class AnimProcedure extends 
interface Transition{
  void set(AnimController controller);
  void play(int frame,float fract);
  void start();
  void end();
  void run(int framecount);
  int getLen();
  void commitLen();
  boolean after(int framecount);
}
abstract class AnimTransition implements Transition{
  AnimController controller;
  private int len;
  int startFrame;
  private int endFrame;
  public AnimTransition(){ 
  }
  public AnimTransition(int _len){
    //len= _len;
    _Len(_len);
  }
  AnimTransition _Len(int _len){
    len=max(0,_len);
    return this;
  }
  int getLen(){
    return effectiveLen(); 
  }
  int effectiveLen(){
    return len; 
  }
  void set(AnimController _controller){
    controller=_controller;
    startFrame=controller.lastFrame;
  }
  void commitLen(){
    endFrame=startFrame+effectiveLen();
    controller.lastFrame=endFrame;
  }
  boolean after(int framecount){
    return framecount>startFrame+effectiveLen(); 
  }
  void run(int framecount){
    if(framecount>startFrame&&framecount<startFrame+effectiveLen()){
      play(framecount-startFrame,float( framecount-startFrame)/effectiveLen());
    }
  }
}
abstract class AnimEvent extends AnimTransition{
   AnimEvent(){
     super(0);
   }
   abstract void occur();
   void start(){
     occur(); 
   }
   void play(int frame,float fract){};
   void end(){
      
   };
  
}
class DelayTransition extends AnimTransition{
  DelayTransition(int _len){
    super(_len);
  }
  void play(int frame, float fract){
  //nothing !
  }
  void start(){
  //nothing ! 
  }
  void end(){
  //nothing ! 
  }
}
