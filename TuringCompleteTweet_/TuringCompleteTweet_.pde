//import org.mariuszgromada.math.mxparser.*;
//char[]D=new char[30*30];
//String[]Lines;
//int c,r,d,e,f;
//void setup(){
//  size(600,600);
//  Lines=loadStrings("D.txt");
//  frameRate(0.5);
//  //D[0]='A';

//  //print(c);
//  for(int i=0;i<30*30;i++){
//    D[i]=Lines[i].charAt(0);
//  }
//  ////saveStrings("D.txt", list);
//}
//void draw(){
//  clear();
//  fill(255);
//  e=D[r]/4-65;
//  switch(D[r]%4){
//    case 0:
//      println("Increment data");
//      D[d]=char(D[d]+e);
//      r++;
//      break;
//    case 1:
//      println("Increment data pointer");
//      d+=e;
//      r++;
//      break;
//    case 2:
//      println("Set data pointer");
//      d=e;
//      r++;
//      break;
//    case 3:
//      println("Jump code pointer if data is zero");
//      if(D[d]/4==65){
//        r=e;
//      }
//      break;
//  }
//  println("Data:"+d+"  Code:"+r);
//  for(int i=0;i<30;i++){
//    for(int j=0; j<30;j++){
//      text(char(D[i*30+j]/4),j*20,i*20+40); 
//    }
//  }
//}
//int i,j,r,d,n=65;char[]D=new char[n*n];
//void setup(){
//  size(600,600);
//  String[]l=loadStrings("D.txt");
//  for(i=0;i<n*n;i++){
//    D[i]=l[i].charAt(0);
//    }
//  }
//void draw(){
//  clear();
//  i=D[r]/4-n;
//  j=D[r]%4;
//  if(j==0){D[d]=char(D[d]+i);r++;}
//  if(j==1){d+=i;r++;}
//  if(j==2&&D[d]/4==n){r=i;}
//  for(i=0;i<n;i++){
//    for(j=0; j<n;j++){
//      text(char(D[i*n+j]/4),j*9,i*9+n); 
//    }
//  }
//}
int i,j,r,d,n=65;char[]D;
String temp="";
String[] DataStore= new String[65*65];

String CoordString(int point){
 return "<"+(point%65)+","+floor(point/65)+">"; 
}
//char incd(int n){
//  return char((65+n*4)*4);
//}
//char incp(int n){
//  return char((65+n)*4+1);
//}
//char jumc(int n){
//  return char((65+n)*4+2);
//}
//char com(int n){
//  return char(n*4+3);
//}
//char num(int n){
//  return char((n+65)*4+3);
//}
int framerate=5;



int k=0;


ArrayList<Bubble> Bubbles= new ArrayList<Bubble>();

