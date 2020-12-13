class LogicGrid implements Comparable{
  Boolean[][][]PossGrid;
  int Size;
  int Square;
  int Cost;
  LogicGrid(){
  }
  LogicGrid(int[][] IGrid){
    Size=IGrid.length;
    Square=int(sqrt(IGrid.length));
    PossGrid=new Boolean[Size][Size][Size];
    FillGrid(IGrid);
    EvalCost();
  } 
  LogicGrid(Boolean[][][] IGrid){
    Size=IGrid.length;
    Square=int(sqrt(IGrid.length));
    PossGrid=new Boolean[Size][Size][Size];
    PossGrid=CloneGrid(IGrid);
    EvalCost();
  }
  Boolean[][][] CloneGrid(Boolean[][][]oldGrid){
    Boolean[][][] newGrid= new Boolean[Size][Size][Size];
    for(int i=0;i<Size;i++){
      for(int j=0;j<Size;j++){
        arrayCopy(oldGrid[i][j],newGrid[i][j]);
      }
    }
    return newGrid;
  }
  LogicGrid Clone(){
      return new LogicGrid(PossGrid);
  }
  Boolean SameGrid(LogicGrid TGrid){
    if(Cost!=TGrid.GetCost()){
     return false; 
    }
    for(int i=0; i<Size;i++){
      for(int j=0; j<Size;j++){
         for(int k=0;k<Size;k++){
           if(PossGrid[i][j][k]!=TGrid.PossGrid[i][j][k]){
            return false; 
           }
         }
      }
    }
    return true;
  }
  void FillGrid(int[][] IGrid){
    for(int i=0;i<Size;i++){
      
       for(int j=0;j<Size;j++){
          if(IGrid[i][j]>0){
            PossGrid[i][j]=AllFalse(Size);
            PossGrid[i][j][IGrid[i][j]-1]=true;
            
          }else{
            PossGrid[i][j]=AllTrue(Size);
          }
       }
    }
  }
  Boolean RemoveFromAll(int row, int col, int value){//True if ok, false if logical error.
    for(int i=0;i<Size;i++){
      if(NumTrue(PossGrid[row][i])>1){
        PossGrid[row][i][value]=false;
      }else if(i!=col){
        if(PossGrid[row][i][value]){
          return false;
        }
      }
    }
    for(int i=0;i<Size;i++){
      if(NumTrue(PossGrid[i][col])>1){
        PossGrid[i][col][value]=false;
      }else if(i!=row){
        if(PossGrid[i][col][value]){
          return false; 
        }
      }
    }
    int A= floor(row/Square);
    int B= floor(col/Square);
    for(int i=0;i<Square;i++){
      for(int j=0;j<Square;j++){
        if(NumTrue(PossGrid[i+A*Square][j+B*Square])>1){
          PossGrid[i+A*Square][j+B*Square][value]=false;
        }else if((row!=(i+A*Square))||(col!=(j+B*Square))){
          if(PossGrid[i+A*Square][j+B*Square][value]){
            return false;
          }
        }
      }
    }
    return true;
  }
  Boolean[][] Column(int num){
    Boolean[][] arr=new Boolean[Size][Size];
    for(int i=0;i<Size;i++){
      arr[i]=PossGrid[i][num];
    }
    return arr;
  }
  Boolean[][] Square(int A,int B){
    Boolean[][] arr=new Boolean[Size][Size];
    for(int i=0;i<Square;i++){
      for(int j=0;j<Square;j++){
        arr[j*Square+i]=PossGrid[i+A*Square][j+B*Square];
      }
    }
    return arr;
  }
  
  int EvalCost(){
    int cost=0;
    for(int i=0; i<Size;i++){
       for(int j=0; j<Size; j++){
          cost+= NumTrue(PossGrid[i][j])-1;
       }
    }  
    Cost=cost;
    return Cost;
  }
  int GetCost(){
   return Cost; 
  }
  int LogicStep(){// -1 logic error, 0 done, 1 solved;
    int prevCost=9999;
    while(EvalCost()!=prevCost){
      //if(java.util.Arrays.equals(PossGrid, PrevGrid)){print("EQUALS");}
      prevCost=GetCost();
      for(int i=0;i<Size;i++){
         for(int j=0;j<Size;j++){
           if(NumTrue(PossGrid[i][j])==1){
             int index=FirstTrue(PossGrid[i][j]);
             if(!RemoveFromAll(i,j,index)){
                //println("error"+frameCount);
                Cost=Integer.MAX_VALUE;
                return -1;
             }
             //WriteValue(j,i,index+1);
           }
         }
      }
    } 
    if(EvalCost()==0){
     return 1; 
    }
    return 0;
  }
  public int compareTo(Object L){
     return ((Integer)GetCost()).compareTo(((LogicGrid)L).GetCost()); 
  }
  ArrayList<LogicGrid> NextSteps(){
    ArrayList<LogicGrid> Next=new ArrayList<LogicGrid>();
    for(int i=0;i<Size;i++){
      for(int j=0;j<Size;j++){
         for(int k=0;k<Size;k++){
            if(PossGrid[i][j][k]&&(NumTrue(PossGrid[i][j])>1)){
                LogicGrid NewGrid=Clone();
                NewGrid.PossGrid[i][j]=AllFalse(Size);
                NewGrid.PossGrid[i][j][k]=true;
                if(NewGrid.LogicStep()!=-1){
                  Next.add(NewGrid);
                }
            }
         }
      }
    }
    
    //Sort from best to worst
    Collections.sort(Next);
    
    // Remove redundant
    for(int i=Next.size()-1;i>=1;i--){
      if(Next.get(i).SameGrid(Next.get(i-1))){
        Next.remove(i);
      }
    }
    return Next;
  }
  LogicGrid Solve(int depth,ArrayList<Integer>Index){//Null if no solution
     ArrayList<LogicGrid> Next=NextSteps();
     println("treeSize="+Next.size()+"   Cost:"+Cost+"   Depth:"+depth+ "  Index:"+Index);
     if(Next.size()==0){
      return null;// Base case 
     }
     if(Next.get(0).GetCost()==0){
       return Next.get(0);//Base case
     }
     int newInd=0;  
     Index.add(new Integer(newInd));
     while(Next.size()>0){
       Index.set(Index.size()-1,newInd);
       LogicGrid result= Next.get(0).Solve(depth+1,(ArrayList<Integer>)Index.clone());
       newInd++;
       if(result !=null){
         return result;
       }
       Next.remove(0);
       newInd++;
     }
     return null;
  }
}

