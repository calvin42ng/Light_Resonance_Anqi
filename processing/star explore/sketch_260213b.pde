ArrayList<CloudParticle> clouds;
ArrayList<StarParticle> star;

PVector center;
float circleY;

int globalState = 0;
float starRotation = 0;   // ★ 星星整体旋转角

void setup() {
  size(900, 700);
  smooth(8);
  frameRate(60);

  colorMode(HSB, 360, 100, 100, 100);

  center = new PVector(width/2, height/2 + 40);
  circleY = center.y;

  clouds = new ArrayList<CloudParticle>();
  for (int i = 0; i < 900; i++) {
    clouds.add(new CloudParticle());
  }

  star = new ArrayList<StarParticle>();
  for (int i = 0; i < 220; i++) {
    star.add(new StarParticle());
  }

  background(0);
}

void draw() {

  // 梦幻拖影
  fill(260, 25, 6, 22);
  noStroke();
  rect(0, 0, width, height);

  // 时间轴
  if (frameCount < 1000) globalState = 0;
  else if (frameCount < 1400) globalState = 1;
  else if (frameCount < 1650) globalState = 2;
  else if (frameCount < 1800) globalState = 3;
  else globalState = 4;

  if (globalState == 2) {
    circleY -= 0.1;
    center.y -= 0.1;
  }

  // ★ 星形持续旋转
  starRotation += 0.002;

  blendMode(ADD);

  // ⭐ 星形核心
  for (StarParticle s : star) {
    s.update();
    s.display();
  }

  // 🌈 彩色云
  for (CloudParticle p : clouds) {
    p.update();
    p.display();
  }

  blendMode(BLEND);
}

/* ===============================
   ⭐ 星形核心粒子
   =============================== */

class StarParticle {

  PVector pos, base;
  float phase;
  float size;
  color c;

  StarParticle() {
    base = randomPointInStar(90, 40);
    pos = new PVector();

    phase = random(TWO_PI);
    size = random(1.5, 3.0);
    c = color(50, 30, 100, 70);
  }

  void update() {

    float breathe = sin(frameCount * 0.02 + phase) * 2;

    // ★ 旋转 base
    PVector rotated = rotate2D(base, starRotation);
    rotated.mult(1 + breathe * 0.01);

    pos.x = center.x + rotated.x;
    pos.y = center.y + rotated.y;
  }

  void display() {
    noStroke();
    fill(c);
    ellipse(pos.x, pos.y, size, size);
  }
}

/* ===============================
   🌈 外部彩色云粒子
   =============================== */

class CloudParticle {

  PVector pos, vel;
  float size;
  color c;

  int birthFrame;
  boolean active = false;

  PVector target;

  CloudParticle() {

    birthFrame = int(random(0, 900));
    spawnAtEdge();

    vel = PVector.random2D().mult(random(0.05, 0.4));
    size = random(1.2, 3.5);
    c = color(random(360), 55, 100, 55);

    target = randomPointInStar(85, 38);
  }

  void spawnAtEdge() {
    float m = 140;
    float side = random(4);

    if (side < 1) pos = new PVector(random(width), -m);
    else if (side < 2) pos = new PVector(width+m, random(height));
    else if (side < 3) pos = new PVector(random(width), height+m);
    else pos = new PVector(-m, random(height));
  }

  void update() {

    if (frameCount < birthFrame) return;
    active = true;

    // ★ 目标点跟随星星旋转
    PVector rotatedTarget = rotate2D(target, starRotation);
    PVector goal = PVector.add(center, rotatedTarget);

    if (globalState == 0) {

      PVector dir = PVector.sub(goal, pos);
      float d = dir.mag();

      dir.normalize();
      float speed = map(d, 0, width, 0.015, 0.35);
      dir.mult(speed);

      vel.lerp(dir, 0.006);
      vel.add(PVector.random2D().mult(0.006));

      pos.add(vel);
    }

    else if (globalState == 1) {
      pos.lerp(goal, 0.018);
    }

    else if (globalState == 2) {
      pos.y -= 0.1;
    }

    else if (globalState == 3) {
      if (vel.mag() < 0.5) {
        vel = PVector.random2D().mult(random(1.5, 4.0));
      }
      pos.add(vel);
      vel.mult(0.97);
    }

    else if (globalState == 4) {
      vel.y += 0.04;
      vel.x += sin(frameCount * 0.015 + pos.x * 0.01) * 0.02;
      pos.add(vel);
    }
  }

  void display() {
    if (!active) return;
    noStroke();
    fill(c);
    ellipse(pos.x, pos.y, size, size);
  }
}

/* ===============================
   ⭐ 五角星随机点
   =============================== */

PVector randomPointInStar(float outerR, float innerR) {

  while (true) {
    float x = random(-outerR, outerR);
    float y = random(-outerR, outerR);

    if (pointInStar(x, y, outerR, innerR)) {
      return new PVector(x, y);
    }
  }
}

boolean pointInStar(float x, float y, float R, float r) {

  float angle = atan2(y, x);
  float d = sqrt(x*x + y*y);

  float a = (angle + PI) % (TWO_PI / 5);
  float limit = lerp(R, r, abs(a - PI/5) / (PI/5));

  return d < limit;
}

/* ===============================
   🔄 2D 向量旋转
   =============================== */

PVector rotate2D(PVector v, float a) {
  float ca = cos(a);
  float sa = sin(a);
  return new PVector(
    v.x * ca - v.y * sa,
    v.x * sa + v.y * ca
  );
}
