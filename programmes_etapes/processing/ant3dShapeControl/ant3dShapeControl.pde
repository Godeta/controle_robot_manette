PShape ball;
PImage txtr;
float theta;

import processing.serial.*;              // import the Serial library
import java.awt.Rectangle;               // import Java's Rectangle class

Serial[] EsploraList = new Serial[2];    // a list of Serial devices
int portCount = 0;                       // the number of serial ports that's been initialized
String portNumber = "";                  // string of the next port to be initialized
int fontSize = 20;      // size of the fonts on the screen
float x=0, y=0, z = 0;

void setup() {
    // create a font with the third font available to the system:
  PFont myFont = createFont(PFont.list()[2], fontSize);
  textFont(myFont);
  size (500, 500, P3D);
  txtr = loadImage("texture-01.jpg");
  ball = loadShape("ant.obj");
  ball.setTexture(txtr); //attach texture to the 3D shape
}


void draw () {
  background (0);
  //lights();
  
    // if there's not enough ports initialized:
  if (portCount < 1) {
    // get a list of the serial ports:
    String[] portList = Serial.list();
    if(portList.length >0) {
    // draw instructions on the screen:
    text("Type the port number of Esplora #" + (portCount+1), 20, 20);
    text("(or type enter to finish):", 20, 40);

    // draw the port list on the screen:
    for (int i = 0; i < portList.length; i++) {
      text("port " + i + ":  " + portList[i], 20, (i+4)*20);
    }
    }
    else {
     portCount++; 
    }
  } 
  
    // if you've got all the ports:
  else {
    
    //show ant
  pushMatrix();
  translate (width/2, height/2);
  rotate(theta);
  rotateY(theta/2);
  scale (1000);
  shape (ball, x, y);
  popMatrix();

  animateShape();
  }


}

//control the shape with the arduino
void animateShape(){
  
  theta+=.01; //increment angle
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
      theta+=.11; //increment angle
      println("TEST ");
      print(sensors[1]);
    }
    else if(sensors[2]==0) {
      //translate (100, 100); //increment angle
      x = x+0.1;
      println("OK ");
      print(x);
    }
        else if(sensors[3]==0) {
      //translate (100, 100); //increment angle
      x = x-0.1;
      println("KO ");
      print(x);
    }
  }
}

void keyReleased() {
  // if the enter key is pressed, stop looking for port number selections:
  if (key == ENTER) {
    println("ENTRER !!!");
    if (portNumber != "" && portCount < 1) {
      choosePort(int(portNumber));
    }
    portCount++;
  }

  // if the user types 0 though 9, use it as a port number selection:
  if (key >= '0' && key <= '9') {
    portNumber += key;
    println("Chiffre");
  }
}

void choosePort(int whichPort) {
  // get the port name from the serial list:
  String portName = Serial.list()[whichPort];  
  // initialize the next Esplora:
  EsploraList[portCount] = new Serial(this, portName, 9600);
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  EsploraList[portCount].bufferUntil('\n');
  // clear the string holding the port number:
  portNumber = "";
}

/* code arduino
#include <Esplora.h>

void setup() {
  Serial.begin(9600);     // initialize serial communication
}

void loop() {
  // read the slider and three of the buttons
  int slider = Esplora.readSlider();
  int resetButton = Esplora.readButton(SWITCH_1);
  int serveButton = Esplora.readButton(SWITCH_3);
  int switchPlayerButton = Esplora.readButton(SWITCH_4);

  Serial.print(slider);                // print the slider value
  Serial.print(",");                   // add a comma
  Serial.print(resetButton);           // print the reset button value
  Serial.print(",");                   // add another comma
  Serial.print(serveButton);           // print the serve button value
  Serial.print(",");                   // add another comma
  Serial.println(switchPlayerButton);  // print the last button with a newline
  delay(10);                           // delay before sending the next set
}
*/
