import ddf.minim.*;

Minim minim;
AudioInput in;

int width = 800;
int height = 600;

ArrayList<Drop> drops;
ArrayList<Cloud> clouds;

Lightning j;


boolean mode = true;

Drop drop;
Cloud cloud;
Lightning lightning;

void setup() {
  size(width, height);
  if (frame != null) {
    frame.setResizable(true);
  }
  smooth();
  background(0,0,0);
  drops = new ArrayList<Drop>();
  clouds = new ArrayList<Cloud>();
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  j = new Lightning();
}

boolean sketchFullScreen() {
  return true;
}

void draw() {
  fill(95,115,150,100);
  noStroke();
  rect(0,0,frame.getWidth(),frame.getHeight());
  
  int num = int(in.mix.level()*100);
  boolean vol = false;
  
  print(num+"\n");
  
  if(vol == false){
    j = new Lightning();
    if(num > 40 && num < 50){
        j.strike();
      }
    if(num > 50 && num < 60){
    j.flash();
    vol = true;
      }
  }
  
  if (num < 1){
    vol = false;
  }
  
  fill(75,50,35);
  rect(frame.getWidth()/4,frame.getHeight()/1.5,50,1000);
  fill(50,125,100);
  ellipse(frame.getWidth()/4+25,frame.getHeight()/1.5,200,100);
  
  if(int(random(75)) == 50){
    clouds.add(new Cloud(-250));
  }
  
  for (int i = 0; i < num; i++){
    drops.add(new Drop());
  }
  Iterator<Drop> it = drops.iterator();
  while (it.hasNext()) {
    Drop d = it.next();
    d.display();
    d.update();
    if (d.goAway()){
      it.remove();
  }
}

  Iterator<Cloud> ct = clouds.iterator();
    
  while (ct.hasNext()) {
    Cloud c = ct.next();
    c.display();
    c.update();
    if (c.goAway()){
      ct.remove();
  }
  }


  fill(50,125,100);
  stroke(50,125,100);
  ellipse(frame.getWidth()/3,frame.getHeight(),frame.getWidth(),frame.getHeight()/4);
  ellipse(frame.getWidth(),frame.getHeight(),frame.getWidth(),frame.getHeight()/4);
}

class Lightning {
  float topX;
  float bottomX;
  boolean strike;
  int i;
  Lightning(){
    topX = random(0,frame.getWidth());
    bottomX = random(topX-50,topX+50);
    i = 0;
  }
  
  void strike(){
     stroke(255,255,200);
     strokeWeight(10); 
     line(topX,0,bottomX,frame.getHeight());
     i = i+1;
  }
  
  void flash(){
    fill(255,255,200);
  stroke(255,255,200);
  rect(0,0,frame.getWidth(),frame.getHeight());
  i = i+1;
  }
  
  void go(){
    if(i < 2){
      strike();
    }
    else if(i < 5){
      flash();
    }
}
}


class Cloud {
  float x;
  float y;
  float rate;
  boolean offScreen = false;
  float w;
  float h;
  float fWidth;
  Cloud(int start){
    x = start;
    y = random(0,50);
    
    rate = random(.5,1);
    w = random(100,500);
    h = random(50,100);
  }
  
  void display(){
    fWidth = frame.getWidth();
    
     fill(200,200,200,150);
      noStroke();
      ellipse(x,y,w,h);
  }
  
  void update(){
    x = x+rate;
    
    if (y+(w/2) > fWidth){
      offScreen = true;
     }
    }
    
  boolean goAway(){
     return offScreen;
   }
}

class Drop {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector gravity;
  PVector direction;
  float x;
  float y;
  float startS = 5.0;
  float endS = 65.0;
  float s;
  float rate;
  boolean atBottom = false;
  float fWidth;
  float fHeight;
  Drop(){
    fWidth = frame.getWidth();
    fHeight = frame.getHeight();

    x = random(fWidth);
    y = 0;

    location = new PVector(x,y);
    velocity = new PVector(0,0);
    PVector gravity = new PVector(x,fHeight);
    PVector direction = PVector.sub(gravity,location);
    direction.normalize();

    acceleration = direction;
  }
  
  void display(){

     stroke(150,200,250);
     strokeWeight(3); 
     line(location.x,location.y-5,location.x,location.y+5);
     
     if (location.y > fHeight){
      atBottom = true;
     }

  }
  
  void update(){
    velocity.add(acceleration);
    velocity.limit(random(5,25));
    location.add(velocity);
    }

   boolean goAway(){
     return atBottom;
   }
}

void stop(){
  in.close();
  minim.stop();
  super.stop();
}
