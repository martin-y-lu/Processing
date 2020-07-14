abstract class LatticeObject{
  // Abstract class for any object existing on the hyperbolic plane
   LatticeSystem system;
   ObjectGenerator generator;
   private LatticeTransform position;
   LatticeObject(LatticeTransform dPos, ObjectGenerator dGenerator,boolean addToSystem){
     generator=dGenerator;
     system= dGenerator.system;
     position= dPos;
     position.resolveBasePointContravariant();
     if(addToSystem){
       addToSystem();
     }
   }
   void addToSystem(){
     position.basePoint.attachedObjects.add(this);
   }
   LatticeTransform getPosition(){
     return position.copy();  
   }
   public void resolveBasePointContravariant(){
     LatticePoint prevPoint= position.basePoint;
     position.resolveBasePointContravariant();
      if(position.basePoint.compareTo(prevPoint)!=0){
       prevPoint.attachedObjects.remove(this);
       position.basePoint.attachedObjects.add(this);
     }
   }
   
   //public void transformPosition(PolarTransform transform){
   //  LatticePoint prevPoint= position.basePoint;
   //  position.applyPolarTransform(transform);
   //  if(position.basePoint.compareTo(prevPoint)!=0){
   //    prevPoint.attachedObjects.remove(this);
   //    position.basePoint.attachedObjects.add(this);
   //  }
   //}
 
   abstract void draw(PolarTransform positionFromCamera,PGraphics graphic);
   abstract void update();
}
abstract class ObjectGenerator{
  LatticeSystem system;
  ArrayList<LatticeObject> objects= new ArrayList<LatticeObject>();
  ObjectGenerator(LatticeSystem dSystem){
    system= dSystem; 
  }
  abstract void generateObjects();
  void addObject(LatticeObject object){
    //object.generator=this;
    objects.add(object);
  }
  abstract void update();
}

class LineObject extends LatticeObject{
  CurveGenerator generator;
  float lineLength;
  int lineColor= color(0,200,0); 
  float stroke=8;
  //LineObject(PolarTransform position, LatticeCoord coord,CurveGenerator dGenerator){
  //  super(position,coord,dGenerator);
  //  generator=dGenerator;
  //}
  LineObject(LatticeTransform dPosition ,CurveGenerator dGenerator,boolean addToSystem){
    super(dPosition,dGenerator,addToSystem);
    generator=dGenerator;
    lineLength=generator.edgeLength*0.97;
  }
  void draw(PolarTransform posFromCamera,PGraphics graphic){
     graphic.strokeWeight(stroke);
     graphic.stroke(lineColor);
     drawLine(posFromCamera.getMatrix(),lineLength,graphic);
     graphic.fill(0,150);
     if(keyPressed&&key=='c'){
       PVector screenPos=posFromCamera.posOnScreen();
       graphic.text(getPosition().basePoint.coords.toString(),screenPos.x,screenPos.y);
       //println(getPosition().basePoint.coords.toString());
     }
     //
  }
  void update(){
    //none
  }
}
static boolean ERRORLESS_GEN=true;
class CurveGenerator extends ObjectGenerator{
  LatticeTransform initialTransform;
  PolarTransform edgeTransform;
  PolarTransform offsetTransform;
  float edgeLength;
  float angle;
  float offset;
  
  float prevDistance=0;
  boolean circleClosing=false;
  boolean active=true;
  LineObject tail;
  LineObject head;
  
  int lineColor= color(0,200,0); 
  float stroke=8;
  
  boolean generatePerps=true;
  
  PolarTransform offsetHeadTransform;
  PolarTransform offsetTailTransform;
  
