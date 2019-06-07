class input{
  int keynum;
  int keyCodenum;
  input(int dkeyNum,int dkeyCodenum){
    keynum=dkeyNum; keyCodenum=dkeyCodenum;
  }
}
ArrayList<input> keysPressed = new ArrayList<input> ();
boolean checkforPress(input I){
  boolean found=false;
  for(int i=0;(i<keysPressed.size())&&(found==false);i++){
    if((keysPressed.get(i).keynum==I.keynum)&&(keysPressed.get(i).keyCodenum==I.keyCodenum)){
      found=true;
    }
  }
  return found;
}
int getPressnum(input I){
  boolean found=false;
  int Int=0;
  for(int i=0;(i<keysPressed.size())&&(found==false);i++){
    if((keysPressed.get(i).keynum==I.keynum)&&(keysPressed.get(i).keyCodenum==I.keyCodenum)){
      Int=i;
      found=true;
    }
  }
  return Int;
}
void keyPressed() {
  if(checkforPress(new input(key,keyCode))==false){
    keysPressed.add(new input(key,keyCode));
  }
}
void keyReleased() {
  if(checkforPress(new input(key,keyCode))){;
     keysPressed.remove(getPressnum(new input(key,keyCode)));
  }
}