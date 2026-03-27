ArrayList<Particle> particles;

void setup() {
  size(800, 600);
  particles = new ArrayList<Particle>();
  for (int i = 0; i < 200; i++) {
    particles.add(new Particle());
  }
}

void draw() {
  background(15, 15, 20);

  for (Particle p : particles) {
    p.update();
    p.display();
  }
}

class Particle {
  PVector pos, vel;

  Particle() {
    pos = new PVector(random(width), random(height));
    vel = PVector.random2D().mult(random(0.2, 1));
  }

  void update() {
    pos.add(vel);
    vel.add(PVector.random2D().mult(0.05));
    vel.limit(1);

    wrap();
  }

  void display() {
    noStroke();
    fill(180, 150);
    ellipse(pos.x, pos.y, 3, 3);
  }

  void wrap() {
    if (pos.x < 0) pos.x = width;
    if (pos.x > width) pos.x = 0;
    if (pos.y < 0) pos.y = height;
    if (pos.y > height) pos.y = 0;
  }
}
