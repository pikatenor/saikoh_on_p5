ArrayList<SkImage> images = new ArrayList<SkImage>();

class SkImage{
  int size;
  int opacity;
  float zoomSpeed;
  float fadeSpeed;
  PImage img;

  SkImage(int i){
    switch(i){
      case(0):
        img = loadImage("img/saikoh.png");
        zoomSpeed = 30;
        fadeSpeed = 10;
        break;
      case(1):
        img = loadImage("img/emoi.png");
        zoomSpeed = 30;
        fadeSpeed = 10;
        break;
      case(2):
        img = loadImage("img/itf.png");
        zoomSpeed = 1.2;
        fadeSpeed = 0.5;
        break;
      case(3):
        img = loadImage("img/wtc.png");
        zoomSpeed = 1;
        fadeSpeed = 0.3;
        break;
    }
    size = 100;
    opacity = 200;
  }

  void display(){
    tint(255, opacity);
    image(img, width/2, height/2, size, size);
    size += zoomSpeed;
    opacity -= fadeSpeed;
  }

  boolean is_finished(){
    if(opacity < 0){
      return true;
    }else{
      return false;
    }
  }
}

void addImage(int id){
  int limit = 20;
  if(images.size() < limit){
    images.add(new SkImage(id));
  }else{
    images.remove(0);
    println("limit exceeded. killing last 1 image.");
  }
  println("remaining images: " + images.size());
}
