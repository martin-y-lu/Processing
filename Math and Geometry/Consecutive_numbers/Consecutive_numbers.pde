class SquareAnimProcedure extends AnimProcedure{
  int c=1;
  int n=14;
  int sum;
  boolean known= true;
  PVector origin;
  PVector endPos;
  Squares squares_initial;
  SquareAnimProcedure(int _c,int _n,PVector _origin,PVector _endPos){
    c=_c;
    n=_n;
    sum=round(0.5*n*(n-1)+c*n);
    origin=_origin;
    endPos = _endPos;
  }
  
  public void draw(){
    if(squares_initial!=null){
       squares_initial.draw();
       //text("Hello",squares_initial.origin.x,squares_initial.origin.x);
       pushMatrix();
        resetMatrix();
        scale(3);

        
        
        if(known){
          textAlign(LEFT, TOP);
          text(sum+"=",40,25);
          textAlign(CENTER, TOP);
          String text="";
          for(int i=0;i<n;i++){
            text+=(c+i)+(i<n-1?"+":"");
          }
          text(text,15,40,100,100);
        }else{
          textAlign(LEFT, TOP);
         text(sum+"= 2*"+ round(sum/2),40,25); 
        }
        popMatrix();
    }
    
    
  }
  public void setup(){ 
    print("hello");
  
    //new int[][]{new int[]{0,1},new int[]{0,2},new int[]{0,3},new int[]{0,4}}
    squares_initial=new Squares(origin,0,0)._SetShapeSum(n,c);
    //add(new SquareLerpTransition(100,squares_initial)._Translate(vec(2,0))._Ease()._Spee d(0.05));
    if(n%2==0){
      print("Even case");
       evenCase();
    }else{
      print("Odd case");
       oddCase(); 
    }
    add(
      //new SquareModifyEvent(squares_initial)._XShift(0)._YShift(0),
      new SquareLerpTransition(100,squares_initial)._EndPos(endPos)._Ease(),
      new DelayTransition(10)
    );
  }
  void evenCase(){
     add(
        new AnimEvent(){
          public void occur(){
            println("Hello nurse"); 
            println(totalLength());
            println(numTransitions());
          }
        },
        new DelayTransition(10),
        new AnimProcedure(){
          int a;
          Squares squares_copy;
          Squares squares_split_diag;
          public void setup(){
            print("Setting up copy");
            a=n/2;
            squares_split_diag=nullSquare.clone();
            squares_copy=squares_initial.clone();
            add(
              new SquareModifyTransition(40,squares_copy)._XShift(2*a),
              new AnimEvent(){
                public void occur(){
                  sum*=2;
                  known= false;
                  squares_split_diag.set(squares_initial.split_diag(a));
                }
              },
              new SquareModifyTransition(40,squares_split_diag)._YShift(2*a)._Speed(0.05),
              new SquareModifyTransition(20,squares_split_diag)._XShift(n)._Speed(0.05),
              new SquareModifyTransition(40,squares_split_diag)._YShift(a)._Speed(0.05),
              new AnimEvent(){
                public void occur(){
                  squares_initial.set(squares_initial.merge(squares_copy).merge(squares_split_diag));;
                  //squares_initial.merge(squares_split_diag);
                  squares_split_diag.visible=false;
                  squares_copy.visible=false;
                }
              }
            );
            if(a-c>=0){
               add(
              //new DelayTransition(20),
              new AnimProcedure(){
                Squares squares_neg;
                public void setup(){
                  squares_neg=squares_initial.split_left(a-c);
                  add(
                    new SquareModifyTransition(60,squares_neg)._XShift(2*a-2*c+1)._EndAngle(PI)._Ease(),
                    new AnimEvent(){
                      public void occur(){
                        squares_initial.split_left(2*a-2*c+1);
                        squares_neg._Visible(false);
                      }
                    },
                    new SquareModifyTransition(60,squares_initial)._XShift(-(2*a-2*c+1))._Ease()
                  );
                }
                public void draw(){
                  squares_neg.draw();
                }
              }
            );
            }else{
                print("Procedure skipped"); 
            }
            add(
              //
              new AnimEvent(){
                public void occur(){
                  //squares_initial.set(squares_initial.merge(squares_copy));
                  int n_prime = 2*n;
                  int c_prime = c-a;
                  print("N prime:"+ n_prime);
                  if(c_prime<=0){
                    int n_2prime= n_prime+2*c_prime-1;
                    int c_2prime= 1-c_prime;
                    n_prime=n_2prime;
                    c_prime=c_2prime;
                  }
                  known=true;
                  n=n_prime;
                  c=c_prime;
                  squares_initial._SetShapeSum(n, c);
                  squares_initial.xShift=0;
                  squares_initial.yShift=0;
                }
              },
              new DelayTransition(1)
            );
          }
          public void draw(){
            if(squares_split_diag!=null){
               squares_split_diag.draw();
            }
            squares_copy.draw();
          }
          public void start(){
            super.start();
            print("Starting");
          }
        },
        new DelayTransition(1)
      ); 
  }
  void oddCase(){
    add(
      new DelayTransition(10),
      new AnimProcedure(){
        int a=(n-1)/2;//==2
        Squares squares_copy;
        public void setup(){
          print("Hello_1");
          squares_copy=squares_initial.clone();
          add(
            new SquareModifyTransition(40,squares_copy)._YShift((n+c+1))._Ease(),
            new AnimEvent(){
              public void occur(){
                sum*=2;
                known=false;
              }
            },
            new AnimProcedure(){
              Squares squares_top;
              public void setup(){
                print("Hello_2");
                squares_top=squares_initial.split_top(c+a);
                if(a>0){
                  add(
                    new SquareModifyEvent(squares_top)._XShift(a)._YShift(c+a),
                    new SquareModifyTransition(100,squares_top)._XShift(1-a)._EndAngle(PI)._Ease(),
                    new AnimEvent(){
                      public void occur(){
                        squares_initial._SetShapeRect(n,c+a);
                        squares_top._Visible(false);
                      }
                    },
                    new DelayTransition(10)
                  );
                }
              }
            public void draw(){
                squares_top.draw(); 
              }
            },
            new DelayTransition(10),
            new SquareModifyTransition(20,squares_copy)._YShift(c+a)._Ease(),
            new AnimEvent(){
              public void occur(){
                //squares_initial.set(squares_initial.merge(squares_copy));
                int n_prime = n;
                int c_prime = 2*c+a;
                known=true;
                n=n_prime;
                c=c_prime;
                squares_initial._SetShapeSum(n,c);
                squares_copy._Visible(false);
              }
            },
            new DelayTransition(10)
          );
        }
        public void draw(){
          squares_copy.draw();
        }
      }
      
    );
  }
};
AnimController animController;
//= new AnimProcedure(){
//      public void setup(){
//        add(new SquareAnimProcedure(2,6,PVadd(UPPER_LEFT,vec(1,-6))));
//      }
//      public void draw(){};
//    };
void setup(){
  size(1600,700);
  UPPER_LEFT=new PVector(-width/(SCALE*2),height/(SCALE*2));
  UPPER_RIGHT= new PVector(width/(SCALE*2),height/(SCALE*2));
  LOWER_LEFT= new PVector(-width/(SCALE*2),-height/(SCALE*2));
  LOWER_RIGHT= new PVector(width/(SCALE*2),-height/(SCALE*2));
  animController= new AnimProcedure(){
      SquareAnimProcedure prevAnim;
      int depth=0;
      public void setup(){
        prevAnim=new SquareAnimProcedure(5,2,PVadd(UPPER_LEFT,vec(1,-6)),PVadd(UPPER_LEFT,vec(1+3,-6)));
        add(prevAnim);
        AnimEvent continue_event=new AnimEvent(){
          public void occur(){
            depth++;
            prevAnim=new SquareAnimProcedure(prevAnim.c,prevAnim.n, PVadd(UPPER_LEFT,vec(1+3,-6)),PVadd(UPPER_LEFT,vec(1+3,-6)));
            add(prevAnim);
            if(depth<4){
              add(this);
            }
          }
        };
        add(continue_event);
      }
      public void draw(){
      };
    };
  //animController=new SquareAnimProcedure(2,12,PVadd(UPPER_LEFT,vec(1,-6)));
  try{
    animController.setup();
  } catch (Exception e){
    e.printStackTrace();
  }
  
  //animController.add(new AnimTransition(100){
  //  public void start(){
      
  //  }
  //  public void play(int frame, float fract){
  //  //nothing !
  //    fract=sinlerp(sinlerp(fract));
  //    squares.origin=PVadd(UPPER_LEFT,vec(1+fract*2,-1));
  //  }
  //  public void end(){
      
  //  }
  //});
}
void draw(){
  animController.run();
  
  //squares_split_diag.origin= vec((mouseX-width/2)/SCALE,-(mouseY-height/2)/SCALE);
  background(0);
  translate(width/2,height/2);
 
  scale(SCALE,-SCALE);
  fill(255);
  noStroke();
  try{
    animController.render();
  } catch (Exception e){
    e.printStackTrace();
  }
  
  
}
