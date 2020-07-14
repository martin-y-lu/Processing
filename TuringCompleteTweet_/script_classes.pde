class Command{
  int type;
  int data;
  boolean scaled;
  int relativeto=0;
  Command(int dType,int dData,boolean dScaled,int dRelative){
    //if(dType>3||dType<0){
    //  throw new Exception("dtype not in range");
    //}
    type=dType;
    data=dData;
    scaled=dScaled;
    relativeto=dRelative;
  }
  char t(){
    return 'A';
  }
}
class id extends Command{
  id(int a){
    super(0,a,true,0);
  }
  char t(){
    return char((65+data*4)*4);
  }
}

Command id(int a){
  return new id(a);
}
class sp extends Command{
  sp(int a){
    super(1,a,false,0);
  }
  char t(){
    return char((65+data)*4+1);
  }

}
Command sp(int a){
  return new sp(a);
}

class ja extends Command{
  ja(int a){
    super(2,a,false,0);
  }
  char t(){
    return char((65+data)*4+2);
  }
  
}
Command ja(int a){
  return new ja(a);
}

class jr extends Command{
  jr(int a){
    super(2,a,false,0);
  }
  char t(){
    return char((65+data+relativeto)*4+2);
  }
}
Command jr(int a){
  return new jr(a);
}

class com extends Command{
  com(int a){
    super(3,a,false,0);
  }
  char t(){
    return char(data*4+3);
  }
}
Command com(int a){
  return new com(a);
}
class num extends Command{
  num(int a){
    super(3,a,false,0);
  }
  char t(){
    return char((data+65)*4+3);
  }
}
Command num(int a){
  return new num(a);
}

float setD(int ind,Command[] A){
   for(int i=0;i<A.length;i++){
      if(A[i] instanceof jr){
         if(A[i].data<0){
           A[i].relativeto=ind+A.length;
         }else{
           A[i].relativeto=ind;
         }
         
      }
      D[ind+i]=A[i].t();
   }
   return A.length;
}
float setD(int ind,Command A){
   D[ind]=A.t();
   return 1;
}

int l=0;
void app(Command[] c){
  l+=setD(l,c);
}
