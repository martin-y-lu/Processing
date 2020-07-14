float Scale=400;
float Scale3D=Scale;
//PolarTransform startTransform= new PolarTransform();
enum Projection{POINCARE,KLEIN,GANS};
public final Projection PROJECTION= Projection.POINCARE;

LatticeTransform startTransform;

LatticeSystem lSystem;
int directionShift=0;
LatticeCoord te=new LatticeCoord(new int[]{2,0,1,1,2,0,0});
LatticeTransform testLatticeTransform1;
LatticeTransform testLatticeTransform2;
CurveGenerator testCurveGen;
PGraphics discView;
void setup(){
  size(800,800,P3D);
  discView=createGraphics(800,800);
  
  
  lSystem= new LatticeSystem();
  startTransform= new LatticeTransform(new PolarTransform(),new LatticeCoord(new int[]{}),lSystem);
  
  LatticeCoord L= new LatticeCoord(new int[]{0,1});
  println(L.coordInDirection(4));
  
  //testLatticeTransform1= new LatticeTransform(new PolarTransform(0,0f,0f),new LatticeCoord(new int[]{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0}),lSystem);
  //testLatticeTransform2= new LatticeTransform(new PolarTransform(0,0f,0f),new LatticeCoord(new int[]{0}),lSystem);
  //println(testLatticeTransform1+" :"+testLatticeTransform2);
  //println(testLatticeTransform1.distanceTo(testLatticeTransform2));
  
  //for(int i=0;i<6;i++){
  //  lSystem.objectGenerators.add(new CurveGenerator(new LatticeTransform(new PolarTransform(0,-i*0.13,PI/2), new LatticeCoord(new int[]{}),lSystem),0.3f,i*0.13,lSystem));
  //}
  if(false){
    CurveGenerator line=new CurveGenerator(new LatticeTransform(new PolarTransform(0,0,0), new LatticeCoord(new int[]{}),lSystem),0.4f,0.39699, 0,true,lSystem);
    line.lineColor= color(255,20,20);
    line.setColors();
    lSystem.objectGenerators.add(line);
    for(float i=1;i<5;i+=1){
      //float i=2;
      lSystem.objectGenerators.add(new CurveGenerator(new LatticeTransform(new PolarTransform(0,0,0), new LatticeCoord(new int[]{}),lSystem),0.4f,0.39699,i,false,lSystem)); 
      //lSystem.objectGenerators.add(new CurveGenerator(new LatticeTransform(new PolarTransform(0,0,0), new LatticeCoord(new int[]{}),lSystem),0.4f,0.39699f,-i,false,lSystem)); 
    }
  }
  //lSystem.objectGenerators.add(new CurveGenerator(new LatticeTransform(new PolarTransform(0,0.15,PI/2), new LatticeCoord(new int[]{}),lSystem),0.4f,-0.1f,lSystem));
  //lSystem.objectGenerators.add(new CurveGenerator(new LatticeTransform(new PolarTransform(0,0.3,PI/2), new LatticeCoord(new int[]{}),lSystem),0.4f,-0.2f,lSystem,color(0,0,200),8));
  //lSystem.objectGenerators.add(new CurveGenerator(new LatticeTransform(new PolarTransform(0,0.45,PI/2), new LatticeCoord(new int[]{}),lSystem),0.4f,-0.3f,lSystem));
  //lSystem.objectGenerators.add(new CurveGenerator(new LatticeTransform(new PolarTransform(0,0.6,PI/2), new LatticeCoord(new int[]{}),lSystem),0.4f,-0.39699,lSystem,color(0,0,200),8));
  //lSystem.objectGenerators.add(new CurveGenerator(new LatticeTransform(new PolarTransform(0,0.75,PI/2), new LatticeCoord(new int[]{}),lSystem),0.4f,-0.5f,lSystem));
  //lSystem.objectGenerators.add(new CurveGenerator(new LatticeTransform(new PolarTransform(0,0.9,PI/2), new LatticeCoord(new int[]{}),lSystem),0.4f,-0.6f,lSystem,color(0,0,200),8));
  //lSystem.objectGenerators.add(testCurveGen);
  //println("COMPARE: "+testCoord1.compareTo(testCoord2));
  //            new Integer(1).compareTo(2));
  println("direction="+new LatticeCoord(new int[]{0,1,2,0,0,0}).coordInDirection(1));
  //println(testCoord1.toString()+":"+testCoord1.type);
  //testCoord2=testCoord1.CoordInTraversalDirection(4);
  //println(testCoord2.toString()+":"+testCoord2.type);
  //testCoord2=testCoord2.CoordInTraversalDirection(1);
  //println(testCoord2.toString()+":"+testCoord2.type);
  
  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{}));
  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{}));
  //lSystem.generateLatticePoints(6);
  
  
  //  lSystem.generateLatticePoint(new LatticeCoord(new int[]{2,1}));
  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{2,2}));
  //  lSystem.generateLatticePoint(new LatticeCoord(new int[]{0,0}));
  //    lSystem.generateLatticePoint(new LatticeCoord(new int[]{3,1}));
  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{3,2}));

  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{1,1}));
  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{1,2}));
  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{2,0}));

  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{4,0}));
  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{4,1}));
  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{4,2}));
  //    lSystem.generateLatticePoint(new LatticeCoord(new int[]{3,0}));

  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{0,1}));
  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{0,2}));
  //lSystem.generateLatticePoint(new LatticeCoord(new int[]{1,0}));

  println(lSystem.toString());
  println(lSystem.latticePoints.size());
  //lSystem.latticeWalkers= new ArrayList<LatticeWalker>();
  //lSystem.latticeWalkers.add(lSystem.walkerOrigin);
  //lSystem.generateLatticeWalkers(5);
}

