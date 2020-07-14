k=720;s=t=100.;V=0;
def setup():
    size(720,720);colorMode(HSB);
def draw():
    global t,s,V;t+=1./k;C=complex(cos(t),sin(t));s+=10;d=9;loadPixels();
    for i in range(k*k):
        x=i%k;y=(i-x)//k;v=complex((x-k/2)/s,(y-k/2)/s)+V;w=v;n=0;e=abs(V-v);
        while abs(w)<2 and n<30:
            w=w*w+C;n+=1;
        if n>10 and e<d:
            d=e; W=v;
        pixels[y*720+x]=color(n*10,k,k);
    updatePixels();V=W;
