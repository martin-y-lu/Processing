import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
import processing.serial.*;

ControlIO control; // dont delete this
Configuration config; //idk some default code dont delete 
ControlDevice gpad; // object for gamepad
Serial myPort; // creates object for communicating between arduino and processing
int scale;
public void setup() {
  scale = 63; // scale the power of the motors
  size(200, 200); //idk what size does but i dont think it works without it its for the gui
  // Initialise the ConstrolIO
  control = ControlIO.getInstance(this);
  // Find a device that matches the configuration file
  gpad = control.getMatchedDevice("robotdefault");
  String portName ="/dev/tty.usbmodem1411";  // change the the value in squarebrackets to whatever port you're gonna use
  myPort = new Serial(this, portName, 115200);
  if (gpad == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW! ur rekt if this shows up
  }
  printArray(Serial.list());
  delay(5000);
}

public void draw() {
  byte yposleftstick = (byte)Math.round(scale*(gpad.getSlider("XL").getValue())+63);
  byte xposrightstick = (byte)Math.round(scale*(gpad.getSlider("YL").getValue())+63);
  byte xposleftstick = (byte)Math.round(scale*(gpad.getSlider("XR").getValue())+63);
  byte aux1 = (byte)Math.round(scale*(gpad.getSlider("YR").getValue())+63);
  byte yposrightstick = (byte)Math.round(scale*(gpad.getSlider("RT").getValue())+63);
  byte righttrigger = (byte)Math.round(scale*(gpad.getSlider("LT").getValue())+63);
  byte aux2 = (byte)(gpad.getButton("XBUT").pressed() ? 1 : 0);
  byte aux3 = (byte)(gpad.getButton("YBUT").pressed() ? 1 : 0);

  byte out[] = new byte[8]; //output array should be right
  out[0] = yposleftstick; 
  out[1] = xposrightstick;
  out[2] = xposleftstick;
  out[3] = aux1;
  out[4] = yposrightstick;
  out[5] = righttrigger;
  out[6] = aux2;
  out[7] = aux3; //i did this at night and i forgot about naming conventions sorry
  //println(out[4]);
  int motPow[]= new int[4];
  motPow[0]=1500;
  motPow[1]=1500;
  motPow[2]=1500;
  motPow[3]=round(map(float(out[2]),0.0,125.0,1500.0-50,1500+50));
  String Out="";
  for (int i = 0; i < motPow.length; i++) {
    Out+= motPow[i]+":";
  }
  Out+="/n";
  println(Out);
  for (int i = 0; i < out.length; i++) {
    print(out[i] + ", ");
  }
  println("");
  
  myPort.write(Out.getBytes()); //doesn't accept float arrays so I converted to byte array bamboozled the system
  delay(40); //restrict outflow of data to prevent overclocking arduino and computer
}