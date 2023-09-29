float F = 50;
float T = 70;
float millisOld, gTime, gSpeed = 4;

void IK(){
  float X = posX;
  float Y = posY;
  float Z = posZ;

  float L = sqrt(Y*Y+X*X);
  float dia = sqrt(Z*Z+L*L);

  alpha = PI/2-(atan2(L, Z)+acos((T*T-F*F-dia*dia)/(-2*F*dia)));
  beta = -PI+acos((dia*dia-T*T-F*F)/(-2*F*T));
  gamma = atan2(Y, X);
}

void setTime(){
  gTime += ((float)millis()/1000 - millisOld)*(gSpeed/4);
  if(gTime >= 4)  gTime = 0;  
  millisOld = (float)millis()/1000;
}

void writePos(){
  IK();
  //setTime();
  //posX = sin(gTime*PI/2)*20;
  //posY= cos(gTime)*3+50;
  //posZ = sin(gTime*PI)*10;
  
}

// serialEvent  method is run automatically whenever the buffer 
// reaches the byte value set by  bufferUntil():
void serialEvent(Serial thisPort) { 
  // read the serial buffer:
  String inputString = thisPort.readStringUntil('\n');

  // trim the carrige return and linefeed from the input string:
  inputString = trim(inputString);

  // split the input string at the commas
  // and convert the sections into integers:
  int sensors[] = int(split(inputString, ','));

  // if you received all the sensor values, use them:
  if (sensors.length == 5) {
    //printArray(sensors);
    //println("-  -  -  -");
    if(sensors[1]==0) {
      posX = posX+1;
      println("TEST ");
      print(sensors[1]);
    }
    else if(sensors[2]==0) {
      //translate (100, 100); //increment angle
      posX = posX-1;
      println("OK ");
      print(posX);
    }
        else if(sensors[3]==0) {
      //translate (100, 100); //increment angle
      posZ = posZ+1;
      println("KO ");
      print(posZ);
    }
    else if(sensors[4]==0) {
      //translate (100, 100); //increment angle
      posZ = posZ-1;
      println("KO ");
      print(posZ);
    }
    posY = 50+sensors[0]/20;
  }
}
