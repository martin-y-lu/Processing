/**
 * Bouncy Bubbles  
 * based on code from Keith Peters. 
 * haked by me
 * Multiple-object collision.
 */
 
 
int numBalls = 4;
float spring = 0.05;
float gravity = 0.03;
float friction = -0.9;
ArrayList<Ball> balls = new ArrayList<Ball>(numBalls);

void setup() {
  size(640, 360);
  for (int i = 0; i < numBalls; i++) {
    balls.add(new Ball(random(width), random(height), random(30, 70), i, balls));
  }
  noStroke();
  fill(255, 204);
}

void draw() {
  background(0);

  TieToMetaBall();
  DrawMetaSpace();
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    //ball.display();  
  }
  if(mousePressed){
    balls.get(balls.size()-1).diameter+=1.2;
  }
}

class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  ArrayList<Ball> others;
 
  Ball(float xin, float yin, float din, int idin, ArrayList<Ball> oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 
  
  void collide() {
    for (int i = id + 1; i < balls.size(); i++) {
      float dx = others.get(i).x - x;
      float dy = others.get(i).y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others.get(i).diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others.get(i).x) * spring;
        float ay = (targetY - others.get(i).y) * spring;
        vx -= ax;
        vy -= ay;
        others.get(i).vx += ax;
        others.get(i).vy += ay;
      }
    }   
  }
  
  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  void display() {
    ellipse(x, y, diameter, diameter);
  }
}
void TieToMetaBall(){
  MList=new ArrayList<MetaBall>(0);
  for(int i=0;i<balls.size();i++){
    Ball B=balls.get(i);
    MList.add(new MetaBall(new PVector(B.x,B.y),B.diameter/2));
  }
}
void mousePressed(){
  balls.add(new Ball(mouseX,mouseY,random(20, 40), balls.size(), balls));
}