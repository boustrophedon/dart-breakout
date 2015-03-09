part of breakout_server;

class ServerNetworkSystem extends System {
  ServerNetworkSystem(BreakoutServerWorld world) : super(world) {
    components_wanted = null;
  }

  // code adapted from http://jamesslocum.com/post/74731227156
  void initialize() {
    HttpServer.bind(InternetAddress.ANY_IP_V4, 5634).then((HttpServer server) {
      print("HttpServer listening...");
      server.serverHeader = "SimpleMOBA server";
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
  }

  void handle_web_socket(WebSocket socket) {
    print('Client connected!');
    socket.listen((String s) {
      print('Client sent: $s');
    },
    onDone: () {
      print('Client disconnected');  
    });
  }

  void serveRequest(HttpRequest request){
    request.response.statusCode = HttpStatus.FORBIDDEN;
    request.response.reasonPhrase = "WebSocket connections only";
    request.response.close();
  }

  void process_entity(Entity entity) {
  }
  void remove_entity(Entity e) {}
}
