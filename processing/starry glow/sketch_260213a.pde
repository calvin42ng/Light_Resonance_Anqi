// Pure Abstract White Galaxy
// Processing 3 / 4 compatible
// No stage, no beams, no center glow

int starCount = 160;
int sparkleCount = 55;

Star[] stars;
Sparkle[] sparkles;

float t = 0;

void setup() {
  size(1000, 650, P2D);
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
  background(0);

  stars = new Star[starCount];
  for (int i = 0; i < starCount; i++) {
    stars[i] = new Star();
  }

  sparkles = new Sparkle[sparkleCount];
  for (int i = 0; i < sparkleCount; i++) {
    sparkles[i] = new Sparkle();
  }
}

void draw() {

  // 深色背景 + 残影
  fill(0, 0, 4, 18);
  rect(0, 0, width, height);

  blendMode(ADD);

  // 柔和白色星云
  for (int i = 0; i < 4; i++) {
    float x = noise(i * 60, t * 0.06) * width;
    float y = noise(i * 70, t * 0.06 + 200) * height;
    float r = 200 + sin(t + i) * 30;
    float bright = 45 + i * 6;

    fill(0, 0, bright, 7);
    ellipse(x, y, r, r);
  }

  // 星尘
  for (Star s : stars) {
    s.update();
    s.display();
  }

  // 四角星闪烁
  for (Sparkle sp : sparkles) {
    sp.update();
    sp.display();
  }

  blendMode(BLEND);
  t += 0.013;
}

// ================= 星尘 =================
class Star {
  float x, y;
  float speed;
  float size;
  float bright;

  Star() {
    x = random(width);
    y = random(height);
    speed = random(0.12, 0.5);
    size = random(1, 2);
    bright = random(50, 90);
  }

  void update() {
    y += speed;
    if (y > height) {
      y = 0;
      x = random(width);
    }
  }

  void display() {
    fill(0, 0, bright, 50);
    ellipse(x, y, size, size);
  }
}

// ================= 四角星 =================
class Sparkle {
  float x, y;
  float size;
  float phase;
  float bright;

  Sparkle() {
    reset();
  }

  void reset() {
    x = random(width);
    y = random(height);
    size = random(6, 9);
    phase = random(TWO_PI);
    bright = random(70, 100);
  }

  void update() {
    phase += 0.04;
    if (random(1) < 0.0015) {
      reset();
    }
  }

  void display() {
    float alpha = map(sin(phase), -1, 1, 5, 40);
    fill(0, 0, bright, alpha);

    // 竖线
    rect(x - size * 0.1, y - size, size * 0.2, size * 2);
    // 横线
    rect(x - size, y - size * 0.1, size * 2, size * 0.2);
  }
}
