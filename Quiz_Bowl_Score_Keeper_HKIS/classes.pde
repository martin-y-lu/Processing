public class Player{
  int score;
  String name;
  int negs = 0;
  int powers = 0;
  int regulartossups = 0;
  
  Player(String name){
    this.name = name;
  }
  
  public void scoreUpdate(int val){
    
    score += val;
  } 
  
  public String name(){
    return this.name;
  }
  
  public int score(){
    return this.score;
  }
  
  public int powers(){
    return this.powers;
  }
  
  public int negs(){
    return this.negs;
  }
  
  public int reg(){
    return this.regulartossups;
  }
  
  public void answer(String type){
    if(type.equals("reg")){
      scoreUpdate(10);
      regulartossups++;
    }
    else if(type.equals("neg")){
      scoreUpdate(-5);
      negs++;
    }
    else if(type.equals("power")){
      scoreUpdate(15);
      powers++;
    }
  }
}
