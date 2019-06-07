class object{
  PImage Image;
  float x,y,displayx,displayy;
  object(PImage dImage,float dx,float dy,float ddisplayx,float ddisplayy){
    Image= dImage; x=dx; y=dy; displayx=ddisplayx; displayy=ddisplayy;
  }
}
class person extends object{
  float Health;
  float TopHealth;
  float Damage;
  float Energy;
  int Agro=1; // 0 is normal   1 is TRIGGERED
  boolean alive=true;
  person(PImage dImage,float dx,float dy,float ddisplayx,float ddisplayy,float dHealth,float dTopHealth,float dDamage,float dEnergy){
    super(dImage,dx,dy,ddisplayx,ddisplayy);Health=dHealth; TopHealth=dTopHealth; Damage= dDamage; Energy=dEnergy;
  }
  void attack(person T){
    T.Health-=Damage;
  }
  int derection=2;
}
class player extends person{
  ArrayList<attack>Alist= new ArrayList <attack>();
  private HashMap<String, Method> methodMap = new HashMap<String, Method>();
  player(PImage dImage,float dx,float dy,float ddisplayx,float ddisplayy,float dHealth,float dTopHealth,float dDamage,float dEnergy){
    super(dImage,dx,dy,ddisplayx,ddisplayy,dHealth,dTopHealth,dDamage,dEnergy);
  }
}