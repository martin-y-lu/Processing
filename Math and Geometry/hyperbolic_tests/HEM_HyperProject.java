package wblut.hemesh;

import java.util.Iterator;

import wblut.geom.WB_GeometryOp;
import wblut.geom.WB_Line;
import wblut.geom.WB_Plane;
import wblut.geom.WB_Point;
import wblut.geom.WB_Vector;
import wblut.math.WB_Epsilon;
import java.lang.Math; 
/**
 * Stretch and compress a mesh. Determined by a ground plane, a stretch factor
 * and a compression factor. Most commonly, the ground plane normal is the
 * stretch direction.
 *
 * @author Frederik Vanhoutte (W:Blut)
 *
 */
public class HEM_HyperProject extends HEM_Modifier {
    WB_Vector unitDirection= new WB_Vector(0,0,1);
    double scale= 100;
    /**
     * Instantiates a new HEM_HyperProject.
     */
    public HEM_HyperProject setUnit(WB_Vector unit){
      unitDirection = unit;
      return this;
    }
     public HEM_HyperProject setScale(double sScale){
       scale=sScale;
      return this;
    }

    /*
     * (non-Javadoc)
     *
     * @see wblut.hemesh.modifiers.HEB_Modifier#modify(wblut.hemesh.HE_Mesh)
     */
    @Override
    protected HE_Mesh applySelf(final HE_Mesh mesh) {
        WB_Point p;
        final Iterator<HE_Vertex> vItr = mesh.vItr();
        HE_Vertex v;
        while (vItr.hasNext()) {
            v = vItr.next();  
            p = v.getPosition();
            p= transformOntoHalfSphere(p);
            //v.set(p);
            
        }
        return mesh;
    }
    public WB_Point transformOntoHalfSphere(WB_Point p){
      p.mulSelf(1/scale);
      double x= p.xd();
      double y= p.yd();
      double z= p.zd();
      double rad= Math.pow(x*x+y*y,0.5d);
      if(rad>WB_Epsilon.EPSILON*5){
        double new_rad= Math.pow( ( Math.pow(1d+4*rad*rad*z*z,0.5d) -1 )/2d,0.5);
        double new_z= Math.pow( (2d*rad*rad*z*z)/( Math.pow(1d+4*rad*rad*z*z,0.5d) -1)/2d,0.5);
        double thick= Math.pow( Math.pow(new_rad-rad,2)+Math.pow(new_z-z,2),0.5);
        boolean above= Math.pow(rad*rad+1,0.5)<z;
        
        double scale_proj= 2*(new_z+1)/(new_rad*new_rad+ Math.pow(new_z+1,2));
                
        new_rad= new_rad*scale_proj;
        new_z= new_z*scale_proj+scale_proj-1;
        
        x=x*new_rad/rad;
        y=y*new_rad/rad;
        
        thick*=0.1;
        if(rad>2){
          thick*=1.0/(rad-1);
        }
        double out_shift= above? 1+thick:1-thick;
        
        x*= out_shift;
        y*= out_shift;
        new_z*= out_shift;
        
        p.setX(x);
        p.setY(y);
        p.setZ(new_z);
      }else{
        p.setZ(1); 
      }
      
      
      p.mulSelf(scale);
      return p;
    }
    /*
     * (non-Javadoc)
     *
     * @see
     * wblut.hemesh.modifiers.HEB_Modifier#modifySelected(wblut.hemesh.HE_Mesh)
     */
    @Override
    protected HE_Mesh applySelf(final HE_Selection selection) {
        return selection.getParent();
    }
}
