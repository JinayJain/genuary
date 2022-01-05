// Curves
int numCurves = 500;
int numSamples = 100;
int maxTries = 10;
float curveWeight = 5;

// Field Parameters
float resolution = 0.01;
float extraSize = 1.3;

float[][] field;
boolean[][] occupied;
color[] palette;

float realWidth, realHeight;
int rows, cols;
int blockSize;
boolean showField = true;
boolean showGrid = true;

PGraphics render;

PVector getPoint(float x, float y) {
  return new PVector(x - (realWidth - width) / 2, y - (realHeight - height) / 2);
}

PVector unscalePoint(float x, float y) {
  return new PVector(x + (realWidth - width) / 2, y + (realHeight - height) / 2);
}

int[] getCoord(float realX, float realY) {
  int row = max(min(int(realY / blockSize), rows - 1), 0);
  int col = max(min(int(realX / blockSize), cols - 1), 0);
  
  return new int[]{ row, col };
}

void setup() {
  size(800, 1200);
  background(240);

  // calculate grid parameters
  realWidth = ((float) width * extraSize);
  realHeight = ((float) height * extraSize);

  blockSize = int(float(width) * resolution);

  rows = int(realHeight) / blockSize;
  cols = int(realWidth) / blockSize;

  field = new float[rows][cols];
  occupied = new boolean[rows][cols];
  generateNoise();
  makePalette();
  render = createGraphics(width, height);
}

void fun() {
  int numLevels = int(random(1, 3)); 
  render = createGraphics(width, height);
  
  render.beginDraw();
  render.background(20);
  render.endDraw();
  generateNoise();
  for(int i = 0; i < numLevels; i++) {
    curveWeight /= 2;
    orth();
    makePalette();
    int numPts = int(random(50, 500));
    
    for(int j = 0; j < numPts; j++) {
      float x = random(realWidth);
      float y = random(realHeight);
      
      placeCurve(x, y);
    }
  }
}

void generateNoise() {
  float noiseScale = random(0.005, 0.01);
  numSamples = int(random(50, 500));
  curveWeight = random(3, 50);
  noiseSeed(int(random(50000)));
  for (int i = 0; i < rows; i++) {
     for (int j = 0; j < cols; j++) {
      field[i][j] = noise(float(i) * noiseScale, float(j) * noiseScale);
      field[i][j] = map(field[i][j], 0, 1, 0, TWO_PI);
    }
  }
}

void orth() {
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      field[i][j] += PI/2; 
    }
  }
}

void makePalette() {
  int numColors = int(random(2, 5));
  
  palette = new color[numColors];
  for(int i = 0; i < numColors; i++) {
    palette[i] = randColor();
  }
}

void keyPressed() {
  switch(key) {
    case 'r':
      generateNoise();
      break;
    case 'q':
      curveWeight += 5;
      break;
    case 'a':
      curveWeight -= 5;
      break;
    case 'c':
      render = createGraphics(width, height);
      break;
    case 'f':
      showField = !showField;
      break;
    case 'g':
      showGrid = !showGrid;
      break;
    case 'p':
      makePalette();
      break;
    case 'b':
      fun();
      break;
    case 's':
      render.save(random(5000) + ".png");
      break;
  }
}

void mousePressed() {
  PVector unscaled = unscalePoint(mouseX, mouseY);
  placeCurve(unscaled.x, unscaled.y);
}

void mouseWheel(MouseEvent event) {
  int d = event.getCount();
  numSamples -= d * 3;
}

void showGrid() {
  stroke(200);
  for(int i = 0; i < rows; i++) {
    PVector p1 = getPoint(0, i * blockSize);
    PVector p2 = getPoint(realWidth, i * blockSize);
    
    line(p1.x,p1.y,p2.x,p2.y);
  }
  for(int i = 0; i < cols; i++) {
    PVector p1 = getPoint(i * blockSize, 0);
    PVector p2 = getPoint(i * blockSize, realHeight);
    
    line(p1.x,p1.y,p2.x,p2.y);
  }
}

void showField() {
  stroke(20);
  strokeWeight(1);
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      PVector pos = getPoint(j * blockSize, i * blockSize);
      
      pushMatrix();
      translate(pos.x, pos.y);
      PVector vec = PVector.fromAngle(field[i][j]);
      vec.setMag(blockSize);
      line(0, 0, vec.x, vec.y);
      popMatrix();
    }
  }
}

void sampleCurve(float x, float y) {
  stroke(255, 0, 0);
  strokeWeight(curveWeight);
  strokeCap(PROJECT);
  noFill();
  
  PVector pos = new PVector(x, y);
  
  beginShape();
  for(int i = 0; i < numSamples; i++) {
    PVector scaled = getPoint(pos.x, pos.y);
    curveVertex(scaled.x, scaled.y);
    
    int[] coord = getCoord(pos.x, pos.y);
    PVector delta = PVector.fromAngle(field[coord[0]][coord[1]]);
    //delta.setMag(curveWeight / 5);
    pos.add(delta);
  }
  endShape();
}

color randColor() {
  float r = random(255);
  float g = random(255);
  float b = random(255);
  return color(r,g,b);
}

void placeCurve(float x, float y) {
  render.beginDraw();
  
  PGraphics r = render;
  // select a random color from palette
  int col = int(random(palette.length));
  r.stroke(palette[col]);
  
  
  r.strokeWeight(curveWeight);
  r.strokeCap(PROJECT);
  r.noFill();
  
  r.beginShape();
  PVector pos = new PVector(x, y);
  for(int i = 0; i < numSamples; i++) {
    PVector scaled = getPoint(pos.x, pos.y);
    r.curveVertex(scaled.x, scaled.y);
    
    int[] coord = getCoord(pos.x, pos.y);
    PVector delta = PVector.fromAngle(field[coord[0]][coord[1]]);
    //delta.setMag(curveWeight / 5);
    pos.add(delta);
  }
  r.endShape();
  
  render.endDraw();
}

void draw() {
  background(240);
  if(showGrid) showGrid();
  if(showField) showField();
  image(render, 0, 0);
  
  PVector unscaled = unscalePoint(mouseX, mouseY);
  sampleCurve(unscaled.x, unscaled.y);
}
