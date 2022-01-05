int N_STARS = 100;
float dt = 0.2;

Star[] stars;

// scanner line
float lineAngle = 0;
float lineLength;
float dL = 0.06;

int t = 0;

void setup() {
  size(800, 800);

  stars = new Star[N_STARS];
  lineLength = width / 2;
  
  for(int i = 0; i < N_STARS; i++) {
    stars[i] = new Star();
  }
}

void draw() {
  background(#10061c);
  translate(width / 2, height / 2);
  ellipseMode(RADIUS);
  
  
  noFill();
  stroke(255);
  strokeWeight(1);
  ellipse(0, 0, width / 2, height / 2);  
  
  drawScanner();
  
  for(Star s : stars) {
    if(abs(s.theta - lineAngle) <= dL) s.ping();
    
    s.step(dt);
    s.show();
  }
  
  lineAngle += dL;
  t++;
  if(lineAngle >= TWO_PI) lineAngle -= TWO_PI;
  
  saveFrame("frames/#####.png");
}

void drawScanner() {
  pushMatrix();
  strokeWeight(3);
  rotate(lineAngle);
  line(0, 0, lineLength, 0);
  popMatrix();
}
