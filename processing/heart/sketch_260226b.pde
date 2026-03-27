ArrayList<Particle> particles = new ArrayList<Particle>();

float beatTimer = 0;
float beatInterval = 1.2;
float beatDuration = 0.25;
float lastTime;

// 消散控制
float dissolveTimer = 0;
float dissolveInterval = 8.0;   // 每 8 秒消散一次
float dissolveDuration = 3.0;   // 消散持续时间
boolean dissolving = false;

void setup() {
  size(800, 800);
  smooth(8);
  lastTime = millis() / 1000.0;

  // 生成心形粒子
  for (float a = 0; a < TWO_PI; a += 0.07) {
    float x = 16 * pow(sin(a), 3);
    float y = -(13 * cos(a) - 5 * cos(2*a) - 2 * cos(3*a) - cos(4*a));
    particles.add(new Particle(x * 12, y * 12));
  }
}

void draw() {
  float currentTime = millis() / 1000.0;
  float deltaTime = currentTime - lastTime;
  lastTime = currentTime;

  beatTimer += deltaTime;
  dissolveTimer += deltaTime;

  // 背景呼吸
  float breathing = sin(currentTime * 0.4) * 0.5 + 0.5;
  background(map(breathing, 0, 1, 5, 18));

  // 心跳
  float beatStrength = 0;
  if (beatTimer < beatDuration) {
    beatStrength = sin((beatTimer / beatDuration) * PI);
  }
  if (beatTimer > beatInterval) beatTimer = 0;

  // 触发消散
  if (dissolveTimer > dissolveInterval) {
    dissolving = true;
  }
  if (dissolveTimer > dissolveInterval + dissolveDuration) {
    dissolving = false;
    dissolveTimer = 0;
    for (Particle p : particles) {
      p.reset();
    }
  }

  translate(width/2, height/2);

  // 心跳轻微抖动
  float shake = beatStrength * 4;
  translate(random(-shake, shake), random(-shake, shake));

  for (Particle p : particles) {
    p.update(beatStrength, dissolving);
    p.display(dissolving);
  }
}

// ----------------------
// 粒子类
// ----------------------
class Particle {
  PVector basePos;
  PVector pos;
  PVector vel;
  float alpha;

  Particle(float x, float y) {
    basePos = new PVector(x, y);
    pos = basePos.copy();
    vel = PVector.random2D().mult(random(0.2));
    alpha = 255;
  }

  void reset() {
    pos = basePos.copy();
    vel.mult(0);
    alpha = 255;
  }

  void update(float beat, boolean dissolving) {
    if (dissolving) {
      // 消散：慢慢漂走 + 变暗
      vel.add(PVector.random2D().mult(0.05));
      pos.add(vel);
      alpha -= 1.5;
      alpha = max(alpha, 0);
    } else {
      // 心跳外扩
      PVector dir = pos.copy().normalize();
      vel.add(dir.mult(beat * 0.4));

      // 回归心形
      PVector back = PVector.sub(basePos, pos);
      vel.add(back.mult(0.04));

      vel.mult(0.85);
      pos.add(vel);
      alpha = lerp(alpha, 200 + beat * 55, 0.05);
    }
  }

  void display(boolean dissolving) {
    noStroke();
    fill(255, alpha);
    float size = dissolving ? 1.8 : 2.5;
    ellipse(pos.x, pos.y, size, size);
  }
}
