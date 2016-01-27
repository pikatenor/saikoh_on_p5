import http.requests.*;
import wsp5.*;

WsClient client;

String wsurl = "ws://saikoh.osyoyu.com/";
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
  background(255);
  size(400, 400);
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
}

void onWsMessage(String wsmessage){
  // JSONArray jsonarray = JSONArray.parse(message);
  // for(int i=0; i<jsonarray.size(); i++){
  //   JSONObject jsonobject = jsonarray.getJSONObject(i);
  //   int count = jsonobject.getInt("count");
  //   int current = skcounts.get(i);
  //   if (current < count){
  //     // update counts
  //     skcounts.set(i, count);
  //     // invoke onNanika
  //     invokeSkEvents(i);
  //   }
  // }
  JSONObject message = JSONObject.parse(wsmessage);
  String type = message.getString("type");

  if(type.equals("counters")){
    JSONArray counters = message.getJSONArray("counters");
    for(int i=0; i<counters.size(); i++){
      JSONObject counter = counters.getJSONObject(i);
      if(counter.getString("counter_name").equals("saikoh")){
        skCount = counter.getInt("counter_value");
        println(skCount);
      }
    }
  }else if(type.equals("changed")){
    String name = message.getString("counter_name");
    if(name.equals("saikoh")){
      int updatedSkCount = message.getInt("counter_value");
      println(updatedSkCount);
      if(skCount < updatedSkCount){
        onSaikoh();
      }
      skCount = updatedSkCount;
    }
  }else{
    println(message);
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

