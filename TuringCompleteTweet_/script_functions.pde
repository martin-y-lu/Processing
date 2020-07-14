// functions:
// Unconditional jump, but set data pointer to 64
void Inc(int point,int val){
  int START=l;
  app(new Command[]{sp(point),id(val)});
  int END=l;
  Bubbles.add(new Bubble(START,END-1,"+"+val));
}
void Set(int point,int val){
   int START=l;
   Clear(point);
   Inc(point,val);
   int END=l;
   Bubbles.add(new Bubble(START,END-1,"Set "+CoordString(point)+" to "+val));
}
void Jum(int jum2){
  int START=l;
  app(new Command[]{sp(64),ja(jum2)});
  Bubbles.add(new Bubble(START,START+1,"Jmp"));
}

void Write(int point,String text){
  for(int count=0;count<text.length();count++){
    Inc(point+count,int(text.charAt(count))-65);
  }
}
void OverWrite(int point,String text){
  for(int count=0;count<text.length();count++){
    Set(point+count,int(text.charAt(count))-65);
  }
}

// Add a value input value to the value at two other adresses, clears the value of the first adress.
// REQUIRE: input_p != out_p_1 != out_p_2
void Clear(int input_p){
  int START=l;
  app(new Command[]{sp(input_p),id(-16),sp(input_p),jr(1)});// Subtract 16 untill negative
  app(new Command[]{sp(input_p),id(1),jr(-1),sp(64),jr(0),id(-1)});// Add 1 untill positive
  int END= l;
  Bubbles.add(new Bubble(START,END-1,"Clear "+CoordString(input_p),color(150,100,100,200)));
}
void SlowClear(int input_p){
  app(new Command[]{sp(input_p),id(-1),sp(input_p),jr(1)});// Subtract 16 untill negative
}

void Add(int input_p,int out_p_1){
  int START=l;
  app(new Command[]{sp(input_p),id(-16),sp(out_p_1),id(16),sp(input_p),jr(1)});// Subtract 16 untill negative
  app(new Command[]{sp(input_p),id(1),jr(-1),sp(out_p_1),id(-1),sp(64),jr(0),id(-1)});// Add 1 untill positive
  int END= l;
  Bubbles.add(new Bubble(START,END-1,"Add "+CoordString(input_p)+" to "+CoordString(out_p_1),color(150,0,0,200)));
}
void AddMult(int input_p,int mult,int out_p_1){// Adds input times a number (less than 16);
  app(new Command[]{sp(input_p),id(-16),sp(out_p_1),id(16*mult),sp(input_p),jr(1)});// Subtract 16 untill negative
  app(new Command[]{sp(input_p),id(1),jr(-1),sp(out_p_1),id(-mult),sp(64),jr(0),id(-1)});// Add 1 untill positive
}
void Add(int input_p,int out_p_1,int out_p_2){
    //EFFICENT copyer
  int START=l;
  app(new Command[]{sp(input_p),id(-16),sp(out_p_1),id(16),sp(out_p_2),id(16),sp(input_p),jr(1)});// Subtract 16 untill negative
  app(new Command[]{sp(input_p),id(1),jr(-1),sp(out_p_1),id(-1),sp(out_p_2),id(-1),sp(64),jr(0),id(-1)});// Add 1 untill positive
  int END= l;
  Bubbles.add(new Bubble(START,END-1,"Add "+CoordString(input_p)+" to "+CoordString(out_p_1)+" and "+CoordString(out_p_2),color(200,0,0,200)));
  
}
void Add(int input_p,int out_p_1,int out_p_2,int out_p_3){
  int START=l;
    //EFFICENT copyer
  app(new Command[]{sp(input_p),id(-16),sp(out_p_1),id(16),sp(out_p_2),id(16),sp(out_p_3),id(16),sp(input_p),jr(1)});// Subtract 16 untill negative
  app(new Command[]{sp(input_p),id(1),jr(-1),sp(out_p_1),id(-1),sp(out_p_2),id(-1),sp(out_p_3),id(-1),sp(64),jr(0),id(-1)});// Add 1 untill positive
  int END= l;
  Bubbles.add(new Bubble(START,END-1,"Add "+CoordString(input_p)+" to "+CoordString(out_p_1)+" , "+CoordString(out_p_2)+" and "+CoordString(out_p_3) ,color(240,0,0,200)));
}
void SubJump(int sub_p, int add_p,int pos_p,int neg_p){//zero positive
  int START=l;
  app(new Command[]{sp(sub_p),id(-16),sp(add_p),id(-16),jr(-2),sp(sub_p),ja(neg_p),sp(64),jr(-2),sp(sub_p),jr(1)});// Subtract 16 untill negative
  int MID1= l;
  Bubbles.add(new Bubble(START,MID1-1,"Subtract 16 untill negative"));
  app(new Command[]{sp(sub_p),id(1),jr(7),sp(add_p),id(1),sp(64),jr(0),sp(add_p),id(1)});
  int MID2= l;
  Bubbles.add(new Bubble(MID1,MID2-1,"Add 1 untill zero"));
  app(new Command[]{jr(-3),id(-1),sp(64),ja(neg_p),id(-1),sp(64),ja(pos_p)});
  int END = l;
  Bubbles.add(new Bubble(MID2,END-1,"Jump accordingly"));
  Bubbles.add(new Bubble(START,END-1,"Subtract "+CoordString(sub_p)+" from "+CoordString(add_p)+", jump to "+CoordString(pos_p)+" if positive, else"+CoordString(neg_p)));
  
  
}
//void SubJump(int sub_p, int add_p,int pos_p,int neg_p){//zero negative
//  app(new Command[]{sp(sub_p),id(-16),sp(add_p),id(-16),jr(-2),sp(sub_p),ja(neg_p),sp(64),jr(-2),sp(sub_p),jr(1)});// Subtract 16 untill negative
//  app(new Command[]{sp(sub_p),id(1),jr(7),sp(add_p),id(1),sp(64),jr(0),id(-1),ja(pos_p),sp(64),ja(neg_p)});
//}
void Halt(){
  app(new Command[]{sp(64),ja(65*65)});
}
