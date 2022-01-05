float LIFETIME = 12;
float PING_TIME = 3;

class Star {
  float r;
  float theta;
  float rad = 0;
  
  
  float lastSeen;
  
  Star() {
    
    this.reset();
    lastSeen = 1e9;
  }
  
  void show() {
    if(r >= width / 2) return;
    
    float x = this.r * cos(this.theta);
    float y = this.r * sin(this.theta);
    
    noStroke();
    fill(255);
    
    // set opacity
    float age = min(lastSeen, LIFETIME);
    float opacity = map(age, 0, LIFETIME, 255, 0);
    
    fill(color(255, 255, 255, opacity));
    ellipse(x, y, this.rad, this.rad);
    
    // ping effect
    noFill();
    strokeWeight(1);
    
    float pingRad = map(min(age, PING_TIME), 0, PING_TIME, 0, 50);
    float pingOp = map(min(age, PING_TIME), 0, PING_TIME, 255, 0);
    
    stroke(255, pingOp);
    ellipse(x, y, pingRad, pingRad);
  }
  
  void ping() { 
    lastSeen = 0;
  }
  
  void step(float dt) {
    lastSeen += dt;
    this.r += 1;
    if(lastSeen >= LIFETIME) {
       this.reset();
    }
  }
  
  void reset() {
    float x = random(-width/2,width/2);
    float y = random(-height/2,height/2);

    rad = random(1,5);
    r = sqrt(sq(x) + sq(y));
    theta = atan2(y, x) + PI;
  }
}
