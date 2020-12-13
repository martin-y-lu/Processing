//INTEGER DECIMALISER
  //setD(l,new Command[]{new sp(64),new id(1),new ja(65*13)});
  //l=65*13;
  //setD(l,new Command[]{new sp(65*15+4),new id(125),new sp(64),new ja(65*14)});
  //l=65*14;
  //setD(l,new Command[]{new sp(65*15+10),new id(125)});
  //l+=2;
  
  ///// BEFORE COMPUTATION 65*15+10: nuber to be decimalised
  ///// AFTER COMPUTATION: 65*15+10: ones: 65*15+10-1: tens: 65*15+10: hundreds+
  //setD(l,new Command[]{new id(-10),new jr(4),new id(10),new jr(8),new sp(65*15+10-1),new id(1),new sp(65*15+10),new jr(0)});
  //l+=8;
  //setD(l,new Command[]{new sp(65*15+10-1)});
  //l+=1;
  //setD(l,new Command[]{new id(-10),new jr(4),new id(10),new jr(8),new sp(65*15+10-2),new id(1),new sp(65*15+10-1),new jr(0)});
  //l+=8;
  //setD(l,new Command[]{new sp(65*15+10),new id(-10),new id(-7),new sp(65*15+10-1),new id(-10),new id(-7),new sp(65*15+10-2),new id(-10),new id(-7)});
  //l+=10;
  //setD(l,new Command[]{new sp(64),new ja(65*10)});



//for(int x=0;x<65*65;x++){
//    D[x]=char(65*4+0);
//  }
  
//  //Copy to index 7:21, 7:22
//  D[0]=incp(65*6+12);
//  D[1]=incp(1);
//  D[2]=incd(1);
//  D[3]=incp(1);
//  D[4]=incd(1);
//  D[5]=incp(-2);
//  D[6]=incd(-1);
//  D[7]=jumc(1);
  
//  D[8]=incp(2);
  
//  D[9]=incd(-1);// one mod 10
//  D[10]=jumc(15);
//  D[11]=incp(2);
//  D[12]=incd(1);
//  D[13]=jumc(65*25);
  
//  D[15]=incd(-1);// 2 mod 10
//  D[16]=jumc(20);
//  D[17]=incp(2);
//  D[18]=incd(2);
//  D[19]=jumc(65*25);
  
  
//  D[20]=incd(-1); // 3 mod 10
//  D[21]=jumc(25);
//  D[22]=incp(2);
//  D[23]=incd(3);
//  D[24]=jumc(65*25);
  
//  D[25]=incd(-1); // 4 mod 10
//  D[26]=jumc(30);
//  D[27]=incp(2);
//  D[28]=incd(4);
//  D[29]=jumc(65*25);
  
//  D[30]=incd(-1);// 5 mod 10
//  D[31]=jumc(35);
//  D[32]=incp(2);
//  D[33]=incd(5);
//  D[34]=jumc(65*25);
  
//  D[35]=incd(-1);// 6 mod 10
//  D[36]=jumc(40);
//  D[37]=incp(2);
//  D[38]=incd(6);
//  D[39]=jumc(65*25);
  
//  D[40]=incd(-1); // 7 mod 10
//  D[41]=jumc(45);
//  D[42]=incp(2);
//  D[43]=incd(7);
//  D[44]=jumc(65*25);
  
//  D[45]=incd(-1);// 8 mod 10
//  D[46]=jumc(50);
//  D[47]=incp(2);
//  D[48]=incd(8);
//  D[49]=jumc(65*25);
  
//  D[50]=incd(-1);// 9 mod 10
//  D[51]=jumc(55);
//  D[52]=incp(2);
//  D[53]=incd(9);
//  D[54]=jumc(65*25);
  
//  D[55]=incd(-1);// 0 mod 10
//  D[56]=jumc(59);
//  D[57]=incp(2);
//  D[58]=jumc(65*25);
  
//  D[59]=incp(1);
//  D[60]=incd(1);
//  D[61]=incp(-1);
//  D[62]=jumc(9);
  
//  D[65*25]=incp(-1);
//  D[65*25+1]=incd(-1);
//  D[65*25+2]=incp(10);
//  D[65*25+3]=incd(1);
//  D[65*25+4]=incp(1);
//  D[65*25+5]=incd(1);
//  D[65*25+6]=incp(-11);
//  D[65*25+7]=jumc(65*25+1);
//  D[65*25+8]=incp(11);
  
//  //Seconds and thirds digit
//  D[65*25+9]=incd(-1);// one mod 10
//  D[65*25+10]=jumc(65*25+15);
//  D[65*25+11]=incp(2);
//  D[65*25+12]=incd(1);
//  D[65*25+13]=jumc(65*26);
  
//  D[65*25+15]=incd(-1);// 2 mod 10
//  D[65*25+16]=jumc(65*25+20);
//  D[65*25+17]=incp(2);
//  D[65*25+18]=incd(2);
//  D[65*25+19]=jumc(65*26);
  
