part of breakout_server;

class ServerNetworkSystem extends System {
  HashMap<int, WebSocket> clients;
  int client_id = 1;
  ServerNetworkSystem(World world) : super(world) {
    clients = new HashMap<int, WebSocket>();
    world.globaldata['Clients'] = clients;
    components_wanted = null;
  }

  // code adapted from http://jamesslocum.com/post/74731227156
  void initialize() {
    HttpServer.bind(InternetAddress.ANY_IP_V4, 5634).then((HttpServer server) {
      print("HttpServer listening...");
      server.serverHeader = "Test server";
      server.listen((HttpRequest request) {
        if (WebSocketTransformer.isUpgradeRequest(request)){
          WebSocketTransformer.upgrade(request).then(handle_web_socket);
        }
        else {
          print("Regular ${request.method} request for: ${request.uri.path}");
          serveRequest(request);
        }
      });
    });

    for (String event_type in server_transmit) {
      world.subscribe_event(event_type, transmit_event);
    }
  }

  void handle_web_socket(WebSocket socket) {
    socket.add(JSON.encode({'EVENT_TYPE':"ConnectionAck", "client_id":client_id}));
    print('Client $client_id connected!');
    socket.listen(do_client_receive_data(client_id),
      onDone: do_client_disconnect(client_id)
    );
    clients[client_id] = socket;
    client_id++;
  }
  void serveRequest(HttpRequest request){
    request.response.statusCode = HttpStatus.FORBIDDEN;
    request.response.reasonPhrase = "WebSocket connections only";
    request.response.close();
  }

  Function do_client_receive_data(int id) {
    void receive_data(String data) {
      var json = JSON.decode(data);
      // this is insecure/could cause a crash
      // in general very little of the data being recieved over the network is checked for validity
      // and that is bad
      if (server_transmit.contains(json['EVENT_TYPE'])) {
        print('received event from client in server transmit list');
        return;
      }
      json['client_id'] = id;
      //print(json);
      world.send_event(json['EVENT_TYPE'], json);
    }
    return receive_data;
  }

  Function do_client_disconnect(int id) {
    void client_disconnect() {
      print("Client $id disconnected");
      world.send_event("ClientDisconnected", {"client_id":id});
      clients.remove(id);
    }
    return client_disconnect;
  }

  void transmit_event(Map event) {
    if (event['Clients'] == null) {
      sendAll(event);
    }
    else {
      for (int client in event['Clients']) {
        send(client, event);
      }
    }
  }

  void sendAll(Map event) {
    var json = JSON.encode(event);
    for (WebSocket socket in clients.values) {
      socket.add(json);
    }
  }
  void send(int client, Map event) {
    clients[client].add(JSON.encode(event));
  }

  void process_entity(int entity) {}
  void remove_entity(int entity) {}
}