class SudokuGame{
  int Size=9; //The size of grid (normally 9)
  int Square=3;
  int[][]InitGrid;
  int[][]Grid; // Grid of numbers ranging from 1 to Size^2, (Size^2,Size^2), -1 for empty
  LogicGrid LGrid;//Grid of the possibilities for each grid space.
  SudokuGame(int[][] dGrid){
     Size=dGrid.length;
     Square=int(sqrt(dGrid.length));
     InitGrid=CloneGrid(dGrid);
     Grid=CloneGrid(dGrid);
     LGrid=new LogicGrid(dGrid);
  }
  int[][] CloneGrid(int[][]oldGrid){
    int[][] newGrid= new int[Size][Size];
    for(int i=0;i<Size;i++){
      arrayCopy(oldGrid[i],newGrid[i]);
    }
    return newGrid;
  }
  boolean Playable(int X,int Y){
    return InitGrid[Y][X]==-1;
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
    int[] arr=new int[Size];
    for(int i=0;i<arr.length;i++){
      arr[i]=0;
    }
    for(int i=0;i<Square;i++){
      for(int j=0;j<Square;j++){
        arr[j*Square+i]=Grid[i+A*Square][j+B*Square];
      }
    }
    return arr;
  }
  
  boolean Solved(){
    boolean solved=true;
    for(int i=0;i<(Size);i++){
      if(!HasAllUnique(Grid[i])){
        solved=false;
      }
      if(!HasAllUnique(Column(i))){
        solved=false;
      }
    }
    for(int i=0;i<Square;i++){
      for(int j=0;j<Square;j++){
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
    return LGrid.GetCost();
    //int cost=0;
    //for(int i=0;i<(Size);i++){
    //  cost+=NumMissing(Grid[i]);
    //  cost+=NumMissing(Column(i));
    //}
    //for(int i=0;i<Square;i++){
    //  for(int j=0;j<Square;j++){
    //     cost+=NumMissing(Square(i,j));
    //  }
    //}
    //return cost;
  }
  void WriteValue(int X,int Y, int Value ){
    if((X>=0)&&(Y>=0)&&(X<Size)&&(Y<Size)){
      if((Value>=0)&&(Value<=Size)){
        if(InitGrid[Y][X]==-1){
              Grid[Y][X]=Value;
              if(Value==0){
                Grid[Y][X]=-1;
                LGrid.PossGrid[Y][X]=AllTrue(Size);
              }else{
                 LGrid.PossGrid[Y][X]=AllFalse(Size);
                 LGrid.PossGrid[Y][X][Value-1]=true;
              }
        }
      }
    }
  }
  void UpdateGrid(){
    for(int i=0; i<Size; i++){
      for(int j=0; j<Size; j++){
        if(NumTrue(LGrid.PossGrid[i][j])==1){
          WriteValue(j,i,FirstTrue(LGrid.PossGrid[i][j])+1);
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
  void Solve(){
    LGrid.LogicStep();
    if(LGrid.Cost!=0){
      LGrid=LGrid.Solve(1,new ArrayList<Integer>());
    }
    UpdateGrid();

  }
  void Deduce(){
    LGrid.LogicStep();
    UpdateGrid();
  }
  
  
  void DrawBG(){
    fill(240);
    strokeWeight(4);
    rect(100,100,Scale*Size,Scale*Size);
    fill(0);
    for(int i=0;i<(Size);i++){
       for(int j=0;j<(Size);j++){
         strokeWeight(0);
          if(InitGrid[i][j]>=0){
            fill(200);
            rect(j*Scale+100,i*Scale+100,Scale,Scale);
          }
          noStroke();
          fill(255,0,0,200);
          for(int a=0;a<Square;a++){
            for(int b=0;b<Square;b++){
              if(LGrid.PossGrid[i][j][a*Square+b]){
                rect(j*Scale+100+b*Scale/Square,i*Scale+100+a*Scale/Square,Scale/Square,Scale/Square); 
              }
            }
          }
          stroke(0);
       }  
    }
    for(int i=0;i<(Size);i++){
       if(i>0){
          fill(0);
          if(i%Square==0){
            strokeWeight(7);
          }else{
            strokeWeight(3);
          }
          
          line(100,100+i*Scale,100+Scale*Size,100+i*Scale);
          line(100+(i)*Scale,100,100+(i)*Scale,100+Scale*Size);
       }
       
    }
  }
  void Draw(){
    fill(0);
    textSize(32*Scale/60);
    for(int i=0;i<(Size);i++){
      for(int j=0;j<(Size);j++){
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
Boolean[] AllTrue(int Size){
   Boolean[] trues=new Boolean[Size];
   for(int i=0;i<Size;i++){
      trues[i]=true;   
   }
   return trues;
}
Boolean[] AllFalse(int Size){
   Boolean[] falses=new Boolean[Size];
   for(int i=0;i<Size;i++){
      falses[i]=false;  
   }
   return falses;
}
int NumTrue(Boolean[] arr){
  int num=0;
  for(int i=0;i<arr.length;i++){
    if(arr[i]){
     num++; 
    }
  }
  return num;
}
int FirstTrue(Boolean[] arr){
  for(int i=0;i<arr.length;i++){
    if(arr[i]){
     return i;
    }
  }
  return -1;
}