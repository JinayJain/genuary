PImage img;

color randColor(float min, float max) {
  float r = random(min, max);
  float g = random(min, max);
  float b = random(min, max);
  
  return color(r, g, b);
}

PImage makeDithered(PImage img) {
  PImage dithered = new PImage(img.width, img.height, RGB);
  
  color c1 = randColor(150, 230);
  color c2 = randColor(50, 80);
  
  float fac = random(3, 6);
  for(int i = 0; i < img.width; i++) {
    for(int j = 0; j < img.height; j++) {
      float x = red(img.get(i, j)) / 255.;
      
      if(pow(x, fac) > random(1)) {
        dithered.set(i, j, c1); 
      } else {
        dithered.set(i, j, c2);
      }
    }
  }
  
  return dithered;
}

void setup() {
  size(2400, 800);
  
  img = loadImage("bridge.jpg");
  img.resize(height, 0);
  
  
  
  background(0);
  

  int offset = -200;

  image(makeDithered(img), 0, offset);
  image(makeDithered(img), width / 3, offset);
  image(makeDithered(img), 2 * width / 3, offset);
  
  save("output.png");
}

void draw() {}
