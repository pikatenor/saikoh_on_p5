import http.requests.*;
import wsp5.*;

WsClient client;
IntList skcounts;
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

void setup(){
  // saikoh.tkとのWebSocket通信の確立
  try {
    client = new WsClient(this, "ws://saikoh.tk/ws/values");
    client.connect();
  }catch(Exception e){
    println(e);
    exit();
  }

  // saikoh values の初期値を取得
  // 0: saikoh, 1: emoi, 2: itf, 3: wtc
  skcounts = new IntList();
  GetRequest request = new GetRequest("http://saikoh.tk/values");
  try{
    request.send();
  }catch(Exception e){
    println(e);
    exit();
  }
  String response = request.getContent();
  JSONArray jsonarray = JSONArray.parse(response);
  for(int i=0;i<4;i++){
    JSONObject jsonobject = jsonarray.getJSONObject(i);
    int count = jsonobject.getInt("count");
    skcounts.append(count);
  }
  println(skcounts);

  // キャンバスの初期化など
  background(255);
  size(400, 400);
  imageMode(CENTER);
  frameRate(30);
}

void onSaikoh(){
  // 最高
  println("saikoh");
  images.add(new SkImage(0));
}

void onEmoi(){
  // エモい
  println("emoi");
  images.add(new SkImage(1));
}

void onITF(){
  // IMAGINE THE FUTURE.
  println("itf");
  images.add(new SkImage(2));
}

void onWTC(){
  // We Are the Champions
  println("wtc");
  images.add(new SkImage(3));
}

void invokeSkEvents(int id){
  switch(id){
    case 0:
      onSaikoh();
      break;
    case 1:
      onEmoi();
      break;
    case 2:
      onITF();
      break;
    case 3:
      onWTC();
      break;
  }
}

void onWsOpen(){
}

void onWsMessage( String message ){
  JSONArray jsonarray = JSONArray.parse(message);
  for(int i=0;i<4;i++){
    JSONObject jsonobject = jsonarray.getJSONObject(i);
    int count = jsonobject.getInt("count");
    int current = skcounts.get(i);
    if (current < count){
      // update counts
      skcounts.set(i, count);
      // invoke onNanika
      invokeSkEvents(i);
    }
  }
}

void onWsClose(){
}

void draw(){
  clear();
  background(255);

  for(int i=0; i<images.size(); i++){
    SkImage zoom = images.get(i);
    zoom.display();
    if(zoom.is_finished()){
      images.remove(i);
    }
  }
}

void mouseClicked(){
  // images.add(new SkImage(0));
}