void setup(){
  //frameRate(2);
  size(1280 ,720,P2D);
  D=new char[65*65];
  for(int x=0;x<65*65;x++){
    D[x]=char(65*4+3);
  }
  
 
  setD(l,new Command[]{sp(64),id(1),ja(65*11)});
  l=65*11;
  //TESTING
  //Jum(19*65+4);
  int writingtextSTART=l;
  Write(65,"Turing````");
  Write(65*2,"Complete``");
  Write(65*3,"Tweet`````");
  Write(65*4,"Calculates");
  Write(65*5,"````~φ````");
  Write(65*6,"The`golden");
  Write(65*7,"``ratio````");
  Write(65*8,"__________");
  Write(65*9,"`made`in`");
  Write(65*10,"Processing");
  int writingtextEND=l;
  Bubbles.add(new Bubble(writingtextSTART,writingtextEND-1,"Writing the text: Turing Complete Tweet Calculates ...",color(100,100,200,200)));
  Jum(65*14+15);
  
  //Clear all of that text
  int writingkeySTART=l=65*14+15;
  OverWrite(65,"A=AB|B=A|φ");
  int writingkeyEND=l;
  Bubbles.add(new Bubble(writingkeySTART,writingkeyEND-1,"Writing the key: A=AB|B=A|φ",color(100,100,200,200)));
  
  int A_loc= 5;
  int B_loc= 10;
  int Line_loc=15;
  
  //Init the A, B line vars
  int initvalSTART=l;
  Inc(A_loc,1);
  Inc(B_loc,1);
  Inc(Line_loc,65*2);
  int initvalEND=l;
  Bubbles.add(new Bubble(initvalSTART,initvalEND-1,"Init A,B, and line",color(100,100,200,200)));
  
  int Main_loop_start_line=17;
  Jum(65*Main_loop_start_line);
  //main loop
  l=65*Main_loop_start_line;
  
  
  int clearSTART=l;
  //Clear the line, initialise with 00/00=0000
  Add(Line_loc,Line_loc+1,Line_loc+2);//Copysave lineloc into line_loc+2
  Add(Line_loc+1,Line_loc);

  int LineCounter_loc=20;//Set counter to 10
  Set(LineCounter_loc,10);
  
  int ClearStart=18*65+5; 
  Add(Line_loc+2,Line_loc+3,ClearStart,ClearStart+2);
  
  l=ClearStart;
  app(new Command[]{sp(0),id(-1),sp(0),jr(-6),id(-10),id(-7)});// clear, sp(0)'s replaced with val at line_loc;, set to - 17 (0 char); split - 10  - 7
  Inc(ClearStart,1);
  Inc(ClearStart+2,1);
  app(new Command[]{sp(LineCounter_loc),id(-1),ja(ClearStart)});
  Clear(ClearStart);
  Clear(ClearStart+2);
  int clearEND=l;
   Bubbles.add(new Bubble(clearSTART,clearEND-1,"Clear current lines, replace with 0",color(100,100,200,200)));
  //After clear
  
  int AddSpacers= 19*65;
  
  int addspacersSTART=l;
  Add(Line_loc+3,AddSpacers,AddSpacers+2);
  Inc(AddSpacers,2);
  Inc(AddSpacers+2,5);
  l= AddSpacers;
  app(new Command[]{sp(0),id(-1),sp(0),id(13)});//From zero , make / and = 
  Clear(AddSpacers);
  Clear(AddSpacers+2);
  int addspacersEND=l;
  Bubbles.add(new Bubble(addspacersSTART,addspacersEND-1,"Add the / and = spacers in the line",color(100,100,200,200)));
  //spacers added
  
  //Adding the decimal expansion
 // integer decimaliser TWO DIGIT OBLY
  int  integerDecimaliser_function_line=32;
  int number_loc=10+65*5+2;
  int number_val=34;
  int out_loc=10+65*5+20;
  int out_add=65*2+1;
  int term_loc=(integerDecimaliser_function_line+1)*65+42;//fill  later
  int term_address=l+1;
  
  //add decimal printout for A
  int adecimalprintSTART=l;
  Add(A_loc,A_loc+1,number_loc);
  Add(A_loc+1,A_loc);
  Add(Line_loc,Line_loc+1,Line_loc+2);
  Add(Line_loc+1,Line_loc);
  Inc(Line_loc+2,1);
  Add(Line_loc+2,out_loc);
  Set(term_loc,22*65);//20&65+35 
  Jum(integerDecimaliser_function_line*65);// REWUEST THE PRINTOUT
  int adecimalprintEND=l;
  Bubbles.add(new Bubble(adecimalprintSTART,adecimalprintEND-1,"Load the Integer Decimaliser function to print A in line",color(100,100,200,200)));
  l=22*65;
  
  //add decimal printout for B
  int bdecimalprintSTART=l;
  Add(B_loc,B_loc+1,number_loc);
  Add(B_loc+1,B_loc);
  Add(Line_loc,Line_loc+1,Line_loc+2);
  Add(Line_loc+1,Line_loc);
  Inc(Line_loc+2,4);
  Add(Line_loc+2,out_loc);
  Set(term_loc,24*65);//20&65+35
  Jum(integerDecimaliser_function_line*65);// REWUEST THE PRINTOUT
  int bdecimalprintEND=l;
  Bubbles.add(new Bubble(bdecimalprintSTART,bdecimalprintEND-1,"Load the Integer Decimaliser function to print B in line",color(100,100,200,200)));
  
    //Rational decimaliser: Takes two integers (numerator, denominator) as long as numerator is less than 10*denominator, and finds the rational decimal expansion 
  
  int rationalDecimaliser_function_line=35;
  int numer_loc=10+65*2;
  int denom_loc=10+65*2+2;
  int numer_store=10+65*3;
  int denom_store=10+65*3+20;
  
  int didgcount_loc= 10+65*2+5;
  int ones_loc= 65*2+6;
  
  //int numer_val=10;
  //int denom_val=10;
  int numer_val=34;
  int denom_val=21;
  int numdidg=4;
  int PositiveBranch= (2+rationalDecimaliser_function_line)*65;
  int NegativeBranch=(3+rationalDecimaliser_function_line)*65;
  
  int terminate_loc=(4+rationalDecimaliser_function_line)*65;
  int terminate_address=(5+rationalDecimaliser_function_line)*65+6;
  int jumpafter=26*65;
  
  //add decimal printout for A/B
  l=24*65;
  
  int ratioprintSTART=l;
  Add(A_loc,A_loc+1,numer_loc);
  Add(A_loc+1,A_loc);
  Add(B_loc,B_loc+1,denom_loc);
  Add(B_loc+1,B_loc);
  Inc(didgcount_loc,numdidg);
  Set(terminate_address,jumpafter);//20&65+35
  Add(Line_loc,Line_loc+1,Line_loc+2);
  Add(Line_loc+1,Line_loc);
  Inc(Line_loc+2,6);
  Add(Line_loc+2,PositiveBranch);
  
  //Inc(numer_loc,numer_val);
  //Inc(denom_loc,denom_val);
  //Inc(didgcount_loc,numdidg);
  //Set(terminate_address,jumpafter);
  //Inc(PositiveBranch,ones_loc);
  Jum(65*rationalDecimaliser_function_line);
  int ratioprintEND=l;
  Bubbles.add(new Bubble(ratioprintSTART,ratioprintEND-1,"Load the Rational Decimaliser function to print A/B in line",color(100,100,200,200)));
  
  l=jumpafter;
  
  int shiftvaluesSTART=l;
  //Copy A once, Add B to A, and move A to B.
  Add(A_loc,A_loc+1,A_loc+2);
  Add(A_loc+1,A_loc);
  Add(B_loc,A_loc);
  Add(A_loc+2,B_loc);
  Inc(Line_loc,65);
  //Halt();
  Jum(Main_loop_start_line*65);
  int shiftvaluesEND=l;
  Bubbles.add(new Bubble(shiftvaluesSTART,shiftvaluesEND-1,"Copy A once, Add B to A, and move A to B. Shift line down. Return to start of loop",color(100,100,200,200)));
  
  
  
  
  
 
  ///  INTEGER DECIMALIZER  IMPLEMENTATION
  int integerdecimaliserSTART=l=integerDecimaliser_function_line*65;
  Inc(out_loc,-1);
  int devisorStart=(integerDecimaliser_function_line)*65+50;
  Clear(devisorStart+2);
  Clear(devisorStart+6);
  Add(out_loc,out_loc+1,devisorStart+2,devisorStart+6);
  l=devisorStart;
  app(new Command[]{sp(number_loc),id(-10),sp(0),id(1),sp(number_loc),jr(1),sp(0),id(-1),sp(number_loc),id(10)});//Finds the number devisor by 10// replace all sp(0)'s with sp out_loc-1
  
  Inc(out_loc+1,1);
  int remainder_start=(integerDecimaliser_function_line+1)*65+25;
  Clear(remainder_start+2);
  Add(out_loc+1,remainder_start+2);
  l=remainder_start;
  app(new Command[]{sp(number_loc),id(-1),sp(0),id(1),sp(number_loc),jr(1)});//replace all sp(0)'s with out_loc;
    //Clear(number_loc);
  Clear(out_loc);
  Jum(0);//replace with term_adress
  int integerdecimaliserEND=l;
  Bubbles.add(new Bubble(integerdecimaliserSTART,integerdecimaliserEND-1,"Integer Decmialiser function: writes the decimal of the value at the pointer in "+CoordString(number_loc),color(100,100,200,200)));
  
  
  
  
  
  

  
  
  //setD(l,new Command[]{new sp(numer_loc),new id(233),new sp(denom_loc),new id(144),new sp(64),new ja(65*14)});
  
  //setup decimaliser
  //NOTE =, when initializing, clear data at terminate_address, since it isn't automatically done, before assigning value (just replace)
  //INIT
  
  //l=65*20;
  
  
  //setD(l,new Command[]{new sp(numer_loc),new id(-16),new sp(numer_loc+1),new id(16),new sp(numer_loc),new jr(1),new id(1),new jr(7+6),new sp(numer_loc+1),new id(-1),new sp(numer_loc),new sp(64),new jr(4),new id(-1)});//EFFICENT Transferer
  
  //EFFICENT copyer

  int rationaldecimaliserStart=l=65*rationalDecimaliser_function_line;
  Add(numer_loc,numer_loc+1,numer_store);
  Add(numer_loc+1,numer_loc);
  int SubtractLoop=l;
  
  
  Add(numer_store,numer_store+1,numer_store+2);
  Add(numer_store+1,numer_store);
  Add(denom_loc,denom_loc+1,denom_store);
  Add(denom_loc+1,denom_loc);
  
  SubJump(denom_store,numer_store,PositiveBranch,NegativeBranch);
  
  //Positive Branch 
  l=PositiveBranch;
  app(new Command[]{sp(0),id(1)});//the sp(0) to be replaced with ones loc
  Clear(denom_store);
  Clear(numer_store+2);
  Jum(SubtractLoop);
  
  //Negative Branch;
  l=NegativeBranch;
  app(new Command[]{sp(didgcount_loc),id(-1),jr(5),sp(64),ja(terminate_loc),sp(PositiveBranch),id(1)});// shift place
  Clear(numer_store);
  AddMult(numer_store+2,10,numer_store);
  Clear(denom_store);
  Jum(SubtractLoop);
  
  l= terminate_loc;
  Clear(numer_loc);
  Clear(numer_store);
  Clear(numer_store+2);
  Clear(denom_loc);
  Clear(denom_store);
  Clear(didgcount_loc);
  Clear(PositiveBranch);
  
  Jum(0);//replace with jumpafter
  int rationaldecimaliserEND=l;
  Bubbles.add(new Bubble(rationaldecimaliserStart,rationaldecimaliserEND-1,"Rational Decimaliser function:",color(100,100,200,200)));
  
 
  //D[65*5+9]=com('0');
  //temp+=char((65+11)*4+1);//increment data pointer by 11
  //temp+=char((65-1)*4+1);//decrement data pointer by 1
  //temp+=char((65+4)*4+0);//increment data 1
  //temp+=char((65+1)*4+1);//increment data pointer by 1
  //temp+=char((65+600)*4+1);//if zero (which it is), set read pointer to 1
  //String temp="";
  //for(int x=0;x<65*65;x++){
  //  temp+=char(D[x]);
  //}
  //saveStrings("D.txt",new String[]{temp});
  //print(temp);
  //size(600,600);
  //D=loadStrings("D.txt")[0].toCharArray();
}
