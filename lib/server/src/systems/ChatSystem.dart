part of breakout_server;

class ChatSystem extends System {
  int MAXLENGTH = 140;
  ChatSystem(BreakoutServerWorld world) : super(world) {
    components_wanted = null;
  }

  void initialize() {
    world.subscribe_event("ClientChatMessage", handle_message);
  }

  String sanitize_message(String s) {
    // XXX i dunno. do stuff?
    if (s.length > MAXLENGTH) {
      return s.substring(0, MAXLENGTH);
    }
    else {
      return s;
    }
  }

  void handle_message(Map event) {
    int player_id = event['client_id'];
    world.send_event("ServerChatMessage", <String, Object>{"message":"Player ${player_id}: "+sanitize_message(event['message'])});
  }
}
