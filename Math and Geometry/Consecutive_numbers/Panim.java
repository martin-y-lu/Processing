import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import processing.core.PApplet;
interface Controller{
  void setFrame(int framecount);
  int getFrame();
  PApplet getApplet();
  int getLastFrame();
  void setLastFrame(int _lastFrame);
  public int depth();
}

abstract class AnimController implements Controller,Serializable, Renderable{
  ArrayList<Transition> transitions= new ArrayList<Transition>();
  ArrayList<Transition> completed= new ArrayList<Transition>();
  protected PApplet applet;
  public PApplet getApplet(){
    return applet; 
  }
  
  AnimController(){}
  AnimController(PApplet _applet){
    applet=_applet; 
  }
  public AnimController _Applet(PApplet _applet){
    applet=_applet; 
    return this;
  }
  AnimController state=this;
  int lastFrame=0;
  public int getLastFrame(){
    return lastFrame;
  }
  public void setLastFrame(int _lastFrame){
    lastFrame=_lastFrame;
  }
  boolean end=false;
  public int depth(){
    return 0; 
  }
  Transition currentTransition;
  int frame;
  public void setFrame(int framecount){
    frame = framecount; 
  }
  public int getFrame(){
    return frame;
  }
  
  public abstract void setup();
  public void draw(){};
  /////---- util---
  
  public void runProcess(int framecount){
    setFrame(framecount); 
    if(!end){
      if(currentTransition==null){
        currentTransition=transitions.remove(0);
        currentTransition.start();
        currentTransition.set(this);
      }
      currentTransition.commitLen();
      currentTransition.run(frame);
      if(currentTransition.after(frame)){
        do{
           currentTransition.end();
           currentTransition.complete();
          if(transitions.size()>=1){
            applet.println(PanimUtil.repString("  ",depth())+"Transition ended, currently "+transitions.size()+" transitions +depth "+depth()+":");
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
            applet.println(PanimUtil.repString("  ",depth())+"Ending controller");
            end=true;
            break;
          }
        }while(currentTransition.getLen()==0);
      }
    }
  }
  public void add(Transition ... anims){
    for(Transition anim: anims){
      add(anim); 
    }
  }
  private void add(Transition anim){
    transitions.add(anim); 
  }
  public int totalLength(){
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
  public int numTransitions(){
    return transitions.size()+completed.size()+(currentTransition!=null?1:0);
  }
  public void render(){
    draw();
    drawProcedures();
  }
  void drawProcedures(){
    if(currentTransition instanceof Renderable){
       ((Renderable) currentTransition).render(); 
    }
  }
}
//abstract class AnimProcedure extends 
interface Transition{
  public void set(Controller controller);
  public void play(int frame,float fract);
  public void start();
  public void end();
  public void run(int framecount);
  public int getLen();
  public void commitLen();
  public boolean after(int framecount);
  public void complete();
  public boolean completed();
}
abstract class AnimProcedure extends AnimController implements Transition{
  Controller controller;
  private int len=1;
  private int startFrame;
  private int endFrame;
  public boolean completed=false;
  public int depth(){
    if(controller==null) return -1;
    return controller.depth()+1; 
  }
  public void set(Controller _controller){
    controller= _controller;
    applet=controller.getApplet();
    startFrame= controller.getLastFrame();
  }
  public void commitLen(){
    len=getLen();
    endFrame=startFrame+len;
    controller.setLastFrame(endFrame);
  }
  public void complete(){ completed= true; }
  public boolean completed() { return completed;}
  //public void setFrame(){
  //  //print(controller+"   "+this);
  //  if(controller==null){
  //  }else{
  //    frame= controller.frame-startFrame;
  //  }
    
  //}
  public void start(){
    applet.println(PanimUtil.repString("  ",depth())+"Starting a procedure +depth "+depth()+":");
    setup();
    len=totalLength();
    applet.println("Length:"+ getLen());
  }
  public void play(int frame,float fract){
    if(controller!=null){
      runProcess(controller.getFrame()-startFrame);
    }
  }
  public void end(){
    if(currentTransition!=null){
      currentTransition.end();
      currentTransition.complete();
    }
    applet.println(PanimUtil.repString("  ",depth())+"Ending a procedure+depth "+depth()+":");
  };
  public void run(int framecount){
    //commitLen();
    if(framecount>startFrame&&framecount<startFrame+len){
      play(framecount-startFrame, ((float)(framecount-startFrame))/len);
    }
  }
  public int getLen(){
    len=totalLength();
    return len+1; 
  }
  public boolean after(int framecount){
    //print("Total length:"+totalLength());
    return framecount>startFrame+totalLength();
    //return end;
  }
  public void draw(){};
  
