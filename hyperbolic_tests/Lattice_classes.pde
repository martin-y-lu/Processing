static float BRANCHLENGTH=1.255;
enum LatticeType {ORIGIN,BRANCH2,BRANCH3,INVALID};
class LatticeCoord implements Comparable{
  int[] coord;
  LatticeType type; //0- 2 branched, 1 - 3 branched
  LatticeCoord(int[] dCoord){
    coord= dCoord;
    type=findType();
  }
  int[] getCoord(){
    return coord; 
  }
  LatticeType findType(){
    if(coord.length==0){
        return LatticeType.ORIGIN; 
     }
     if(coord.length==1){
        return LatticeType.BRANCH3; 
     }
     if(coord.length>0){
        if(coord[0]>4){
          return LatticeType.INVALID; 
        }
        int prev=1;
        for(int i=1;i<coord.length;i++){
          if(prev==0&&coord[i]>1){
            return LatticeType.INVALID; 
          }
          if(prev>0&&coord[i]>2){
            return LatticeType.INVALID; 
          }
          prev=coord[i];
        }
     }
    
     
     if(coord[coord.length-1]==0){
       return LatticeType.BRANCH2;
     }    
     return LatticeType.BRANCH3;
  }
  
  int directionOfBranch(int branch){
    if(coord.length==0){
      return branch; 
    }
    boolean branch3=false;
    if(coord.length==1){
      branch3=true; 
    }else{
       if(coord[coord.length-1]!=0){
         branch3=true;
       }
    }
    if(branch3){
       return (branch+1);
    }else{
      return (branch+2);
    }
  }
  float angleOfLeaf(){
     return directionOfLeaf()*TWO_PI/5; 
  }
  int directionOfLeaf(){
    if(coord.length==0){
      return 0; 
    }
    if(coord.length==1){
      return coord[0];
    }
    boolean branch3=false;
    if(coord.length==2){
      branch3=true; 
    }else{
       if(coord[coord.length-2]!=0){
         branch3=true;
       }
    }
    if(branch3){
       return (coord[coord.length-1]+1);
    }else{
      return (coord[coord.length-1]+2);
    }
  }
  int directionAfterTravel(int direction){
    direction = direction%5;
    if(type==LatticeType.INVALID){
      return -1; 
    }
    if(type==LatticeType.ORIGIN){
      return 0; 
    }
    if(direction==0){
      return directionOfLeaf();
    }
    if(type== LatticeType.BRANCH2){
       switch(direction){
         case 1:
           return 4;
         case 2:
           return 0;
         case 3:
           return 0;
         case 4:
           return 1;
       }
    }
    if(type== LatticeType.BRANCH3){
       switch(direction){
         case 1:
           return 0;
         case 2:
           return 0;
         case 3:
           return 0;
         case 4:
           return 1;
       }
    }
    return -1;
  }
  int coordTypeDebug(){
    int[] coordT;
    if(type==LatticeType.INVALID){
      return 0; 
    }
    if(type==LatticeType.ORIGIN){
      return 1;
    }
    //printlnTemp("BRANCHTYPE="+type);
    if(type== LatticeType.BRANCH2){
           coordT=removeLastElement(coord);
           int index= coordT.length-1;
           while(coordT[index]==0&&index>0){
             index--;
           }
           boolean Branch2Rooted=true;
           if(index>=1){
             if(coordT[index]>1){
                Branch2Rooted=false; 
                //println("this shit");
             }
           }
           
           if(Branch2Rooted){
             return 3;
           }else{
             return 2;
           }

    }
    if(type== LatticeType.BRANCH3){
           if(coord.length==1){
             return 4;
           }
           if(coord[coord.length-1]==2){
             return 5;
           }
           if(coord[coord.length-1]==1){
             return 6;
           }
       }
    return 0;
  }
  LatticeCoord coordInDirection(int direction){
    direction = direction%5;
    int[] coordT;
    if(type==LatticeType.INVALID){
      return null; 
    }
    if(type==LatticeType.ORIGIN){
      return new LatticeCoord(new int[]{direction});
    }
    if(direction==0){
      return new LatticeCoord(removeLastElement(coord));
    }
    //printlnTemp("BRANCHTYPE="+type);
    if(type== LatticeType.BRANCH2){
       switch(direction){
         case 1:
           coordT=removeLastElement(coord);
           int index= coordT.length-1;
           while(coordT[index]==0&&index>0){
             index--;
           }
           boolean Branch2Rooted=false;
           if(index>=1){
             if(coordT[index]>1){
                Branch2Rooted=true; 
             }
           }        
           if(index==0){
             Branch2Rooted=true; 
           }
           coordT[index]=(coordT[index]-1+5)%5;
           index+=1;
           if(index<coordT.length){
             if(Branch2Rooted){
               coordT[index]=2;
             }else{
               coordT[index]=1;
             }
             
             index++;
             while(index<coordT.length){
               coordT[index]=2;
               index++;
             }
           }
           return new LatticeCoord(coordT);
         case 2:
           return new LatticeCoord(appendElement(coord,0));
         case 3:
           return new LatticeCoord(appendElement(coord,1));
         case 4:
           coordT= appendElement(coord,0);
           coordT[coordT.length-2]=1;
           return new LatticeCoord(coordT);
       }
    }
    if(type== LatticeType.BRANCH3){
       
       switch(direction){
         case 1:
           return new LatticeCoord(appendElement(coord,0));
         case 2:
           return new LatticeCoord(appendElement(coord,1));
         case 3:
           return new LatticeCoord(appendElement(coord,2));
         case 4:
           if(coord.length==1){
             return new LatticeCoord(new int[]{(coord[0]+1)%5,0}); 
           }
           coordT= appendElement(coord,2);
           int index=coordT.length-1;
           while(coordT[index]==2&&index>0){
             coordT[index]=0;
             index--;
           }
           if(index==0||coordT[index-1]!=0){
             coordT[index]= (coordT[index]+1)%5;
             return new LatticeCoord(coordT);
           }
           coordT[index-1]=1;
           coordT[index]=0;
           return new LatticeCoord(coordT);
       }
    }
    return null;
  }
  
