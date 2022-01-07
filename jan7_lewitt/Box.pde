

float[][] cube = {
  { 0, 0, 0, 0, 0, 0 },
  { 0, 0, 1, 0, 0, 0 },
  { 0, 0, 0, PI/2, 0, 0 },
  { 0, 1, 0, PI/2, 0, 0 },
  { 0, 0, 0, 0, -PI/2, 0 },
  { 1, 0, 0, 0, -PI/2, 0 },
};


class Box {
  color[] colors;
  int size;
  PVector pos;
   
  Box(int size, int x, int y, int z, color[] colors) {
    this.colors = colors; 
    this.size = size;
    this.pos = new PVector(x, y, z);
  }
 
  void show() {
    pushMatrix();
    noFill();
    translate(pos.x, pos.y, pos.z);
    translate(-size/2,-size/2,-size/2);
    noStroke();
    
    for(int i = 0; i < cube.length; i++) {
      float[] f = cube[i];
      fill(colors[i]);
      drawSquare(size, f[0] * size, f[1] * size, f[2] * size, f[3], f[4], f[5]);
    }
    
    popMatrix();
  }
}
