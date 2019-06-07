class SudokuGame{
  int Size=3; //The size of grid (normally 3)
  int[][]InitGrid;
  int[][]Grid; // Grid of numbers ranging from 1 to Size^2, (Size^2,Size^2), -1 for empty
  SudokuGame(int[][] dGrid){
     Size=int(sqrt(dGrid.length));
     InitGrid=CloneGrid(dGrid);
     Grid=CloneGrid(dGrid);
  }
  int[][] CloneGrid(int[][]oldGrid){
    int[][] newGrid= new int[Size*Size][Size*Size];
    for(int i=0;i<Size*Size;i++){
      arrayCopy(oldGrid[i],newGrid[i]);
    }
    return newGrid;
  }
  boolean Playable(int X,int Y){
    return InitGrid[Y][X]==-1;
  }
  
  void FillGrid(){
    for(int i=0;i<Size*Size;i++){
        int[]nonZero=new int[Size*Size+1];
        for(int j=0;j<Size*Size;j++){
          if(Grid[i][j]>0){
            nonZero[Grid[i][j]]++;
          }
        }
        int count=1;
        for(int j=0;j<Size*Size;j++){
          while((count<Size*Size)&&(nonZero[count]!=0)){
             count++;
          }
          if(InitGrid[i][j]==-1){
             Grid[i][j]=count;
             count++;
          }
        }
    }
  }
  int[] Column(int num){
    int[] arr=new int[Grid.length];
    for(int i=0;i<arr.length;i++){
      arr[i]=0;
    }
    for(int i=0;i<Grid.length;i++){
      arr[i]=Grid[i][num];
    }
    return arr;
  }
  int[] Square(int A,int B){
    int[] arr=new int[Size*Size];
    for(int i=0;i<arr.length;i++){
      arr[i]=0;
    }
    for(int i=0;i<Size;i++){
      for(int j=0;j<Size;j++){
        arr[j*Size+i]=Grid[i+A*Size][j+B*Size];
      }
    }
    return arr;
  }
  
  boolean Solved(){
    boolean solved=true;
    for(int i=0;i<(Size*Size);i++){
      if(!HasAllUnique(Grid[i])){
        solved=false;
      }
      if(!HasAllUnique(Column(i))){
        solved=false;
      }
    }
    for(int i=0;i<Size;i++){
      for(int j=0;j<Size;j++){
        if(!HasAllUnique(Square(i,j))){
          solved=false;
        }
      }
    }
    return solved;
  }
  boolean HasAllUnique(int[] Nums){
    int[] count=new int[Nums.length];
    for(int i=0;i<Nums.length;i++){
      if(Nums[i]>0){
        if(count[Nums[i]-1]==1){
         return false; 
        }
        count[Nums[i]-1]++;
      }
    }
    for(int i=0;i<count.length;i++){
      if(count[i]!=1){
        return false;
      }
    }
    return true;
  }
  int NumMissing(int[] Nums){
    int[] count=new int[Nums.length];
    for(int i=0;i<Nums.length;i++){
      if(Nums[i]>0){
        count[Nums[i]-1]++;
      }
    }
    int numMissing=0;
    for(int i=0;i<count.length;i++){
      if(count[i]==0){
        numMissing++;
      }
    }
    return numMissing;
  }
  int Cost(){
    int cost=0;
    for(int i=0;i<(Size*Size);i++){
      cost+=NumMissing(Grid[i]);
      cost+=NumMissing(Column(i));
    }
    for(int i=0;i<Size;i++){
      for(int j=0;j<Size;j++){
         cost+=NumMissing(Square(i,j));
      }
    }
    return cost;
  }
  void WriteValue(int X,int Y, int Value ){
    if((X>=0)&&(Y>=0)&&(X<Size*Size)&&(Y<Size*Size)){
      if((Value>=0)&&(Value<=Size*Size)){
        if(InitGrid[Y][X]==-1){
              Grid[Y][X]=Value;
              if(Value==0){
                Grid[Y][X]=-1;
              }
        }
      }
    }
  }
  void Swap(int X1,int Y1,int X2, int Y2){
    if(InitGrid[Y1][X1]==-1){
      if(InitGrid[Y2][X2]==-1){
        int store=Grid[Y1][X1];
        Grid[Y1][X1]=Grid[Y2][X2];
        Grid[Y2][X2]=store;
      }
    }
  }
  void DrawBG(){
    fill(240);
    strokeWeight(3);
    rect(100,100,Scale*Size*Size,Scale*Size*Size);
    fill(0);
    for(int i=0;i<(Size*Size);i++){
       if(i>0){
          fill(0);
          if(i%Size==0){
            strokeWeight(5);
          }else{
            strokeWeight(3);
          }
          
          line(100,100+i*Scale,100+Scale*Size*Size,100+i*Scale);
          line(100+(i)*Scale,100,100+(i)*Scale,100+Scale*Size*Size);
       }
       for(int j=0;j<(Size*Size);j++){
         strokeWeight(3);
          if(InitGrid[i][j]>=0){
            fill(220);
            rect(j*Scale+100,i*Scale+100,Scale,Scale);
          }
       }
    }
  }
  void Draw(){
    fill(0);
    textSize(32*Scale/60);
    for(int i=0;i<(Size*Size);i++){
      for(int j=0;j<(Size*Size);j++){
        if(Grid[i][j]>=0){
          text(Grid[i][j],j*Scale+100+15,i*Scale+100+45*Scale/60);
        }
      }
    }
  }
  
}
String ArrToString(int[] arr){
  String str="";
  for(int i=0;i<arr.length;i++){
   str+=arr[i]; 
   str+=",";
  }
  return str;
}