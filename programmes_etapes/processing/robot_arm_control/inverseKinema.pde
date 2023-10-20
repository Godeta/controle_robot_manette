float F = 50;
float T = 70;
float millisOld, gTime, gSpeed = 4;

//gestion déplacement du robot
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

//déplacement automatique
void setTime(){
  gTime += ((float)millis()/1000 - millisOld)*(gSpeed/4);
  if(gTime >= 4)  gTime = 0;  
  millisOld = (float)millis()/1000;
}

//actualiser la position
void writePos(){
  IK();
  //setTime();
  //posX = sin(gTime*PI/2)*20;
  //posY= cos(gTime)*3+50;
  //posZ = sin(gTime*PI)*10;
  
}

// méthode qui se lance automatiquement chaque fois que le buffer atteint la valeur binaire définie par bufferUntil()
void serialEvent(Serial thisPort) { 
  // lecture du buffer série
  String inputString = thisPort.readStringUntil('\n');

  // enlève les sauts de ligne
  inputString = trim(inputString);

  // sépare les inputs par rapport aux virgules et converti les sections en entiers
  int sensors[] = int(split(inputString, ','));

  // si on a toutes les valeurs du capteur on les utilise
  if (sensors.length == 5) {
    //printArray(sensors);
    //println("-  -  -  -");
    if(sensors[1]==0) {
      posX = posX+1;
      println("TEST ");
      print(sensors[1]);
    }
    else if(sensors[2]==0) {
      //translate (100, 100); //augmente l'angle
      posX = posX-1;
      println("OK ");
      print(posX);
    }
        else if(sensors[3]==0) {
      //translate (100, 100);
      posZ = posZ+1;
      println("KO ");
      print(posZ);
    }
    else if(sensors[4]==0) {
      //translate (100, 100); 
      posZ = posZ-1;
      println("KO ");
      print(posZ);
    }
    posY = 50+sensors[0]/20;
  }
}
