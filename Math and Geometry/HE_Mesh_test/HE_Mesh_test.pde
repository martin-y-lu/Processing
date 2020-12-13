import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import java.util.*;
import processing.opengl.*;

// HEMESH CLASSES & OBJECTS
HE_Mesh MESH; // Our mesh object
WB_Render RENDER; // Our render object
HE_Selection SELECTION;
PGraphics heightmap;
PImage depthmap;
 
// CAM
import peasy.*;
PeasyCam CAM;
 
/////////////////////////// SETUP ////////////////////////////
 
void setup() {
  size(800, 600, OPENGL);
  CAM = new PeasyCam(this, 200);  
 
  // OUR CREATOR
  HEC_Cube creator = new HEC_Cube(); 
 
  //CREATOR PARMAMETERS
  creator.setEdge(70); // edge length in pixels
  creator.setWidthSegments(4).setHeightSegments(4).setDepthSegments(4); // keep these small
  //creator.setCenter(0, 0, 0).setZAxis(1, 1, 1).setZAngle(PI/4);
  MESH = new HE_Mesh(creator); // add our creator object to our mesh object
 
  //DEFINE A SELECTION
  SELECTION = new HE_Selection( MESH );  
 
  //ADD FACES TO SELECTION
  Iterator<HE_Face> fItr = MESH.fItr(); 
  HE_Face f;
  for (int i= 0; i<16; i++) {
    f = fItr.next();
    SELECTION.add(f);
 
    HEM_Extrude extrude = new HEM_Extrude().setDistance(i);
    //MESH.modifySelected( extrude, SELECTION)
    SELECTION.subtract(SELECTION);
  }
 
  RENDER = new WB_Render(this); // RENDER object initialise
}
 
/////////////////////////// DRAW ////////////////////////////
void draw() {
  background(255);
  CAM.beginHUD(); // this method disables PeasyCam for the commands between beginHUD & endHUD
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  CAM.endHUD();
  stroke(0, 0, 255);
  strokeWeight(.5);
  RENDER.drawFaces( MESH ); // DRAW MESH FACES
  RENDER.drawEdges( MESH ); // DRAW MESH EDGES
}
 
void keyPressed() {
  if (key == 'e') {
    MESH.triangulate();
    HET_Export.saveToSTL(MESH, sketchPath("export.stl"), "test1233STL4");
  }
}
