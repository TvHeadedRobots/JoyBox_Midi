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
int origMidiValY = -1; //original value to stop FM from occuring

int midiValX = 0;
int noteOff = 0;

int buttonPin = 11; // set input pin # for button
int buttonPress = 0; // set initial button value (used as "0" velocity value)

//int buttonIrpt = 0 // interrupt 0 is on digital pin 2, can use it with interrupt.
//volatile int state = LOW; //Set state for interrupt

void setup(){
  Serial.begin(31250);
  //Serial.begin(9600);
  
  MIDI.begin(1); // Launch MIDI with default options. Input Chan 1
  
  pinMode(buttonPin, INPUT);
  digitalWrite(buttonPin, LOW);
  //attachInterrupt(buttonIrpt, play, CHANGE); //attach interrupt to button press
  
  //Serial.println("JoyBox Midi");
  delay(2000); 
}

void loop(){
  midiValY = constrain(midiCalY * potentiometer.getValue(), 32, 127);
  digitalWrite(LED, LOW);  //Turn LD off

  if(digitalRead(buttonPin) == HIGH) {   
    buttonPress = 127;
    digitalWrite(LED,HIGH);  //Turn LD on
    MIDI.sendNoteOn(midiValY,buttonPress, 1); //Send note
    origMidiValY = midiValY;
    
    // Fix to stop repeated note triggering
    while(digitalRead(buttonPin) == HIGH){
      delay(1);
    }
    
  }
  
  else {
    buttonPress = 0;
    MIDI.sendControlChange(120, 0, 1);
    digitalWrite(LED,LOW);  //Turn LD off
    MIDI.sendNoteOff(origMidiValY,buttonPress, 1); //Send note
  }
    
  
  /*else {
    buttonPress = 0;
    MIDI.sendControlChange(120, 0, 1);
    digitalWrite(LED,LOW);  //Turn LD off
    MIDI.sendNoteOff(midiValY,buttonPress, 1); //Send note
  }*/
  
  //delay(5); //how often do we poll for data? (in ms)
}


