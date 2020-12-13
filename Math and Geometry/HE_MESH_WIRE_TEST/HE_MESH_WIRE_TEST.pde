
import wblut.nurbs.*;
import wblut.hemesh.*;
import wblut.core.*;
import wblut.geom.*;
import wblut.processing.*;
import wblut.math.*;



WB_Render render;
WB_BSpline C;
WB_Point[] points;

WB_BSpline C_2;
WB_Point[] points_2;
HE_Mesh mesh;

void setup() {
  size(1000,1000,P3D);
  smooth(8);
  // Several WB_Curve classes are in development. HEC_SweepTube provides
  // a way of generating meshes from them.

  //Generate a BSpline
  points=new WB_Point[11];
  for (int i=0;i<11;i++) {
    points[i]=new WB_Point(5*(i-5)*(i-5), -200+40*i, random(100));
  }
  C=new WB_BSpline(points, 4);
  points_2=new WB_Point[11];
  for (int i=0;i<11;i++) {
    points_2[i]=new WB_Point(5*(i-5)*(i-5), -200+40*i, random(100));
  }
 
  C_2=new WB_BSpline(points_2, 4);

  HEC_SweepTube creator=new HEC_SweepTube();
  creator.setCurve(C);//curve should be a WB_BSpline
  creator.setRadius(20);
  creator.setSteps(100);
  creator.setFacets(8);
  creator.setCap(true, true); // Cap start, cap end?
  HEC_SweepTube creator_2=new HEC_SweepTube();
  creator_2.setCurve(C_2);//curve should be a WB_BSpline
  creator_2.setRadius(20);
  creator_2.setSteps(40);
  creator_2.setFacets(8);
  creator_2.setCap(true, true); // Cap start, cap end?
  
  HEC_Sphere end= new HEC_Sphere();
  end.setRadius(30);
  end.setCenter(points[0]);

  mesh=new HE_Mesh(creator);
  mesh.add(new HE_Mesh(creator_2));
  mesh.add(new HE_Mesh(end));
  HET_Diagnosis.validate(mesh);
  render=new WB_Render(this);
}

void draw() {
  background(55);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(width/2,height/2);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  stroke(0);
  render.drawEdges(mesh);
  noStroke();
  render.drawFaces(mesh);
}

//void keyPressed() {
//  if (key == 'e') {
//    mesh.triangulate();
//    HET_Export.saveToSTL(mesh, sketchPath("export.stl"), "test1233STL4");
//  }
//}
