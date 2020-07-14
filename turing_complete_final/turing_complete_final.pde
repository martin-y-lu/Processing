int i,j,r,d,n=65;char[]D;void setup(){D=loadStrings("D.txt")[0].toCharArray();}
void draw(){
  clear();
  for(int k=0;k<64;k++){
    i=D[r]/4-n;
    j=D[r]%4;
    if(j==0){D[d]=char(D[d]+i);}
    if(j==1){d=i;}
    r++;
    if(j==2&&D[d]/4>n){r=i;}
  }
  for(i=0;i<n;i++)for(j=0;j<n;j++){
    text(char(D[i*n+j]/4),j*10,i*10); 
  }
  saveFrame("render-######.png"); 
}