//  D[65*25+20]=incd(-1); // 3 mod 10
//  D[65*25+21]=jumc(65*25+25);
//  D[65*25+22]=incp(2);
//  D[65*25+23]=incd(3);
//  D[65*25+24]=jumc(65*26);
  
//  D[65*25+25]=incd(-1); // 4 mod 10
//  D[65*25+26]=jumc(65*25+30);
//  D[65*25+27]=incp(2);
//  D[65*25+28]=incd(4);
//  D[65*25+29]=jumc(65*26);
  
//  D[65*25+30]=incd(-1);// 5 mod 10
//  D[65*25+31]=jumc(65*25+35);
//  D[65*25+32]=incp(2);
//  D[65*25+33]=incd(5);
//  D[65*25+34]=jumc(65*26);
  
//  D[65*25+35]=incd(-1);// 6 mod 10
//  D[65*25+36]=jumc(65*25+40);
//  D[65*25+37]=incp(2);
//  D[65*25+38]=incd(6);
//  D[65*25+39]=jumc(65*26);
  
//  D[65*25+40]=incd(-1); // 7 mod 10
//  D[65*25+41]=jumc(65*25+45);
//  D[65*25+42]=incp(2);
//  D[65*25+43]=incd(7);
//  D[65*25+44]=jumc(65*26);
  
//  D[65*25+45]=incd(-1);// 8 mod 10
//  D[65*25+46]=jumc(65*25+50);
//  D[65*25+47]=incp(2);
//  D[65*25+48]=incd(8);
//  D[65*25+49]=jumc(65*26);
  
//  D[65*25+50]=incd(-1);// 9 mod 10
//  D[65*25+51]=jumc(65*25+55);
//  D[65*25+52]=incp(2);
//  D[65*25+53]=incd(9);
//  D[65*25+54]=jumc(65*26);
  
//  D[65*25+55]=incd(-1);// 0 mod 10
//  D[65*25+56]=jumc(65*25+59);
//  D[65*25+57]=incp(2);
//  D[65*25+58]=jumc(65*26);
  
//  D[65*25+59]=incp(1);
//  D[65*25+60]=incd(1);
//  D[65*25+61]=incp(-1);
//  D[65*25+62]=jumc(65*25+9); 
  
//  D[65*26]=incd(-1);
//  D[65*26+1]=incp(-19);
//  D[65*26+2]=incd(1);
//  D[65*26+3]=incp(19);
//  D[65*26+4]=jumc(65*26);
  
//  D[65*26+5]=incp(-1);
//  D[65*26+6]=incd(-1);
//  D[65*26+7]=incp(-19);
//  D[65*26+8]=incd(1);
//  D[65*26+9]=incp(19);
//  D[65*26+10]=jumc(65*26+6);
  
//  D[65*26+11]=incp(-11);
//  D[65*26+12]=incd(-1);
//  D[65*26+13]=incp(-6);
//  D[65*26+14]=incd(1);
//  D[65*26+15]=incp(6);
//  D[65*26+16]=jumc(65*26+12);
  
  
//  D[65*6+12]=num(525);


/// OLD SUM DIFFERENCE
  //D[65*7+35]=num(10);
  //D[65*7+36]=num(17);
  //D[65*6+20]=num(1);
  
  //Sum difference calculator
  //D[0]=incp(65*6+11);
  //D[1]=incp(1);
  //D[2]=incd(1);
  //D[3]=incp(1);
  //D[4]=incd(1);
  //D[5]=incp(1);
  //D[6]=incd(1);
  //D[7]=incp(-3);
  //D[8]=incd(-1);
  //D[9]=jumc(1);
  
  //D[10]=incp(1);
  //D[11]=incd(-1);
  //D[12]=incp(-1);
  //D[13]=incd(1);
  //D[14]=incp(1);
  //D[15]=jumc(11);
  
  //D[16]=incp(8);
  //D[1+16]=incp(1);
  //D[2+16]=incd(1);
  //D[3+16]=incp(1);
  //D[4+16]=incd(1);
  //D[5+16]=incp(1);
  //D[6+16]=incd(1);
  //D[7+16]=incp(-3);
  //D[8+16]=incd(-1);
  //D[9+16]=jumc(1+16);
  
  //D[10+16]=incp(1);
  //D[11+16]=incd(-1);
  //D[12+16]=incp(-1);
  //D[13+16]=incd(1);
  //D[14+16]=incp(1);
  //D[15+16]=jumc(11+16);
  
  //D[32]=incp(1);
  ////D[32+1]=jumc(100);
  //D[32+2]=incd(-1);
  //D[32+3]=incp(-9);
  //D[32+4]=incd(1);
  //D[32+5]=incp(1);
  //D[32+6]=incd(-1);
  //D[32+7]=incp(-1);
  //D[32+8]=incp(9);
  //D[32+9]=jumc(32+2);
  
  //D[63]=incd(1);//END
  //D[64]=jumc(64);
  
