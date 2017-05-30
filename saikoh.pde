import http.requests.*;
import wsp5.*;

WsClient client;

String wsurl = "ws://saikoh.tk/api/websocket";
// String wsurl = "ws://saikoh.osyoyu.com/api/feed";
PImage saikoh_img;

int skCount;

void setup(){
  // saikoh.tkとのWebSocket通信の確立
  try {
    client = new WsClient(this, wsurl);
    client.connect();
  }catch(Exception e){
    println(e);
    exit();
  }

  // キャンバスの初期化など
  background(0);
  // fullScreen(P2D, 0);
  size(800, 800, P2D);
  imageMode(CENTER);
  frameRate(60);

  saikoh_img = loadImage("img/saikoh.png");
}

void onSaikoh(){
  // 最高
  println("saikoh");
  addImage();
}

void onWsOpen(){
  println("WebSocket connection opened.");
}

void onWsMessage(String wsmessage){
  JSONObject message = JSONObject.parse(wsmessage);
  String type = message.getString("type");

if(type.equals("update")){
  onSaikoh();
  }else{
    println(message);
  }
}

void onWsClose(){
  println("WebSocket connection closed!");
  try {
    println("Trying to reconnect...");
    client = new WsClient(this, wsurl);
    client.connect();
  }catch(Exception e){
    println("!!! Reconnection failed !!!");
    println(e);
  }
}

void draw(){
  background(0);

  for(int i=0; i<images.size(); i++){
    SkImage zoom = images.get(i);
    zoom.display();
    if(zoom.is_finished()){
      images.remove(i);
    }
  }
}

