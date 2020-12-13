k=720;
X=Y=cx=xy=closeX=closeY=d=e=c=0.0;
s=100.;
t=0.;
def setup():
    size(720,720);
    colorMode(HSB);
    
def draw():
    global t,s,o,X,Y,closeX,closeY;
    t+=1./k;
    cx=cos(t);
    cy=sin(t);
    s+=10;
    loadPixels();
    d=9;
    for y in range(k):
        for x in range(k):
            o=X+(x-k/2)/s;
            p=Y+(y-k/2)/s;
            v=complex(o,p);
            count=0;
            while(abs(v)<2 and count<30):
                v=v*v+complex(cx,cy);
                count+=1;
                
            if count>10:
                e=dist(X,Y,o,p);
                if(e<d):
                    d=e;
                    closeX=o;
                    closeY=p;
            pixels[y*720+x]=color(count*10,k,k);
    updatePixels();
    X=closeX;
    Y=closeY;
    
