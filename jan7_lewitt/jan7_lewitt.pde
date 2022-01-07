float xRot = 0, yRot = 0, zRot = 0;

color[] palette = {
  #2424ed,
  #e81313,
  #13e821,
  #f7f00f,
  #3de6f2,
  #f7d136,
  #bc22f0,
  #ed3e67,
  #3eeded,
};

Box[] boxes;
int numBoxes = 100;
int size = 100;
int ax = 0, ay = 0, az = 0;



void setup() {
  size(1200, 800, P3D);
  
  boxes = new Box[numBoxes];
  regen();
 
}

int rs() {
  boolean r = random(1) > 0.5;
  return r ? -1 : 1;
}

void keyPressed() {
  if(key == 's') {
    save(str(random(5000)) + ".png"); 
  } else if(key == 'r') regen();
}

void regen() { 
  
  int x = 0;
  int y = 0;
  int z = 0;

  for(int i = 0; i < numBoxes; i++) {
    color[] colors = new color[6];
    for(int j = 0; j < 6; j++) {
      colors[j] = pickRand();
    }
    println(colors);
    boxes[i] = new Box(size, x, y, z, colors);
    
    int dir = int(random(3));
    
    switch(dir) {
      case 0:
        x += rs() * size;
        y += rs() * size;
        break;
      case 1:
        x += rs() * size;
        z += rs() * size;
        break;
      case 2:
        y += rs() * size;
        z += rs() * size;
        break;
    }
    
    ax += x;
    ay += y;
    az += z;
  }
  
  xRot = random(TWO_PI);
  yRot = random(TWO_PI);
  zRot = random(TWO_PI);

  
}

void draw() {
  background(240);
  translate(width/2, height/2, 0);
  rotateX(xRot);
  rotateY(yRot);
  rotateZ(zRot);
  
  noStroke();
  fill(255);
  for(Box b : boxes) {
    b.show();  
  }
}



color pickRand() {
  return palette[(int) random(palette.length)]; 
}

void drawSquare(int size, float x, float y, float z, float rx, float ry, float rz) {
  pushMatrix();
  translate(x, y, z);
  rotateX(rx);
  rotateY(ry);
  rotateZ(rz);
   
  beginShape();
  vertex(0, 0, 0);
  vertex(0, size, 0);
  vertex(size, size, 0);
  vertex(size, 0, 0);
  vertex(0, 0, 0);
  endShape();
  popMatrix();  
}