  CurveGenerator(LatticeTransform dInitialTransform ,float dEdgeLength,float dAngle,LatticeSystem dSystem){
    super(dSystem);
    head=new LineObject( dInitialTransform,this,true);
    addObject(head);
    
    tail=head;
    initialTransform=dInitialTransform;
    edgeLength=dEdgeLength;
    angle=dAngle;
    generatePerp(head.getPosition());
  }
  CurveGenerator(LatticeTransform dInitialTransform ,float dEdgeLength,float dAngle,float offset,boolean dPerps,LatticeSystem dSystem){
    super(dSystem);
    generatePerps=dPerps;
    edgeTransform=new PolarTransform(0,dEdgeLength,dAngle);
      if(abs(offset)<0.01f){
         initialTransform=dInitialTransform;
        edgeLength=dEdgeLength;
        angle=dAngle;
        head=new LineObject( dInitialTransform,this,true);
        addObject(head);
        
        tail=head;
       
        generatePerp(head.getPosition());
        
        offsetHeadTransform=edgeTransform.copy();
         offsetTailTransform=edgeTransform.inverse();
      }else{     
        //LatticeTransform newOrigin= dInitialTransform.copy();÷
        angle=dAngle;
        PolarTransform shifty= new PolarTransform((PI-angle)/2,offset,0);
        
        PolarTransform newEdgeTrans= shifty.inverse();
        newEdgeTrans.applyPolarTransform(new PolarTransform(0,dEdgeLength,dAngle));
        newEdgeTrans.applyPolarTransform(shifty); 
        shifty.applyPolarTransform(new PolarTransform(newEdgeTrans.n,0,0));
        
        initialTransform=dInitialTransform.copy();
        initialTransform.applyPolarTransformContravariant(shifty);
        //newOrigin.applyPolarTransformContravariant(shifty);
        
        //initialTransform=newOrigin;
        edgeLength=newEdgeTrans.s;
        angle=newEdgeTrans.n+newEdgeTrans.m;
        //angle=;
        //println("EDGELENGTH"+ edgeLength+" ioehfheoahioefhouaehfoieahfouhaeiofhoeiahfoiaehfioaeji"   );
        if(ERRORLESS_GEN){
          angle=dAngle;
          head=new LineObject( dInitialTransform.copy(),this,false);
          tail=head;
          
          LineObject OffsetHead=new LineObject( initialTransform,this,true);
          addObject(OffsetHead);
          offsetTransform= shifty;
           generatePerp(head.getPosition());
        }else{
          edgeTransform=new PolarTransform(0,edgeLength,angle);
          head=new LineObject( initialTransform,this,false);
          addObject(head);
          tail=head;
          offsetTransform= new PolarTransform(0,0,0);
           generatePerp(head.getPosition());
        }
        
        offsetHeadTransform=edgeTransform.copy();
        offsetHeadTransform.applyPolarTransform(offsetTransform);
        offsetTailTransform=edgeTransform.inverse();
        offsetTailTransform.applyPolarTransform(offsetTransform);
        
       
      }
  }
  void setColors(){
    for(LatticeObject O: objects){
        LineObject L= (LineObject)O;
       setLineDisplayInfo(L);
    }
  }
  CurveGenerator(LatticeTransform dInitialTransform ,float dEdgeLength,float dAngle,LatticeSystem dSystem,int dColor,float dStroke){
    super(dSystem);
    initialTransform=dInitialTransform;
    edgeLength=dEdgeLength;
    angle=dAngle;
    edgeTransform=new PolarTransform(0,dEdgeLength,dAngle);
    offsetTransform= new PolarTransform(0,0,0);
    
    offsetHeadTransform=edgeTransform.copy();
        offsetHeadTransform.applyPolarTransform(offsetTransform);
        offsetTailTransform=edgeTransform.inverse();
        offsetTailTransform.applyPolarTransform(offsetTransform);
    
    lineColor=dColor;
    stroke=dStroke;
    head=new LineObject( dInitialTransform,this,true);
    
    addObject(head);
    
    tail=head;
    
    
  }
  void generateObjects(){
    if(active){
      LatticeTransform newHeadPos= head.getPosition();
      boolean newHead=false;
      
      
      if(newHeadPos.tryApplyPolarTransformContravariant(offsetHeadTransform)){//Try resolving basepoint, only set newHead if the new basepoint exists;
        //println(newHead);
        newHead=true;
      }
      LatticeTransform newTailPos= tail.getPosition();
      boolean newTail=false;
      if(newTailPos.tryApplyPolarTransformContravariant(offsetTailTransform)){//Try resolving basepoint, only set newHead if the new basepoint exists;
        newTail=true;
        //println(newTail);

      }
      //println(head.getPosition()+" : "+tail.getPosition());
      if(newHead&&newTail){
        float newDist=newHeadPos.distanceToContravariant(newTailPos);
        //println(newDist);
        if(newDist<prevDistance){
          if(newDist<2*edgeLength){// ignore some weird error coming from large distscnes
             circleClosing=true;
             println("CIRCLE CLOSING!!!!!--- -!_!_!_!_-1-!_2ecknvoiSJeioj");
          }
        }else{
           if(circleClosing){
              active=false; 
           }
        }
        prevDistance=newDist;
      }
      if(active){
        if(newHead){
          LineObject newHeadObject=new LineObject(newHeadPos,this,true);
          setLineDisplayInfo(newHeadObject);
          //println(
          addObject(newHeadObject);
          generatePerp(newHeadPos);
          
          LatticeTransform headPos=head.getPosition();
          headPos.applyPolarTransformContravariant(edgeTransform);
          head=new LineObject(headPos,this,false);
          setLineDisplayInfo(head);
          
          //LatticeTransform testy= headPos.copy();
          //testy.applyPolarTransformContravariant(new PolarTransform((PI-angle)/2,0,0));
          //LineObject test=new LineObject(testy,this);
          //test.lineLength=3;
          //addObject(test);
          
        }
        if(newTail){
          LineObject newTailObject=new LineObject(newTailPos,this,true);
          setLineDisplayInfo(newTailObject);
          addObject(newTailObject);
          generatePerp(newTailPos);
          
          LatticeTransform tailPos=tail.getPosition();
          tailPos.applyPolarTransformContravariant(edgeTransform.inverse());
          tail=new LineObject(tailPos,this,false);
          setLineDisplayInfo(tail);
        }
      }
    } 
  }
  void generatePerp(LatticeTransform newOrigPos){
    if(generatePerps){
      LatticeTransform newOrigin=newOrigPos.copy();
      newOrigin.relativeTransform.applyRotation((PI-angle)/2);
      //newOrigin.resolveBasePointContravariant();
      CurveGenerator newGen= new CurveGenerator(newOrigin,1.4f,0,system,color(0,0,200,50),6);
      newGen.generatePerps=false;
      system.objectGenerators.add(newGen);
    }
  }
  @Override
  void addObject(LatticeObject O){
     if(O instanceof LineObject){
       LineObject L= (LineObject)O;
       setLineDisplayInfo(L);
       objects.add(L);
     }
  }
  void setLineDisplayInfo(LineObject L){
    
       L.lineColor=lineColor;
       L.stroke=stroke;
  }
  void update(){
    //println("num lines in curveGenerator:"+objects.size()); 
  }
}
