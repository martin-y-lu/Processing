class LatticeSystem{
  ArrayList<LatticePoint> latticePoints= new ArrayList<LatticePoint>();
  ArrayList<LatticeWalker> latticeWalkers= new ArrayList<LatticeWalker>();
  
  ArrayList<ObjectGenerator> objectGenerators= new ArrayList<ObjectGenerator>();
  LatticeWalker walkerOrigin;
  
  LatticeSystem(){
    generateLatticePoints(2);
    walkerOrigin= new LatticeWalker(this);
    walkerOrigin.directionOffset=0;
      walkerOrigin.basePoint=getLatticePoint(new LatticeCoord(new int[0]));
      walkerOrigin.absolutePosition=new PolarTransform();
      walkerOrigin.renderPosition=walkerOrigin.absolutePosition.copy();
      latticeWalkers= new ArrayList<LatticeWalker>();
      latticeWalkers.add(walkerOrigin);
      generateLatticeWalkers(5);
    //latticeWalkers.add(walkerOrigin);
    //generateLatticeWalkers(5);
    //generateLatticeWalker(new LatticeCoord(new int[]{0,0}));
    //setViewOrigin(new LatticeCoord(new int[]{0}),new PolarTransform(0,0.2,0.3));
  }
  void setViewOrigin(LatticeCoord coord,PolarTransform transform){
    if(walkerOrigin.basePoint.coords.compareTo(coord)==0){
       //just recalculate positions; 
       for(LatticeWalker w: latticeWalkers){
         w.validPositions=false;
       }
       
       walkerOrigin.absolutePosition=transform.copy();
       walkerOrigin.renderPosition=walkerOrigin.absolutePosition.copy();
       walkerOrigin.validPositions=true;
       //validateWalkerPositions(latticeWalkers.get(latticeWalkers.size()-1));
       for(LatticeWalker w: latticeWalkers){
         validateWalkerPositions(w);
       }
    }else{
      //regenerate walkers
      walkerOrigin.directionOffset=0;
      walkerOrigin.basePoint=getLatticePoint(coord);
      walkerOrigin.basePoint.attachedWalker=walkerOrigin;
      walkerOrigin.absolutePosition=transform.copy();
      walkerOrigin.renderPosition=walkerOrigin.absolutePosition.copy();
      latticeWalkers= new ArrayList<LatticeWalker>();
      latticeWalkers.add(walkerOrigin);
      generateLatticeWalkers(4);
    }
  }
  void setViewOrigin(LatticeTransform transform){
    setViewOrigin(transform.basePoint.coords,transform.relativeTransform);
  }
  
  void generateLatticePoints(int radius){// Generate and validate all lattice points with a tree of a specified radius
    LatticeCircularIterator iter= new LatticeCircularIterator(radius);
    while(iter.hasNext()){
        //////printlnTempTemp(iter.thisCoord);
        generateLatticePoint(iter.thisCoord);
        iter.next();
    }
    
  }
  LatticePoint generateLatticePoint(LatticeCoord coord){// Generate the latticepoint at a given Coordinate, also generates all the latticepoints below it in the tree (so that it is connected)
    if(coord.type!= LatticeType.INVALID){
      int index=findViablePointIndex(coord);
      ////printlnTempTemp("viable index for "+coord.toString()+" : "+index); 
      if(latticePoints.size()>0){
        try{
          //prin  tln("INDEX  "+index+"   "+latticePoints.get(index).coord+"  "+coord+"  "+latticePoints.get(index).coord.equals(coord));
          if(latticePoints.get(index).compareTo(coord)==0){
            //pri  ntln("lattice already in array");
            return latticePoints.get(index);
          }
        }catch(Exception e){};
      }
      
      LatticePoint L= new LatticePoint(coord,this);
      index=findViablePointIndex(coord);
      latticePoints.add(index,L);
      return L;
    }
    return null;
  }
  LatticePoint getLatticePoint(LatticeCoord coord){// Get the latticePoint at a specified lattice coordinate. Uses a binarysearch. creates a new one if doesn't exist
    int index= findViablePointIndex(coord);
    LatticePoint L;
    if(index>=latticePoints.size()){
      L=generateLatticePoint(coord);
    }else{
      if(latticePoints.get(index).coords.compareTo(coord)==0){
        L=latticePoints.get(index);
      }else{
         L=generateLatticePoint(coord);
      }
    }
    
    if(L.coords.compareTo(coord)==0){
      return L;
    }
    return null;
  }
  LatticePoint getLatticePointIfExists(LatticeCoord coord){//Get the latticePoint 
    int index= findViablePointIndex(coord);
    if(index>=latticePoints.size()){
      return null;
    }else{
      if(latticePoints.get(index).coords.compareTo(coord)==0){
        return latticePoints.get(index);
      }
    }
    return null;
  }
  int findViablePointIndex(LatticeCoord coord){// Finds the index where a latticepoint of a given coord should be placed. If the latticepoint with the given coord exists, it gives the index of it. BINARY SEARCHw
    if(coord.type==LatticeType.INVALID){
      println("INVALID LATTICECOORD"+ coord.toString());
       return -1; 
    }
    int minIndex=0;
    int maxIndex=latticePoints.size()-1;
    if(maxIndex<0){
      return 0; 
    }
    int compareToMinIndex=latticePoints.get(minIndex).compareTo(coord);
    int compareToMaxIndex=latticePoints.get(maxIndex).compareTo(coord);
    while(true){
      if(compareToMinIndex>=0){
         //If the minimum index is the same or greater than the searched coord, return minindex
         //Because if coord==minindex, we would want to return minindex
         //If coord < minindex, we would want to give the index to insert the coord, which is still minindex.
         return minIndex;
      }
      if(compareToMaxIndex==0){
         // If coord== maxIndex, we would want to return the index maxindex;
         return maxIndex;
      }
       if(compareToMaxIndex<0){
         //If coord>maxindex, we would want to gice the index just after maxinde
         return maxIndex+1;
      }
      if(maxIndex-minIndex==1){
         return maxIndex; 
      }
      int midIndex= (minIndex+maxIndex)/2;
      int compareToMidPoint= latticePoints.get(midIndex).compareTo(coord);
      if(compareToMidPoint<0){
         minIndex=midIndex;
         compareToMinIndex= compareToMidPoint;
      }else{
         maxIndex=midIndex;
         compareToMaxIndex= compareToMidPoint;
      }
    }
  }
  void generateLatticeWalkers(int radius){// Generate and validate all lattice points with a tree of a specified radius
    LatticeCircularIterator iter= new LatticeCircularIterator(radius);
    while(iter.hasNext()){
        ////printlnTemp(iter.thisCoord);
        generateLatticeWalker(iter.thisCoord);
        iter.next();
    }
    
  }
  LatticeWalker generateLatticeWalker(LatticeCoord coord){// Generate the latticewalker at a given Coordinate (walkerOrigin relatice), also generates all the latticeWalkers below it in the tree (so that it is connected)
    if(coord.type!= LatticeType.INVALID){
      int index=findViableWalkerIndex(coord);
      //printlnTemp("viable index for "+coord.toString()+" : "+index); 
      if(latticePoints.size()>0){
        try{
          //prin  tln("INDEX  "+index+"   "+latticePoints.get(index).coord+"  "+coord+"  "+latticePoints.get(index).coord.equals(coord));
          if(latticeWalkers.get(index).compareTo(coord)==0){
            //pri  ntln("lattice already in array");
            return latticeWalkers.get(index);
          }
        }catch(Exception e){};
      }
      
      LatticeWalker W= new LatticeWalker(coord,this);
      if(coord.type!= LatticeType.ORIGIN){
        LatticeWalker parent= generateLatticeWalker(coord.coordInDirection(0));
        
        //printlnTemp("parent:"+coord.coordInDirection(0).toString()+" "+parent.basePoint);
        W.absolutePosition=W.relativeOrientationParent.copy();
        W.absolutePosition.preApplyPolarTransform(parent.absolutePosition);
        W.basePoint=getLatticePoint(parent.basePoint.coords.coordInDirection(parent.directionOffset+coord.directionOfLeaf()));
        W.basePoint.attachedWalker=W;
        W.directionOffset=parent.basePoint.coords.directionAfterTravel(parent.directionOffset+coord.directionOfLeaf());
        //L.absolutePosition.preApplyPolarTransform(parent.absolutePosition);
        W.renderPosition=W.absolutePosition.copy();
        W.renderPosition.applyRotation(-W.directionOffset*TWO_PI/5);
      }
      W.validPositions=true;
      index=findViableWalkerIndex(coord);
      latticeWalkers.add(index,W);
      return W;
    }
    return null;
  }
  void validateWalkerPositions(LatticeWalker walker){
    if(!walker.validPositions){
      //println("validationg:"+walker);
      LatticeWalker parent= generateLatticeWalker(walker.coordOriginRelative.coordInDirection(0));
      if(parent.coordOriginRelative.type!=LatticeType.ORIGIN){
        validateWalkerPositions(parent);

      }
      if(parent==walkerOrigin){
          //println("down to origin");
      }
      
      walker.absolutePosition=parent.absolutePosition.copy();
      
      //println(parent.absolutePosition);
      //printMatrix(parent.absolutePosition);
      walker.absolutePosition.applyPolarTransform(walker.relativeOrientationParent);
      walker.renderPosition=walker.absolutePosition.copy();
      walker.renderPosition.applyRotation(-walker.directionOffset*TWO_PI/5);
      //println(walker.renderPosition);
      walker.validPositions=true;
    }
  }
  LatticeWalker getLatticeWalker(LatticeCoord coord){// Get the latticeWalker at a specified lattice coordinate. Uses a binarysearch
    int index= findViableWalkerIndex(coord);
    LatticeWalker W;
    W=latticeWalkers.get(index);
    //if(index>=latticeWalkers.size()){
    //  L=generateLatticePoint(coord);
    //}else{
    //  if(latticePoints.get(index).coords.compareTo(coord)==0){
    //    L=latticePoints.get(index);
    //  }else{
    //     L=generateLatticePoint(coord);
    //  }
    //}
    
    if(W.coordOriginRelative.compareTo(coord)==0){
      return W;
    }
    return null;
  }
  int findViableWalkerIndex(LatticeCoord coord){// Finds the index where a latticepoint of a given coord should be placed. If the latticepoint with the given coord exists, it gives the index of it
    if(coord.type==LatticeType.INVALID){
       return -1; 
    }
    int minIndex=0;
    int maxIndex=latticeWalkers.size()-1;
    if(maxIndex<0){
      return 0; 
    }
    int compareToMinIndex=latticeWalkers.get(minIndex).compareTo(coord);
    int compareToMaxIndex=latticeWalkers.get(maxIndex).compareTo(coord);
    while(true){
      if(compareToMinIndex>=0){
         //If the minimum index is the same or greater than the searched coord, return minindex
         //Because if coord==minindex, we would want to return minindex
         //If coord < minindex, we would want to give the index to insert the coord, which is still minindex.
         return minIndex;
      }
      if(compareToMaxIndex==0){
         // If coord== maxIndex, we would want to return the index maxindex;
         return maxIndex;
      }
       if(compareToMaxIndex<0){
         //If coord>maxindex, we would want to gice the index just after maxinde
         return maxIndex+1;
      }
      if(maxIndex-minIndex==1){
         return maxIndex; 
      }
      int midIndex= (minIndex+maxIndex)/2;
      int compareToMidPoint= latticeWalkers.get(midIndex).compareTo(coord);
      if(compareToMidPoint<0){
         minIndex=midIndex;
         compareToMinIndex= compareToMidPoint;
      }else{
         maxIndex=midIndex;
         compareToMaxIndex= compareToMidPoint;
      }
    }
  }
  void update(){
    //int prevGenerators=objectGenerators
    for(int i=0;i<objectGenerators.size();i++){
      objectGenerators.get(i).generateObjects();
      objectGenerators.get(i).update();
    }
    for(LatticePoint latticePoint:latticePoints){
      latticePoint.update(); 
    }
  }
  String toString(){
    String s="lSystem{"; 
    for(int i=0;i<latticePoints.size();i++){
       s+=latticePoints.get(i).toString();
       if(i<latticePoints.size()-1){
         s+=",";
       }
    }
    s+="}\n{ ";
     for(int i=0;i<latticeWalkers.size();i++){
       s+=latticeWalkers.get(i).toString();
       if(i<latticeWalkers.size()-1){
         s+=",";
       }
    }
    s+="}";
    return s;
  }
  
}
