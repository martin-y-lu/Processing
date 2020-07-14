int a,b,c,d,l=98;
int[][]S,D={{-1,0},{0,-1},{1,-1}};
void setup(){
  S=new int[99][l];
  while(a<l){
    S[a][0]=(int)random(3);
    a++;
  }
}
void draw(){
  for(a=1;a<l;a++)for(b=1;b<l;b++){
    stroke(S[a][b]*l);
    point(a,b);
    for(d=c=0;d<3;d++){
      c+=S[a+D[d][0]][b+D[d][1]];
    }
    S[a][b]=S[c][0];
  }
  saveFrame("VID14/IMG-######.png");
}
