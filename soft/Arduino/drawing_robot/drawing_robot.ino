//----------------------------------------- parameter (CHANGE HERE)----------------------------------------- 
#define UP_PARAMETER 0
#define DOWN_PARAMETER 100

#define SERVO_1    2
#define SERVO_2    3
#define SERVO_3    9
#define LEDPIN     13

#define LED_BLINK_INTERVAL 1000

//----------------------------------------- communication protocol (DON'T CHANGE!)----------------------------------------- 
#define HEADER      '|' 
// commands
#define MOUSE       'M' 
#define MOUSEUP     'U'
#define MOUSEDOWN   'D'
#define DEBUG       'N'

#define MESSAGE_BYTES 4 // HEADER - COMMAND

//----------------------------------------- application
#include <Servo.h> 

boolean drawing = false;

Servo theta;
Servo beta;
Servo up;

// led blinking withoud delay
int ledState = LOW;
long previousMillis = 0;
long interval = LED_BLINK_INTERVAL;

void setup() {
  Serial.begin(115200);

  theta.attach(SERVO_1);   
  beta.attach(SERVO_2);
  up.attach(SERVO_3);

  pinMode(LEDPIN, OUTPUT);
}

//----------------------------------------- loop
void loop(){
  getDataFromProcessing();

  // led blinking
  if(!drawing) {
    unsigned long currentMillis = millis();
    if(currentMillis - previousMillis > interval) {
      previousMillis = currentMillis;   
      if (ledState == LOW)
        ledState = HIGH;
      else
        ledState = LOW;
      digitalWrite(LEDPIN, ledState);
    }
  }

}

void getDataFromProcessing() {
  if ( Serial.available() >= MESSAGE_BYTES) {
    if( Serial.read() == HEADER) {
      Serial.print("got header. ");

      setDrawing(true);

      char tag = Serial.read();
      unsigned char a = Serial.read(); // this was sent as a char but a char is [-127-127]. use unsigned char for [0,255]
      unsigned char b = Serial.read();

      //Serial.print(tag);

      decodeMessage(tag, a, b);
      //  delay(15);
    } 
    else {
      setDrawing(false); 
    }
  }
}

void decodeMessage(char tag, unsigned char a, unsigned char b) {
  if     (tag == MOUSEDOWN) setPen(true);
  else if(tag == MOUSEUP) setPen(false);
  else if(tag == DEBUG) debugUP(a);
  else if(tag == MOUSE) moveArm(a,b); 
  else {
    Serial.print("got message with unknown tag "); 
    Serial.println(tag);    
  }
}

void setDrawing(boolean state) {
  drawing = state;
  if (drawing) {
    digitalWrite(LEDPIN, HIGH);
  } 
  else {
    digitalWrite(LEDPIN, LOW);
  }
}

//----------------------------------------- commands
void debugUP(int a) {
  Serial.print("DEBUG up-servo:  ");
  Serial.println(a);
  up.write(a);
}

void setPen(boolean flag) {
  if(flag) {
    Serial.println("got mouse DOWN. ");
    up.write(DOWN_PARAMETER);
  } 
  else {
    Serial.println("got mouse UP. ");
    up.write(UP_PARAMETER);
  }
}

void moveArm(int a, int b) 
{
  Serial.print("got mouse. ");
  unsigned char atheta = a;
  unsigned char abeta = b;

  atheta = constrain(atheta, 0, 180);
  abeta = constrain(abeta, 0, 180);

  Serial.print("theta: "); 
  Serial.print(atheta); 
  Serial.print(", beta: "); 
  Serial.println(abeta);
  theta.write(atheta);
  beta.write(abeta);
}




