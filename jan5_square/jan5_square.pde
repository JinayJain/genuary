PGraphics canvas;
PGraphics buffer;

float squareSize = 400;

int TIMER_MAX = 100;
int timer = TIMER_MAX;

float speed = 2;

int y1, y2, xOffset, yOffset;
int finalX;

color BACKGROUND = color(20);

void setup() {
  size(800,800);
  canvas = createGraphics(width, height);
  buffer = createGraphics(width, height);

  canvas.beginDraw();
  canvas.rectMode(CENTER);
  canvas.fill(255);
  canvas.noStroke();
  canvas.rect(width/2,height/2,squareSize,squareSize);
  canvas.rectMode(CORNER);
  canvas.endDraw();
  
  xOffset = int(width/2-squareSize/2);
  yOffset = int(height/2-squareSize/2);
  
  
  cropRandom();
}


void cropRandom() {
  buffer.beginDraw();
  buffer.clear();
  
  // copy a random slice from the canvas to buffer
  int MIN_H = 100;
  y1 = int(random(squareSize - MIN_H));
  int h = (int)random(MIN_H, squareSize - y1 + 1);
  y2 = (int)(y1+h);
  
  if(y1 > y2) {
    int tmp = y1;
    y1 = y2;
    y2 = tmp;
  }
  
  PImage img = canvas.get();
  buffer.copy(img, 0, yOffset + y1, width, y2 - y1, 0, 0, width, y2 - y1);
  
  finalX = (int)random(-100, 100);
  if(finalX == 0) finalX = 1;
  TIMER_MAX = int((float)abs(finalX) / speed);
  timer = TIMER_MAX;
  
  buffer.endDraw();
  canvas.beginDraw();
  canvas.fill(BACKGROUND);
  canvas.rect(0, yOffset + y1, width, y2 - y1);
  canvas.endDraw();
}

void finalize() {
  canvas.beginDraw();
  PImage img = buffer.get();
  canvas.copy(img, 0, 0, width, y2 - y1, finalX, yOffset + y1, width, y2 - y1);
  canvas.endDraw();
}

void draw() {
  background(BACKGROUND);
  image(canvas, 0, 0);
  // draw in lerped position
  int lerpedX = (int)map(timer, 0, TIMER_MAX, finalX, 0);
  image(buffer, lerpedX, yOffset + y1);
  if(timer <= 0) { 
    finalize();
    cropRandom();
  } else timer--;
}
