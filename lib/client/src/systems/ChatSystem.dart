part of breakout_client;

class ChatSystem extends System {
  TextInputElement input;
  ChatSystem(BreakoutClientWorld world) : super(world) {
    components_wanted = null;
  }

  void initialize() {
    input = querySelector("#chatinput");
    world.subscribe_event("OpenChat", handle_openchat);
    world.subscribe_event("CloseChat", handle_closechat);

    world.subscribe_event("SendChatMessage", handle_sendchat);

    world.subscribe_event("ServerChatMessage", handle_message);
  }

  void handle_openchat(Map event) {
    input.focus();
  }
  // CloseChat here? inputsystem can't ever send closechat when we're typing because the only time it would want to is when it's muted
  void handle_sendchat(Map event) {
    world.send_event("ClientChatMessage", <String, Object>{'message':input.value});
    input.value = '';
  }
  void handle_closechat(Map event) {
    input.value = '';
    input.blur();
    world.canvas.focus(); // this isn't actually necessary
  }

  void handle_message(Map event) {
    for (int i = 1; i < world.chat_messages.length; i++) {
      world.chat_messages[i-1] = world.chat_messages[i];
    } 
    world.chat_messages[world.chat_messages.length-1] = event['message'];
  }
}
