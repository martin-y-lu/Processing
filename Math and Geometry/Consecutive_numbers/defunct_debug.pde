///-------------------------------Debugging the anim proceedure-------------------------------
//new AnimProceedure(){
//        public void setup(){
//          print("starting internal proceedure");
//          add(
//            //new DelayTransition(30),
//            new AnimEvent(){
//              public void occur(){
//                println("hallo"); 
//                println("squares_initial:"+squares_initial);
//                println("squares_initial.xShift:"+squares_initial.xShift);
//                //squares_initial.xShift=-4;
//                //println("squares_initial.xShift:"+squares_initial.xShift);
//              }
//            },
//            new SquareLerpTransition(100,squares_initial){
//              public void set(AnimController _controller){
//                super.set(_controller);
//                println("Just got set, startframe:"+startFrame);
                
//              }
//              public void play(int frame, float fract){
//                //print("Frame:"+frame);
//                super.play(frame,fract);
//              }
//            }._Translate(vec(2,0))._Ease(new SineEaseFunction().iterate(2)),
//            new DelayTransition(30)
//          );
//          println("number of transitions:"+transitions.size());
//        }
//        public void run(){
//          super.run();
//          //print("Frame:"+frame);
//        }
//        public void end(){
//          println("number of transitions:"+transitions.size());
//          println("TotalLength:"+ this.totalLength());
//          print("Ended"); 
//        }
//      }

///-------------------------------Debugging issues in nested controllers-------------------------------
// new AnimController(){
//  public void setup(){
//    add(
//      new DelayTransition(10),
//      new AnimProcedure(){
//        public void setup(){
//          println("HELLO");
//          add(
//            new AnimEvent(){
//                public void occur(){
//                println("BRUH_0"); 
//              }
//            },
//            new DelayTransition(10),
//            new AnimEvent(){
//              public void occur(){
//                println("BRUH_1"); 
//              }
//            },
//            new AnimEvent(){
//              public void occur(){
//                println("BRUH_1_1"); 
//              }
//            }
//            );
//        }
//      }
//      ,
//      new AnimEvent(){
//          public void occur(){
//          println("BRUH_2"); 
//        }
//      }
      
//    );
//  }
//  public void draw(){}
//};
