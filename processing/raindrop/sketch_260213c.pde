ArrayList<Ripple> ripples;
float t = 0;

void setup() {
  size(900, 600);
  smooth(8);
  ripples = new ArrayList<Ripple>();
  background(0);
}

void draw() {
  // 纯黑背景
  background(0);
  
  drawWaterSurface();
  
  // 随机生成雨滴
  if (random(1) < 0.04) {
    ripples.add(new Ripple(random(width), random(height)));
  }

  // 更新和绘制涟漪
  for (int i = ripples.size()-1; i >= 0; i--) {
    Ripple r = ripples.get(i);
    r.update();
    r.display();
    if (r.isFinished()) {
      ripples.remove(i);
    }
  }

  t += 0.01;
}

// --------------------
// 水面缓慢暗波（在黑色上叠加透明层）
// --------------------
void drawWaterSurface() {
  noStroke();
  
  for (int i = 0; i < 8; i++) {
    float yOffset = noise(i * 100, t) * height;
    float alpha = 10;
    fill(20, 40, 80, alpha);
    ellipse(width/2, yOffset, width * 1.5, 200);
  }
}

// --------------------
// 涟漪类
// --------------------
class Ripple {
  float x, y;
  float radius;
  float alpha;
  float growth;
  float dropSize;
  float bounceOffset = 0;
  float bounceSpeed = 0.2;
  float life = 0;

  Ripple(float x_, float y_) {
    x = x_;
    y = y_;
    radius = 0;
    alpha = 150;
    growth = random(1.5, 2.5);
    dropSize = random(3, 6);
  }

  void update() {
    radius += growth;
    alpha -= 1.2;
    
    life += 0.05;
    
    // 水滴跳动效果（渐弱）
    bounceOffset = sin(life * 5) * 4 * exp(-life * 0.5);
    
    // 水滴慢慢变大
    dropSize += 0.02;
  }

  void display() {
    noFill();
    stroke(180, 200, 255, alpha);
    strokeWeight(1.5);
    ellipse(x, y, radius * 2, radius * 2);
    
    // 水滴
    noStroke();
    fill(180, 200, 255, alpha);
    ellipse(x, y + bounceOffset, dropSize, dropSize);
  }

  boolean isFinished() {
    return alpha <= 0;
  }
}
