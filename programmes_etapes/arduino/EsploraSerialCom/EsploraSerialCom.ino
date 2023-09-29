/*
 This  sketch connects serially to a Processing sketch to control a Pong game.
 It sends the position of the slider and the states of three pushbuttons to the
 Processing sketch serially, separated by commas. The Processing sketch uses that
 data to control the graphics in the sketch.
 */

#include <Esplora.h>
#include <TFT.h>
#include <SPI.h>

int xPos = EsploraTFT.width()/2;
int yPos = EsploraTFT.height()/2;

char screenPrint[8];

void setup() {
  Serial.begin(9600);     // initialize serial communication
  EsploraTFT.begin();
  EsploraTFT.background(0,0,0);
  EsploraTFT.stroke(200,20,180);
  EsploraTFT.setTextSize(2);
  EsploraTFT.text("Serial values :\n ",0,0);
  EsploraTFT.setTextSize(1);
}

void loop() {
  // read the slider and three of the buttons
  int slider = Esplora.readSlider();
  int s1 = Esplora.readButton(SWITCH_1);
  int s2 = Esplora.readButton(SWITCH_2);
  int s3 = Esplora.readButton(SWITCH_3);
  int s4 = Esplora.readButton(SWITCH_4);

  Serial.print(slider);                // print the slider value
  Serial.print(",");                   // add a comma
  Serial.print(s1);           // print the reset button value
  Serial.print(",");                   // add another comma
  Serial.print(s2);           // print the serve button value
  Serial.print(",");                   // add another comma
  Serial.print(s3);           // print the serve button value
  Serial.print(",");                   // add another comma
  Serial.println(s4);  // print the last button with a newline
  // set the text color to white
  EsploraTFT.stroke(255, 255, 255);

  // print the temperature one line below the static text
  String(String(s1)+","+String(s2)+","+String(s3)+","+String(s4)).toCharArray(screenPrint,8);
  EsploraTFT.text(screenPrint, 0, 30);
  
  delay(10);                           // delay before sending the next set
  EsploraTFT.stroke(0, 0, 0);
  EsploraTFT.text(screenPrint, 0, 30);

}
