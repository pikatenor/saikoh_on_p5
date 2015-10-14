import http.requests.*;
import wsp5.*;
import processing.serial.*;
import cc.arduino.*;
import ddf.minim.*;

Arduino arduino;
WsClient client;
IntList skcounts;
ArrayList<SkImage> images = new ArrayList<SkImage>();
GetRequest click;
boolean pin2ButtonPressed;
Minim minim;
AudioPlayer saikoh;
AudioPlayer emoi;
AudioPlayer itf;
AudioPlayer wtc;

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

  // Arduinoの初期化 listの番号がCOM番号と対応
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  arduino.pinMode(2, Arduino.INPUT);
  arduino.pinMode(3, Arduino.INPUT);

  // 最高を送信するためのオブジェクト
  click = new GetRequest("http://saikoh.tk/click/saikou");
  pin2ButtonPressed = false;

  minim = new Minim(this);
  saikoh = minim.loadFile("mp3/saikoh.mp3");
  emoi = minim.loadFile("mp3/emoi.mp3");
  itf = minim.loadFile("mp3/itf.mp3");
  wtc = minim.loadFile("mp3/wtc.mp3");
}

void onSaikoh(){
  // 最高
  println("saikoh");
  images.add(new SkImage(0));
  saikoh.play();
  saikoh.rewind();
}

void onEmoi(){
  // エモい
  println("emoi");
  images.add(new SkImage(1));
  emoi.play();
}

void onITF(){
  // IMAGINE THE FUTURE.
  println("itf");
  images.add(new SkImage(2));
  itf.play();
}

void onWTC(){
  // We Are the Champions
  println("wtc");
  images.add(new SkImage(3));
  wtc.play();
}

void invokeSkEvents(int id){
  if(images.size() < 20){
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
  }else{
    images.remove(0);
    println("limit exceeded. kill last 1 image.");
  }
  println("remaining images: " + images.size());
}

void onWsOpen(){
  println("WebSocket connection opened");
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
  println("WebSocket connection closed!");
  try{
    client = new WsClient(this, "ws://saikoh.tk/ws/values");
    client.connect();
  }catch(Exception e){
    println(e);
    println("!!!reconnection failed!!!");
  }
}

void draw(){
  clear();
  background(255);

  // images内のSkImageを描画する処理
  for(int i=0; i<images.size(); i++){
    SkImage zoom = images.get(i);
    zoom.display();
    if(zoom.is_finished()){
      images.remove(i);
      println("play end");
      println("remaining images: " + images.size());
    }
  }


  // pin2に+5Vが入ると
  if(arduino.digitalRead(2) == Arduino.HIGH){
    pin2ButtonPressed = true;
    println("pin2+");
  }
  if(arduino.digitalRead(2) == Arduino.LOW){
    if(pin2ButtonPressed){
      pin2ButtonPressed = false;
      thread("clickSaikoh");
    }
  }
}

void stop(){
  saikoh.close();
  emoi.close();
  itf.close();
  wtc.close();
  minim.stop();
  super.stop();
}

void mouseClicked(){
  // images.add(new SkImage(0));
}

void clickSaikoh(){
  click.send();
  println("SAIKOH!!!");
}