void draw(){
   lSystem.update();
   
   discView.beginDraw();
   discView.background(0);
   discView.fill(255);
   discView.circle(Scale,Scale,Scale*2);
   //scale(Scale,Scale);
   //translate(1,1);
   discView.strokeWeight(3);
   
   
   lSystem.setViewOrigin(startTransform);
   startTransform.shiftToNearerBasePoint();
   if(keyPressed){
     if(keyCode==UP){
        startTransform.relativeTransform.preApplyTranslationZ(0.04);
     }else if(keyCode== DOWN){
       startTransform.relativeTransform.preApplyTranslationZ(-0.04);
     }else if(keyCode== RIGHT){
         startTransform.relativeTransform.preApplyRotation(-0.04);
     }else if(keyCode== LEFT){
       startTransform.relativeTransform.preApplyRotation(0.04);
     }
   }
   
   
   
  //if(mousePressed){
    for(LatticeWalker w:lSystem.latticeWalkers){
      w.basePoint.renderPoint(w.renderPosition,discView);
    }
    discView.textSize(20);
    discView.textAlign(CENTER, CENTER);
    for(LatticeWalker w:lSystem.latticeWalkers){
      PMatrix3D matrix=w.renderPosition.getMatrix();
        PVector P= new PVector(1,0,0);
         matrix.mult(P,P);
         P=projectOntoScreen(P);
         discView.fill(0,0,0,255*(5-w.coordOriginRelative.coord.length)/5);
         //println(P.x+"  "+P.y);
         //if(keyPressed&& key=='c'){
           discView.text(w.basePoint.coords.toString(),P.x,P.y);
         //}
    }
    //for(LatticePoint t:lSystem.latticePoints){
        
    //    PMatrix3D matrix=t.absolutePosition.getMatrix();
    //  PVector P= new PVector(1,0,0);
    //     matrix.mult(P,P);
    //     P=projectOntoScreen(P);
    //     fill(0,0,0,255*(5-t.coords.coord.length)/5);
    //     //println(P.x+"  "+P.y);
    //     text(t.coords.toString(),P.x,P.y);
    //     ////P=
    //}
    //lSystem.setViewOrigin(new LatticeCoord(new int[]{0,0,0}),startTransform);
    if(keyPressed){
       if(key=='w'){
         Scale3D*=1.02;
       }else if(key=='s'){
         Scale3D/=1.02;
       }
       if(Scale3D<10){
         Scale3D=10;
       }
       if(Scale3D>Scale){
         Scale3D=Scale;
       }
   }
   
   //println(Scale3D);


      LatticePoint testPoint= lSystem.getLatticePoint(te);
      //println(lSystem.getViableIndex(te));
    //try{
    //PMatrix3D matrix=testPoint.attachedWalker.renderPosition.getMatrix();
    ////matrix.apply(RotationMatrix());
    //discView.stroke(0,255,0);
    //  drawLine(matrix,0.5,directionShift*TWO_PI/5,discView);
    //  PVector P= new PVector(1,0,0);
    //     matrix.mult(P,P);
    //     P=projectOntoScreen(P);
    //     discView.stroke(255,0,0);
    //     discView.circle(P.x,P.y,20);
    //}catch( Exception e){
      
    //}
    discView.endDraw();
    background(0);
    
    float upShift=0;
    if(PROJECTION==Projection.KLEIN){
      upShift=Scale3D;
    }
    
    translate(0,0,-upShift);
    if(Scale3D>250){
      translate(width / 2, map(Scale3D,250,Scale,height *4/5-250*0.2,height/2));
      rotateX(map(Scale3D,250,Scale,0.45*PI,0));
      
    }else{
      translate(width / 2, height *4/5-Scale3D*0.2);
      rotateX(0.45*PI);
      
    }
    //println(2*float(mouseX)/width);
    
      
    
    noStroke();
    beginShape();
    texture(discView);
    
    float a=Scale3D;
    
    vertex(-a, -a, upShift, 0,   0);
    vertex( a, -a, upShift, Scale*2, 0);
    vertex(a,  a, upShift, Scale*2, Scale*2);
    vertex(-a,  a, upShift, 0,   Scale*2);
    endShape();
    stroke(200,200,255);
      line(0,0,-Scale3D,0,0,Scale3D);
    
    if(Scale3D<250){
      
      for(LatticeWalker w:lSystem.latticeWalkers){
        PMatrix3D matrix=w.renderPosition.getMatrix();
        w.basePoint.renderPoint3D(matrix);
      }
      try{
        PMatrix3D matrix=testPoint.attachedWalker.renderPosition.getMatrix();
         PVector p= new PVector(1,0,0);
         matrix.mult(p,p);
         stroke(0,255,0);
         line(0,0,upShift-Scale3D,p.y*Scale3D,p.z*Scale3D,p.x*Scale3D);
      }catch(Exception E){
        
      }
    }
    te= lSystem.walkerOrigin.basePoint.coords.copy();
    //image(discView,0,0);
}

