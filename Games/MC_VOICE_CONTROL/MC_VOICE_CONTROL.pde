import java.awt.*;
import java.awt.event.*;

import org.jnativehook.GlobalScreen;
import org.jnativehook.NativeHookException;
//import org.jnativehook.mouse.NativeMouseEvent;
//import org.jnativehook.mouse.NativeMouseInputListener;
//import GlobalScreen;
//import NativeHookException;
//import NativeMouseEvent;
//import NativeMouseInputListener;

Robot robot;
PFont pfont;
Point save_p;

char KEY=' ';

public class GlobalKeyListenerExample implements NativeKeyListener {
  int dir=0;
  public void nativeKeyPressed(NativeKeyEvent e) {
    String pressed=NativeKeyEvent.getKeyText(e.getKeyCode());
    System.out.println("Key Pressed: " + pressed);
    
    if (e.getKeyCode() == NativeKeyEvent.VC_ESCAPE) {
      try{
        GlobalScreen.unregisterNativeHook();
      }catch(Exception exc){ 
      }
    }
    switch(pressed){
       case "I":
          //println("GO UP");
          dir=0;
          break;
       case "K":
         dir=1;
         break;
       case "J":
         dir=2;
         break;
       case "L":
         dir=3;
         break;
       case "U":
          try{
          robot.mousePress(InputEvent.BUTTON1_DOWN_MASK);
          robot.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);
          robot.waitForIdle();
          }catch(Exception exc){
            
          }
         break;
    }
    //switch(dir){
    //   case 0:
    //      println("GO UP");
    //      if (save_p != null) {
    //        save_p= new Point((int)save_p.getX(),(int)save_p.getY()-speed);
    //        mouseMove((int)save_p.getX(), (int)save_p.getY());
    //      }
    //      break;
    //   case 1:
    //    if (save_p != null) {
    //        save_p= new Point((int)save_p.getX(),(int)save_p.getY()+speed);
    //        mouseMove((int)save_p.getX(), (int)save_p.getY());
    //      }
    //     break;
    //   case 2:
    //     if (save_p != null) {
    //        save_p= new Point((int)save_p.getX()-speed,(int)save_p.getY());
    //        mouseMove((int)save_p.getX(), (int)save_p.getY());
    //      }
    //     break;
    //   case 3:
    //     if (save_p != null) {
    //        save_p= new Point((int)save_p.getX()+speed,(int)save_p.getY());
    //        mouseMove((int)save_p.getX(), (int)save_p.getY());
    //      }
    //     break;
    //}
  }
  
  public void nativeKeyReleased(NativeKeyEvent e) {
    System.out.println("Key Released: " + NativeKeyEvent.getKeyText(e.getKeyCode()));
  }
  public void nativeKeyTyped(NativeKeyEvent e) {
    System.out.println("Key Typed: " + e.getKeyText(e.getKeyCode()));
    
  }
}
 
 GlobalKeyListenerExample listener=new GlobalKeyListenerExample();
 

void setup() {
  frameRate(10);
  size(320, 240);
  try {
    GlobalScreen.registerNativeHook();
  }
  catch (NativeHookException ex) {
    System.err.println("There was a problem registering the native hook.");
    System.err.println(ex.getMessage());  
    
    System.exit(1);
  }
  
  GlobalScreen.addNativeKeyListener(listener);
  try { 
    robot = new Robot();
    robot.setAutoDelay(0);
  } 
  catch (Exception e) {
    e.printStackTrace();
  }

  pfont = createFont("Impact", 32);
}
int speed=100;
void draw() {
  background(#ffffff);
  fill(#000000);
  
  Point p = getGlobalMouseLocation();
  
  textFont(pfont);
  text("now x=" + (int)p.getX() + ", y=" + (int)p.getY(), 10, 32);
  
  if (save_p != null) {
  text("save x=" + (int)save_p.getX() + ", y=" + (int)save_p.getY(), 10, 64);
  }
  save_p=getGlobalMouseLocation();
    switch(listener.dir){
       case 0:
          println("GO UP");
          if (save_p != null) {
            save_p= new Point((int)save_p.getX(),(int)save_p.getY()-speed);
            mouseMove((int)save_p.getX(), (int)save_p.getY());
          }
          break;
       case 1:
        if (save_p != null) {
            save_p= new Point((int)save_p.getX(),(int)save_p.getY()+speed);
            mouseMove((int)save_p.getX(), (int)save_p.getY());
          }
         break;
       case 2:
         if (save_p != null) {
            save_p= new Point((int)save_p.getX()-speed,(int)save_p.getY());
            mouseMove((int)save_p.getX(), (int)save_p.getY());
          }
         break;
       case 3:
         if (save_p != null) {
            save_p= new Point((int)save_p.getX()+speed,(int)save_p.getY());
            mouseMove((int)save_p.getX(), (int)save_p.getY());
          }
         break;
    }
    robot.waitForIdle();
    
  //}
}

void keyPressed() {
  switch(key) {
  case 'r':
    save_p = getGlobalMouseLocation();
    break;
  //case 'm':
  //  if (save_p != null) {
  //    mouseMove((int)save_p.getX(), (int)save_p.getY());
  //  }
  //  break;
  //case 'c':
  //case ' ':
  //  if (save_p != null) {
  //    mouseMoveAndClick((int)save_p.getX(), (int)save_p.getY());
  //  }
  //  break;
  case 'e':
    exit();
  }
}

Point getGlobalMouseLocation() {
  // java.awt.MouseInfo
  PointerInfo pointerInfo = MouseInfo.getPointerInfo();
  Point p = pointerInfo.getLocation();
  return p;  
}

void mouseMove(int x, int y) {
   try{
  robot.mouseMove(x, y);
  }catch(Exception exc){ 
      }
  
}

void mouseMoveAndClick(int x, int y) {
  try{
  robot.mouseMove(x, y);
  robot.mousePress(InputEvent.BUTTON1_DOWN_MASK);
  robot.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);
  robot.waitForIdle();
  }catch(Exception exc){ 
      }
}