  public int compareTo(Object OBJ){
    LatticeCoord C;
    if(OBJ instanceof LatticeCoord){
       C= (LatticeCoord)OBJ;
    }else if(OBJ instanceof LatticePoint){
      C= ((LatticePoint)OBJ).coords; 
    }else{
       return 2;// IDK, it isnt a latticecoord or lattice point 
    }
    
    if(coord.length>C.coord.length){
      return 1;
    }
    if(coord.length<C.coord.length){
      return -1;
    }
    for(int i = 0; i<coord.length ;i++){
       if(coord[i]<C.coord[i]){
          return -1; 
       }else if(coord[i]>C.coord[i]){
          return 1; 
       }
    }
    return 0;
  }
  LatticeCoord copy(){
    return new LatticeCoord(copyArray(coord)); 
  }
  
  public String toString(){
    String s="<";
    for(int i=0;i<coord.length;i++){
      s+=coord[i];
      if(i!=coord.length-1){
        s+=",";
      }
    }
    s+=">";
    return s;
  }
}


class LatticeCircularIterator{
   int radius;
   private boolean first;
   public LatticeCoord thisCoord;
   LatticeCircularIterator(int dRadius){
       radius=dRadius;
       //thisCoord=dCoord;
       thisCoord=firstCoord();
       first= true;
   }
  boolean hasNext(){
     if(first){
        return true; 
     }
      for(int i=0;i<thisCoord.getCoord().length;i++){
        if(thisCoord.getCoord()[i]!=0){
          return true; 
        }
      }
      return false;
   }
   LatticeCoord firstCoord(){
     int[] coord= new int[radius];
     for(int i=0;i<coord.length;i++){
       coord[i]=0;
     }
     return new LatticeCoord(coord);
   }
   LatticeCoord nextCoord(){
     int[] newCoord= copyArray(thisCoord.coord);
     for(int i=newCoord.length-1;i>1;i--){
       if(newCoord[i-1]==0){
          //BRANCH2
          if(newCoord[i]<1){
            newCoord[i]++;
            return new LatticeCoord(newCoord);
          }
           newCoord[i]=0;
       }else{
          //BRANCH3 
          if(newCoord[i]<2){
            newCoord[i]++;
            return new LatticeCoord(newCoord);
          }
           newCoord[i]=0;
       }
     }
       //BRANCH3 
     int i=1;
      if(newCoord[i]<2){
        newCoord[i]++;
        return new LatticeCoord(newCoord);
      }
      //ORIGIN
       newCoord[i]=0;
       newCoord[0]=(newCoord[0]+1+5)%5;
       return new LatticeCoord(newCoord);
   }
   LatticeCoord next(){
      first=false;
      thisCoord=nextCoord();
      return thisCoord;
   }
}

class LatticePoint implements Comparable{//Represents a point in the order 5 square lattice