  static AnimProcedure asProcedure(Transition... _transitions){
    final Transition[] transit=_transitions;
    return new AnimProcedure(){
      public void setup(){
        for(Transition _transition:transit){  
          add(_transition);
        }
      }
    };
  }
  
}

interface Drawable{
  public void draw(); 
}
interface Renderable{
  public void render(); 
}
abstract class AnimTransition implements Transition{
  Controller controller;
  private int len;
  int startFrame;
  private int endFrame;
  public boolean completed=false;
  public AnimTransition(){ 
  }
  public AnimTransition(int _len){
    //len= _len;
    _Len(_len);
  }
  public AnimTransition _Len(int _len){
    len=PApplet.max(0,_len);
    return this;
  }
  public int getLen(){
    return effectiveLen(); 
  }
  public int effectiveLen(){
    return len; 
  }
  public void set(Controller _controller){
    controller=_controller;
    startFrame=controller.getLastFrame();
  }
  public void commitLen(){
    endFrame=startFrame+effectiveLen();
    controller.setLastFrame(endFrame);
  }
  public void complete(){ completed= true; }
  public boolean completed() { return completed;}
  public boolean after(int framecount){
    return framecount>startFrame+effectiveLen(); 
  }
  public void run(int framecount){
    if(framecount>startFrame&&framecount<startFrame+effectiveLen()){
      play(framecount-startFrame,((float)( framecount-startFrame))/effectiveLen());
    }
  }
}
class AnimConcurrent implements Controller,Transition, Renderable{
  ArrayList<Transition> transitions = new ArrayList<Transition>();
  PApplet applet;
  public PApplet getApplet(){
    return applet;
  }
  
  Controller controller;
  private int len;
  int startFrame;
  private int endFrame;
  public boolean completed=false;
  int frame;
  AnimConcurrent(Transition... _transitions){
    add(_transitions);
  }
  public int getLastFrame(){
    return 0; 
  }
  public void setLastFrame(int _lastFrame){
    //ignore, because concurrency implies all frames start at time 0
  }
  public int depth(){
    if(controller==null) return -1;
    return controller.depth()+1; 
  }
  public int getFrame(){
    return frame;
  }
  public void setFrame(int framecount){
    frame = framecount; 
  }
  
  
  public final AnimConcurrent add(Transition... _transitions){
    for(Transition _transition : _transitions){
      transitions.add(_transition);
    }
    return this;
  }
  public final void set(Controller _controller){
    controller=_controller;
    startFrame=controller.getLastFrame();
    applet=controller.getApplet();
  }
  public final int getLen(){
    //applet.println("Number of transitions in this concurrent: "+transitions.size());
    int _len=0;
    for(Transition transition: transitions){
       int _transit_len= transition.getLen();
       if(_transit_len>_len){
          _len=_transit_len;
       }
    }
    len=_len+1;
    //applet.println("length of this concurrent:"+len);
    return len;
  }
  public final void commitLen(){
    endFrame=startFrame+getLen();
    controller.setLastFrame(endFrame);
  }
  public final void start(){
    applet.println("Starting concurrent");
    for(Transition transition: transitions){
       transition.start();
       transition.set(this);
       //transition.commitLen();
    }
    getLen();
  }
  public final void play(int frame,float fract){
    for(Transition transition: transitions){
       if(transition.after(frame)){
         if(!transition.completed()){
             transition.end();
             transition.complete();
         }
       }else{
         transition.commitLen();
         transition.run(frame);
         
       }
    }
  }
  public final void end(){
     applet.println("Ending concurrent");
  };
  
  public final void run(int framecount){
    setFrame(framecount-startFrame);
    if(framecount>startFrame&&framecount<startFrame+getLen()){
      play(framecount,((float)( framecount-startFrame))/getLen());
    }
  }
  public final void complete(){ completed= true; }
  public final boolean completed() { return completed;}
  public final boolean after(int framecount){ return framecount>startFrame+getLen(); }
  
  public void render(){
     for(Transition transition: transitions){
       if(transition instanceof Renderable){
         ((Renderable) transition).render(); 
       }
     }
  }
}
//Functional interface
interface AnimEventOccur{
  public void occur(); 
}

abstract class AnimEvent extends AnimTransition{
   public AnimEventOccur event;
   public AnimEvent(){
     super(0);
   }
   public AnimEvent(AnimEventOccur _event){
     super(0);
     event=_event;
   }
   public void occur(){
     if(event!=null){
       event.occur();  
     }
   }
   public void start(){
     occur(); 
   }
   public void play(int frame,float fract){};
   public void end(){};
}
class DelayTransition extends AnimTransition{
  public DelayTransition(int _len){
    super(_len);
  }
  public void play(int frame, float fract){
  //nothing !
  }
  public void start(){
  //nothing ! 
  }
  public void end(){
  //nothing ! 
  }
  
}
class PanimUtil{
  static String repString(String str,int num){
    String rep="";
    for(int i=0;i<num;i++){
      rep+=str; 
    }
    return rep;
  }
}
