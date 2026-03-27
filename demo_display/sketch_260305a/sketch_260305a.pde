import processing.serial.*;

Serial myPort;
int number = 0;

void setup() {
  size(600, 600);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(0);
  textAlign(CENTER, CENTER);
  textSize(200);
  fill(255);
  text(number, width/2, height/2);
}

void serialEvent(Serial p) {
  String val = p.readStringUntil('\n');
  if (val != null) {
    val = trim(val);
    number = int(val);
  }
}
