int N = 10_000;

void showItem(float x, float y, float blockSize) {
  pushMatrix();
  ellipseMode(RADIUS);
  
  float rad = blockSize / 2;
  
  float hourLen = 0.6 * rad;
  float minLen = 0.8 * rad;
  
  translate(x + rad, y + rad);
  
  noStroke();
  ellipse(0, 0, rad, rad);
  
  
  stroke(1);
  // draw hour hand
  pushMatrix();
  rotate(radians(x / width * 360));
  line(0, 0, 0, -hourLen);
  popMatrix();
  // draw minute hand
  pushMatrix();
  rotate(radians(y / height * 360));
  line(0, 0, 0, -minLen);
  popMatrix();
  
  popMatrix();
}

void setup() {
  size(5000, 5000);
  background(120);
  
  ellipseMode(CORNER);
  
  float blockSize = (float) width / (float) sqrt(N);
  
  for(int i = 0; i <= sqrt(N); i++) {
    for(int j = 0; j <= sqrt(N); j++) {
      showItem(i * blockSize, j * blockSize, blockSize);
    }
  }
  
  save("/home/jinay/Downloads/output.png");
}

void draw() {
  
}
