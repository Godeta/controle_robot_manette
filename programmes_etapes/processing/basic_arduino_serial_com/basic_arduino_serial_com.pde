/*
  Processing Pong
 
 This sketch input serially from one or two Esploras to play a game of Pong.
 Esploras send four values, separated by commas, and ending with a linefeed:
 slider, switch 1, switch 3, switch 4
 
 The slider sets a paddle's height
 Switch 1 is resets the game
 Switch 2 resets the ball to the center
 Switch 3 reverses the players
 
 The Esplora example EsploraPong will send the correct values to this game.
 
 To start the game, select the Esplora's port number(s). You can play
 with one or two Esploras.
 
 created 22 Dec 2012
 by Tom Igoe
 
 This example is in the public domain.
 */


import processing.serial.*;              // import the Serial library
import java.awt.Rectangle;               // import Java's Rectangle class

Serial[] EsploraList = new Serial[2];    // a list of Serial devices
int portCount = 0;                       // the number of serial ports that's been initialized
String portNumber = "";                  // string of the next port to be initialized
int fontSize = 20;      // size of the fonts on the screen

void setup() {
  size(640, 480);       // set the size of the applet window

  // create a font with the third font available to the system:
  PFont myFont = createFont(PFont.list()[2], fontSize);
  textFont(myFont);
}


void draw() {
  // clear the screen:
  background(0);
  fill(255);

  // if there's not enough ports initialized:
  if (portCount < 2) {
    // get a list of the serial ports:
    String[] portList = Serial.list();
    // draw instructions on the screen:
    text("Type the port number of Esplora #" + (portCount+1), 20, 20);
    text("(or type enter to finish):", 20, 40);

    // draw the port list on the screen:
    for (int i = 0; i < portList.length; i++) {
      text("port " + i + ":  " + portList[i], 20, (i+4)*20);
    }
  } 
  
  // if you've got all the ports:
  else {
  }
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
    printArray(sensors);
    println("-  -  -  -");
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
