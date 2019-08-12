////////////////////////////////////////////////
// Toggle a black box to choose left or right //
// Golf ball movements                        //
// https://github.com/cheapjack/BlackBoxGolf/ //
//                                            //
//                                            //
////////////////////////////////////////////////

#include <Servo.h>
const int button = 6; //button pin, connect to ground to move servo
const int buttonNo = 5; //button pin, connect to ground to move servo
int pressYes = 0;
int pressNo = 0;
int decision = 0;
Servo servo;
Servo servo2;
boolean toggle = true;
boolean toggleNo = true;
boolean released = false;
boolean noReleased = false;
//boolean flag = false;
const int ledPin =  13;      // the number of the LED pin
const int Servo1OnAngle = 160;
const int Servo1OffAngle = 20; // Angle to default to
const int Servo2RightAngle = 108;
const int Servo2LeftAngle = 50;
const int Servo2OffAngle = 90; // Angle to default to

void setup()
{
  Serial.begin(9600);
  pinMode(button, INPUT); //arduino monitor pin state
  pinMode(ledPin, OUTPUT);
  servo.attach(9); //pin for servo control signal
  servo2.attach(3); //pin for servo control signal
  digitalWrite(5, HIGH); //enable pullups to make pin high
  servo.write(Servo1OffAngle);
  //delay(15);
  servo2.write(Servo2OffAngle);
  //delay(15);
  Serial.println("Button Pressed Yet?");
  digitalWrite(ledPin, LOW);

}

void loop()
{
  Serial.println("Looking at Buttons...");
  pressYes = digitalRead(button);
  delay(10);
  pressNo = digitalRead(buttonNo);
  if (pressYes == HIGH && pressNo == LOW)
  {
    if(toggle)
    {
      Serial.println("Yes Pressed");
      digitalWrite(ledPin, HIGH);
      servo2.write(Servo2RightAngle);
      delay(20);
      servo.write(Servo1OnAngle);
      delay(15);
      toggle = !toggle;
      released = true;
      Serial.print(released);
      Serial.println("Golf ball on it's way to the right!");
      delay(5000);
      Serial.print("Resetting");
      servo2.write(Servo2OffAngle);
      delay(20);
      servo.write(Servo1OffAngle);
      delay(15);
      digitalWrite(ledPin, LOW);
    }
  }
    else if (pressNo == HIGH && pressYes == LOW)
    {
      if(toggleNo)
      {
        Serial.println("No Pressed!");
        digitalWrite(ledPin, HIGH);
        delay(50);
        digitalWrite(ledPin, LOW);
        delay(30);
        digitalWrite(ledPin, HIGH);
        delay(50);
        servo2.write(Servo2LeftAngle);
        delay(20);
        servo.write(Servo1OnAngle);
        delay(15);
        toggleNo = !toggleNo;
        noReleased = true;
        Serial.println("noReleased state:");
        Serial.print(noReleased);
        Serial.println("Golf ball on it's way to the left!");
        delay(5000);
        Serial.print("Resetting");
        servo2.write(Servo2OffAngle);
        delay(20);
        servo.write(Servo1OffAngle);
        delay(15);
        digitalWrite(ledPin, LOW);
        }
    } 
    else
    {
      digitalWrite(ledPin, LOW);
      servo.write(Servo1OffAngle);
      delay(15);
      servo2.write(Servo2OffAngle);
      delay(15);
      toggle = !toggle;
      toggleNo = !toggleNo;
      released = !released;
      noReleased = !noReleased;
      Serial.println(released);
      }
      delay(500);  //delay for debounce
  }

