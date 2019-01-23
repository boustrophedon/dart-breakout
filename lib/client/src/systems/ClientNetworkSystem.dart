part of breakout_client;

class ClientNetworkSystem extends System {
  //String server = 'ws://104.236.127.223:5634/';
  String server = 'ws://localhost:5634/';
  WebSocket ws;
  ClientNetworkSystem(BreakoutClientWorld world) : super(world) {
    components_wanted = null;
  }
  // network code adapted from http://jamesslocum.com/post/74731227156
  void initialize() {

    init_websocket();

    for (String event_type in client_transmit) {
      world.subscribe_event(event_type, transmit_event);
    }

    world.subscribe_event("ServerConnected", handle_connect);
    world.subscribe_event("ConnectionAck", handle_ack);
  }

  void init_websocket() {
    ws = new WebSocket(server);
    ws.onOpen.listen((e) {print("connected to server");world.send_event("ServerConnected", <String, Object>{});});
    ws.onMessage.listen(handle_data);
    ws.onClose.listen((e) => print("connection to server lost"));
  }

  void handle_connect(Map event) {
    world.send_event("RequestNewPlayer", <String, Object>{});
  }

  void handle_ack(Map event) {
    world.client_id = event['client_id'];
    print("got ack");
  }

  void handle_data(MessageEvent event) {
    var msg = json.decode(event.data);
    //print(json);
    world.send_event(msg['EVENT_TYPE'], msg);
  }

  void transmit_event(Map event) {
    ws.send(json.encode(event));
  }

  void process_entity(int entity) {}
  void remove_entity(int entity) {}
}
