#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

const int buttonPin = 2;

int16_t ax, ay, az;

float last_ax = 0;
float last_ay = 0;

float impactThreshold = 0.35;

void setup() {

  Serial.begin(9600);
  Wire.begin();
  mpu.initialize();

  pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {

  mpu.getAcceleration(&ax, &ay, &az);

  float ax_g = ax / 16384.0;
  float ay_g = ay / 16384.0;

  float diffX = ax_g - last_ax;
  float diffY = ay_g - last_ay;

  int buttonState = digitalRead(buttonPin);

  int gesture = 0;

  if (diffX > impactThreshold) gesture = 1;
  else if (diffX < -impactThreshold) gesture = 2;
  else if (diffY > impactThreshold) gesture = 3;
  else if (diffY < -impactThreshold) gesture = 4;

  if (gesture != 0) {

    if (buttonState == HIGH) {
      gesture += 4;
    }

    Serial.println(gesture);
  }

  last_ax = ax_g;
  last_ay = ay_g;

  delay(100);
}