float branchLength=1.255;
int Depth=5;


void mousePressed(){
   println(lSystem.latticePoints.size()); 
}
void keyPressed(){
  
  try{
        if(keyPressed){
          int numPressed=Integer.parseInt(key+"");
          if(numPressed>=0&&numPressed<5){
            println(Integer.parseInt(key+""));
            te=te.coordInDirection(numPressed);
            println(te);
          }
          if(numPressed==9){
            
          }
        }
      }catch(Exception e){
        
      }
      if(key=='u'){
        println("hey");
        //testCurveGen.generateObjects();
        lSystem.update();
      }
      
  //   if(keyCode==UP){
  //      //startTransform.preApplyTranslationZ(0.04);
  //      int newDirection=te.directionAfterTravel(directionShift);
  //      te=te.coordInDirection(directionShift);
  //      directionShift=newDirection;
  //   }else if(keyCode== DOWN){
  //     //startTransform.preApplyTranslationZ(-0.04);
  //     te=te.coordInDirection(0);
       
  //   }else if(keyCode== RIGHT){
  //       //startTransform.preApplyRotation(-0.04);
  //       directionShift++;
  //   }else if(keyCode== LEFT){
  //     //startTransform.preApplyRotation(0.04);
  //     directionShift--;
  //   }
  //   directionShift=(directionShift+5)%5;
  
}
