import http.requests.*;
import wsp5.*;

WsClient client;
IntList skcounts;

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
  for(int i=0; i<jsonarray.size(); i++){
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
  addImage(0);
}

void onEmoi(){
  // エモい
  println("emoi");
  addImage(1);
}

void onITF(){
  // IMAGINE THE FUTURE.
  println("itf");
  addImage(2);
}

void onWTC(){
  // We Are the Champions
  println("wtc");
  addImage(3);
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
  for(int i=0; i<jsonarray.size(); i++){
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
