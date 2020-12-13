import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;
HEM_HyperProject modifier;

void setup() {
  size(1000, 1000, P3D);
  createMesh();
  
  modifier=new HEM_HyperProject();
  modifier.setUnit(new WB_Vector(0,0,20));
  modifier.setScale(100);
  
  
  mesh.modify(modifier);
  
  render=new WB_Render(this);
}

void draw() {
  background(120);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(width/2,height/2);
  scale(2);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  fill(255);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
  //reconstruct mesh and modifier
  createMesh();
  //noStroke();
  //render.drawFaces(mesh);
  //stroke(0);
  //render.drawEdges(mesh);
  mesh.modify(modifier);
  
}


void createMesh(){
  HEC_Cylinder creator=new HEC_Cylinder();
  creator.setFacets(8).setSteps(1).setRadius(100).setHeight(40);
  creator.setCenter(0,0,100);
  mesh=new HE_Mesh(creator); 
  mesh.subdivide(new HES_CatmullClark(),3);
}