  //Latticepoints must be constructed by the LatticeSystem overhead object, to make sure it is setup properly.
  LatticeSystem system;
  LatticeCoord coords;
  LatticeWalker attachedWalker;
  ArrayList<LatticeObject> attachedObjects= new ArrayList<LatticeObject>();
  LatticePoint( LatticeCoord dCoord, LatticeSystem dSystem){
    coords=dCoord; 
    system= dSystem;
    //relativeOrientation=new PolarTransform(coords.angleOfLeaf(),BRANCHLENGTH,PI);
    //absolutePosition= new PolarTransform();
    //neighborPoints=new LatticePoint[5];
    
  }
  //LatticePoint getBranch(int branchNumber){
  //  if(coords.type==LatticeType.BRANCH2){
  //    return neighborPoints[branchNumber+2];
  //  }else if(coords.type==LatticeType.BRANCH3){
  //    return neighborPoints[branchNumber+1];
  //  }
  //  return neighborPoints[branchNumber];
  //}
  int compareTo(Object OBJ){
     return  coords.compareTo(OBJ);
  }
  String toString(){
    return coords.toString();
  }  
  void renderPoint(PolarTransform Ptransform, PGraphics graphic){
     PMatrix3D transform=Ptransform.getMatrix();
     if(coords.type!=LatticeType.ORIGIN){
       //if(keyPressed&&(key=='c'||key=='t')){
          int alpha=255;
          graphic.strokeWeight(3);
          graphic.stroke(255,10,0,alpha);
          drawLine(transform,BRANCHLENGTH,graphic);
          if(coords.type==LatticeType.BRANCH2){
            graphic.stroke(255,200,0,100*alpha/255);
            drawLine(transform,BRANCHLENGTH,TWO_PI/5,graphic);
            
          }
          PVector screenPos= Ptransform.posOnScreen();
          int debugtype= coords.coordTypeDebug();
          //println(debugtype);
          //graphic.fill(0);
          switch(debugtype){
             case 2:
               graphic.fill(10,250,20);
               break;
             case 3:
               graphic.fill(250,10,20);
               break;
             case 4:
               graphic.fill(0,0,250);
               break;
             case 5:
               graphic.fill(100,0,250);
               break;
             case 6:
               graphic.fill(0,200,250);
               break;
          }
          graphic.noStroke();
          float screenPosLength= new PVector((screenPos.x/Scale)-1f,(screenPos.y/Scale)-1f).mag();
          //println(screenPosLength);
          graphic.circle(screenPos.x,screenPos.y,20f*(1.5f-screenPosLength));
       //}
      }
      for(LatticeObject attachedObject:attachedObjects){
         PolarTransform attachedTrans=Ptransform.copy();
         attachedTrans.applyPolarTransform(attachedObject.position.relativeTransform);
         attachedObject.draw(attachedTrans,graphic); 
      }
  }
  void renderPoint3D(PMatrix3D transform){
     strokeWeight(4);
     if(coords.type!=LatticeType.ORIGIN){
        stroke(255,10,0);
        drawLine3D(transform,BRANCHLENGTH);
        if(coords.type==LatticeType.BRANCH2){
          stroke(255,200,0);
          drawLine3D(transform,BRANCHLENGTH,TWO_PI/5);
        }
      } 
  }
  void update(){
     for(LatticeObject attachedObject:attachedObjects){
       attachedObject.update(); 
     }
  }
}
class LatticeWalker implements Comparable{
  LatticeSystem system;
  LatticeCoord coordOriginRelative;
   LatticePoint basePoint;
   boolean validPositions=false;
   //PMatrix3D absolutePosition;
   //PMatrix3D renderPosition;
   //PMatrix3D relativeOrientationParent;
   PolarTransform absolutePosition;
   PolarTransform renderPosition;
   PolarTransform relativeOrientationParent;
   int directionOffset;// points to the parent latticeWalker
   LatticeWalker(LatticeCoord dCoordRel, LatticeSystem dSystem){
     coordOriginRelative=dCoordRel;
     relativeOrientationParent=new PolarTransform(coordOriginRelative.angleOfLeaf(),BRANCHLENGTH,PI);
     //FIND ABSOLUTE COORD
     system=dSystem;
     //basePoint= dBasePoint;
     //directionOffset=dOffset;
     
   }
   LatticeWalker(LatticeSystem dSystem){
     system= dSystem;
     coordOriginRelative=new LatticeCoord(new int[0]);
     basePoint= system.getLatticePoint(new LatticeCoord(new int[]{}));
     basePoint.attachedWalker=this;
     //printlnTemp(basePoint);
     directionOffset=0;
     absolutePosition=new PolarTransform(0,0.2,0.3);
     relativeOrientationParent=new PolarTransform();
     renderPosition=absolutePosition.copy();
   }
   
   int compareTo(Object OBJ){
     return  coordOriginRelative.compareTo(OBJ);
   }  
   String toString(){
    return "{"+coordOriginRelative.toString()+","+ directionOffset+"="+basePoint.toString()+"}";
     //return coordOriginRelative.toString();
  }  
}
