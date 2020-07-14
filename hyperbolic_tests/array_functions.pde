static int[] copyArray(int[] a){
     int[] b= new int[a.length];
     for(int i=0;i<b.length;i++){
       b[i]=a[i]; 
     }
     return b;
}
static int[] removeLastElement(int[] a){
     if(a.length==0){ return new int[0];};
     int[] b= new int[a.length-1];
     for(int i=0;i<b.length;i++){
       b[i]=a[i]; 
     }
     return b;
}
static int[] appendElement(int[] a, int e){
  int[] b= new int[a.length+1];
   for(int i=0;i<a.length;i++){
     b[i]=a[i]; 
   }
   b[a.length]=e;
   return b;
}
static int[] section(int[]a,int start,int end){//Inclusive
   if(end>=a.length){
      end=a.length-1; 
   }
   if(end-start+1<0){
     return new int[0]; 
   }
   int[] sect= new int[end-start+1];
   for(int i=start;i<end+1;i++){
      sect[i-start]=a[i]; 
   }
   return sect;
}
static int ancestorIndex(int[] a,int[] b){
   for(int i=0; i<min(a.length,b.length);i++){
      if(a[i]!=b[i]){
        return i-1; 
      }
   }
   return min(a.length,b.length)-1;
}
