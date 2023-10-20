#include <ArduinoBLE.h>

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);
  while (!Serial);
  // initialize the BLE hardware
  BLE.begin();
  Serial.println("BLE Central - Start program");
  // start scanning for Button Device BLE peripherals
  //BLE.scanForUuid("7C:66:9D:73:5D:F7");
  BLE.scanForName("BT05");
}
void loop() {
  //BLE.scan();
  // check if a peripheral has been discovered
  BLEDevice peripheral = BLE.available();
  if (peripheral) {
    // discovered a peripheral, print out address, local name, and advertised service
    Serial.print("Found ");
    Serial.print(peripheral.address());
    Serial.print(" '");
    Serial.print(peripheral.localName());
    Serial.print("' ");
    Serial.print(peripheral.advertisedServiceUuid());
    Serial.println();
    Serial.print(peripheral.characteristic(0));
    Serial.println();
    //Serial.print(peripheral.hasCharacteristic("0000FFE1-0000-1000-8000-00805F9B34FB"));
    /*if (peripheral.localName().indexOf("Button Device") < 0) {
      Serial.println("No 'Button Device' in name");
      return;  // If the name doesn't have "Button Device" in it then ignore it
    }*/
    // stop scanning
    BLE.stopScan();
    controlRobot(peripheral);
    // peripheral disconnected, start scanning again
    //BLE.scanForUuid("0000FFE1-0000-1000-8000-00805F9B34FB");
  }
}
void controlRobot(BLEDevice peripheral) {
  // connect to the peripheral
  Serial.println("Connecting ...");
  if (peripheral.connect()) {
    Serial.println("Connected");
  } else {
    Serial.println("Failed to connect!");
    return;
  }
//  // discover peripheral attributes
//  Serial.println("Discovering attributes ...");
//  if (peripheral.discoverAttributes()) {
//    Serial.println("Attributes discovered");
//  } else {
//    Serial.println("Attribute discovery failed!");
//    peripheral.disconnect();
//    return;
//  }
  Serial.println(" services count : ");
  Serial.print(peripheral.serviceCount());
    Serial.println(" characteristic count : ");
  Serial.print(peripheral.characteristicCount());

    // print the advertised service UUIDs, if present
    if (peripheral.hasAdvertisedServiceUuid()) {
      Serial.print("Service UUIDs: ");
      for (int i = 0; i < peripheral.advertisedServiceUuidCount(); i++) {
        Serial.print(peripheral.advertisedServiceUuid(i));
        Serial.print(" ");
      }
      Serial.print(peripheral.discoverService("ffe0"));
      Serial.println();
      Serial.print(peripheral.hasService("ffe0"));
    }
    
  // retrieve the com characteristic
  BLECharacteristic COMchara = peripheral.characteristic(0);//peripheral.characteristic("0000FFE1-0000-1000-8000-00805F9B34FB");
  /*if (!COMchara) {
    Serial.println("Peripheral does not have com chara !");
    peripheral.disconnect();
    return;
  }*/
  if (peripheral.connected()) {
    // while the peripheral is connected
//    if (COMchara.canRead()) {
//      byte value = COMchara.read();
//      COMchara.readValue(value);
//      //Serial.println(COMchara.readValue(value));
//      if (value == 0x01) {
//        Serial.println("ON");
//        digitalWrite(LED_BUILTIN, HIGH);
//      }
//      else if (value == 0x00) {
//        digitalWrite(LED_BUILTIN, LOW);
//        Serial.println("OFF");
//      }
//    }
    COMchara.writeValue("B#1");
    Serial.println("write com chara");
    delay(3000);
    COMchara.writeValue("B#0");
  }
  Serial.println("Peripheral disconnected");
}
