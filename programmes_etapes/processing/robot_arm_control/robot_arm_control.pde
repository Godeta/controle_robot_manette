import processing.serial.*;              // importer la librairie série

Serial[] EsploraList = new Serial[2];    // liste des appareils en série
String portNumber = "";                  // le prochain port à initialiser
int portCount = 0;                       // nombre de ports qui ont été initialisés

//variables robot
PShape base, shoulder, upArm, loArm, end;
float rotX, rotY;
float posX=1, posY=50, posZ=50;
float alpha, beta, gamma;

//objets
float[] Xsphere = new float[99];
float[] Ysphere = new float[99];
float[] Zsphere = new float[99];

float Xbox = -50.0;
float Ybox = -60.0;
float Zbox = -20.0;
float dist3d =0;

boolean boxConnect = false;

void setup(){
    size(1200, 800, OPENGL);
    
    //charger les formes
    base = loadShape("r5.obj");
    shoulder = loadShape("r1.obj");
    upArm = loadShape("r2.obj");
    loArm = loadShape("r3.obj");
    end = loadShape("r4.obj");
    
    shoulder.disableStyle();
    upArm.disableStyle();
    loArm.disableStyle(); 
}

void draw(){ 
  //choix du port
    if (portCount < 1) {
  choosePort(0);
    }
   writePos();
   background(32);
   smooth();
   lights(); 
   directionalLight(51, 102, 126, -1, 0, 0);
    
    //taille de la sphère
    for (int i=0; i< Xsphere.length - 1; i++) {
    Xsphere[i] = Xsphere[i + 1];
    Ysphere[i] = Ysphere[i + 1];
    Zsphere[i] = Zsphere[i + 1];
    }
    
    Xsphere[Xsphere.length - 1] = posX;
    Ysphere[Ysphere.length - 1] = posY;
    Zsphere[Zsphere.length - 1] = posZ;
   
   noStroke(); 
   //camera
   translate(width/2,height/2);
   rotateX(rotX);
   rotateY(-rotY);
   scale(-4);
   
       //rectangle
    pushMatrix(); //save coord
    //grab the box
    if(boxConnect) {
     Xbox =  -Ysphere[98];
     Ybox = -Zsphere[98];
     Zbox = -Xsphere[98];
    }
    else {
      fill(#FFFFFF);
      dist3d = sqrt( sq(-Ysphere[98]-Xbox)+sq(-Zsphere[98]-Ybox)+sq(-Xsphere[98]-Zbox) );
      //println(dist3d);
      //detect short distance
      if( dist3d<11.5){
       fill(#FF0000); 
       println("CONTACT");
       boxConnect=true;
    }
    }
    translate(Xbox, Ybox, Zbox);
    box(50,10,20);
    //translate(50,60,20);
    popMatrix(); //restore
   
   //sphere
   for (int i=0; i < Xsphere.length; i++) {
     pushMatrix();
     translate(-Ysphere[i], -Zsphere[i]-11, -Xsphere[i]);
     fill (#D003FF, 25);
     sphere (float(i) / 20);
     popMatrix();
    }
    
    //robot
   fill(#FFE308);  
   translate(0,-40,0);   
     shape(base);
     
   translate(0, 4, 0);
   rotateY(gamma);
     shape(shoulder);
      
   translate(0, 25, 0);
   rotateY(PI);
   rotateX(alpha);
     shape(upArm);
      
   translate(0, 0, 50);
   rotateY(PI);
   rotateX(beta);
     shape(loArm);
      
   translate(0, 0, -50);
   rotateY(PI);
     shape(end);
}

//déplacement souris
void mouseDragged(){
    rotY -= (mouseX - pmouseX) * 0.01;
    rotX -= (mouseY - pmouseY) * 0.01;
}

//connection en série au Arduino
void choosePort(int whichPort) {
  // get the port name from the serial list:
  String portName = Serial.list()[whichPort];  
  // initialize the next Esplora:
  EsploraList[portCount] = new Serial(this, portName, 9600);
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  EsploraList[portCount].bufferUntil('\n');
  // clear the string holding the port number:
  portNumber = "";
  portCount++;
}
