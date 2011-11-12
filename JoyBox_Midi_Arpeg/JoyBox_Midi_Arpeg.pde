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
volatile int origMidiValY = 0; //original value to stop FM from occuring in RAM

int midiValX = 0;
int noteOff = 0;

int buttonPin = 3; //set input pin # for button
int buttonPress = 0; // set initial button value (used as "0" velocity value)

int buttonIrpt = 1; // interrupt 1 is on digital pin 3
volatile int state = LOW; //Set state for interrupt

//Arpeggio A Notes
int arpA1 = 60;
int arpA2 = 72;
int arpA3 = 63;
int arpA4 = 75;
int arpA5 = 67;
int arpA6 = 65;

int xOff = 0;

void setup(){
  Serial.begin(31250);
  //Serial.begin(9600);
  
  MIDI.begin(1); // Launch MIDI with default options. Input Chan 1
  
  pinMode(buttonPin, INPUT);
  digitalWrite(buttonPin, state);
  attachInterrupt(buttonIrpt, play, RISING); //attach interrupt to button press
  //attachInterrupt(buttonIrpt, noPlay, LOW); //attach interrupt to button release
  
  //Serial.println("JoyBox Midi");
  delay(2000); 
}

void loop(){
  //if(digitalRead(buttonPin) == LOW) {noPlay();}
}

void play(){
  state = !state;
  buttonPress = 127;
  digitalWrite(LED, state);  //Turn LD on
  
  do {
    
    xOff = potentiometer2.getValue()/100;
    MIDI.sendNoteOn(xOff + arpA1,127, 1); //Send note
    delay((potentiometer.getValue() * 32) + 100);
    MIDI.sendNoteOff(xOff + arpA1,127, 1); //Send note off
    if(digitalRead(buttonPin) == LOW) {break;}
    
    xOff = potentiometer2.getValue()/100;
    MIDI.sendNoteOn(xOff + arpA2,127, 1); //Send note
    delay((potentiometer.getValue() * 32) + 100);
    MIDI.sendNoteOff(xOff + arpA2,127, 1); //Send note off
    if(digitalRead(buttonPin) == LOW) {break;}
    
    xOff = potentiometer2.getValue()/100;
    MIDI.sendNoteOn(xOff + arpA3,127, 1); //Send note
    delay((potentiometer.getValue() * 32) + 100);
    MIDI.sendNoteOff(xOff + arpA3,127, 1); //Send note off 
    if(digitalRead(buttonPin) == LOW) {break;}

    xOff = potentiometer2.getValue()/100;
    MIDI.sendNoteOn(xOff + arpA4,127, 1); //Send note
    delay((potentiometer.getValue() * 32) + 100);
    MIDI.sendNoteOff(xOff + arpA4,127, 1); //Send note off
    if(digitalRead(buttonPin) == LOW) {break;}

    xOff = potentiometer2.getValue()/100;   
    MIDI.sendNoteOn(xOff + arpA5,127, 1); //Send note
    delay((potentiometer.getValue() * 32) + 100);
    MIDI.sendNoteOff(xOff + arpA5,127, 1); //Send note off
    if(digitalRead(buttonPin) == LOW) {break;}
  
    xOff = potentiometer2.getValue()/100;
    MIDI.sendNoteOn(xOff + arpA5,127, 1); //Send note 
    delay((potentiometer.getValue() * 32) + 100);
    MIDI.sendNoteOff(xOff + arpA5,127,  1); //Send note off   
    if(digitalRead(buttonPin) == LOW) {break;}
    
  } while(digitalRead(buttonPin) == HIGH);
}

void noPlay(){
  //MIDI.sendControlChange(120, 0, 1);
  MIDI.sendNoteOff(origMidiValY,buttonPress, 1); //Send note
  digitalWrite(LED,LOW);  //Turn LD off
}
