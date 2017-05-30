ArrayList<SkImage> images = new ArrayList<SkImage>();

class SkImage{
  int size_x;
  int size_y;
  int opacity;
  float zoomSpeed;
  float fadeSpeed;
  PImage img;

  SkImage(){
    img = saikoh_img;
    size_x = 300;
    size_y = 250;
    opacity = 200;
    zoomSpeed = 100;
    fadeSpeed = 10;
  }

  void display(){
    if(opacity < 0){
      opacity = 0;
    }
    tint(255, opacity);
    image(img, width/2, height/2, size_x, size_y);
    size_x += zoomSpeed;
    size_y += zoomSpeed;
    opacity -= fadeSpeed;
  }

  boolean is_finished(){
    if(opacity <= 0){
      return true;
    }else{
      return false;
    }
  }
}

void addImage(){
  int limit = 10;
  if(images.size() < limit){
    images.add(new SkImage());
  }else{
    images.remove(0);
    println("limit exceeded. killing last 1 image.");
  }
  println("remaining images: " + images.size());
}
