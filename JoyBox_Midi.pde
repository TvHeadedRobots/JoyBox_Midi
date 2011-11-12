//using 5v ARef as voltage source
//0v leg on pot must go to GND

#include <Potentiometer.h>
#include <MIDI.h>

#define LED 13

Potentiometer potentiometer = Potentiometer(2); //a Potentiometer at analog in 2 (Y-Axis on Joystick)
Potentiometer potentiometer2 = Potentiometer(3); //a Potentiometer at analog in 3 (X-Axis on Joystick)

int yHigh = 1023; // Joystick Y top value. This value varies
int yLow = 30; // Joystick Y bottom value. This value varies
int yCenter = 515; // Joystick Y center position value. This value varies
int yRange = yHigh - yLow; // Range required for obtaining linear curve

int xHigh = 1007; // Joystick X right value. This value varies
int xLow = 7; // Joystick X left value. This value varies
int xCenter = 499; // Joystick X center position value. This value varies
int xRange = xHigh - yLow; // Range required for obtaining linear curve

float midiCalY = 127.0 / yRange; //Convert Joystick values to MIDI
float midiCalX = 127.0 / xRange; //Convert Joystick values to MIDI

int midiValY = 0;
int midiValX = 0;
 int noteOff = 0;

void setup(){
  Serial.begin(31250);
  MIDI.begin(1);            	// Launch MIDI with default options. Input Chan 1
  Serial.println("JoyBox Midi");
  delay(2000);
}

void loop(){
  midiValY = constrain(midiCalY * potentiometer.getValue(), 0, 127);
  
  if(potentiometer.getValue() != yCenter || potentiometer.getValue() != yCenter + 1 || potentiometer.getValue() != yCenter -1 ) {
    digitalWrite(LED,HIGH);     // Blink the LED
    //noteOff = midiValY;
    MIDI.sendNoteOn(midiValY, 127, 1); //Send note
  }
  else {
    MIDI.sendControlChange(120, 0, 1);
    digitalWrite(LED,LOW);  //Turn LD off
  }
    
  delay(10); //how often do we poll for data? (in ms)
}
