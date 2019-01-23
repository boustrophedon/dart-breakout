part of breakout_client;


class InputSystem extends System {
  CanvasElement canvas;

  static const int MOUSE_MOVE = -1;
  static const int MOUSE_DOWN = -2;
  static const int MOUSE_UP = -3;

  static const int TOUCH_MOVE = -4;
  static const int TOUCH_START = -5;
  static const int TOUCH_END = -6;

  Map<int, List<Function>> control_map;

  static Map<int, List<Function>> playing_control_map;
  static Map<int, List<Function>> typing_control_map;
  static Map<int, List<Function>> ui_control_map;

  InputSystem(BreakoutClientWorld world) : super(world) { components_wanted = null; }

  void initialize() {
    canvas = world.canvas;

    window.onKeyDown.listen(register_keydown);
    window.onKeyUp.listen(register_keyup);
    canvas.onMouseMove.listen(register_mousemove);
    canvas.onTouchStart.listen(register_touchstart);
    canvas.onTouchMove.listen(register_touchmove);
    //window.onTouchEnd.listen(register_touchend);

    playing_control_map = {
      KeyCode.LEFT: [moveLeft, stopLeft],
      KeyCode.RIGHT: [moveRight, stopRight],
      KeyCode.T: [openChat, null],
      KeyCode.M: [toggleMuteAudio, null],
      MOUSE_MOVE: [moveTo, null],
      TOUCH_START: [moveTo, null],
      TOUCH_MOVE: [moveTo, null],
    };

    typing_control_map = {
      KeyCode.ESC: [closeChat, null],
      KeyCode.ENTER: [sendChat, null],
    };

    ui_control_map = {
    };

    control_map = playing_control_map;

    // replace the window mousedown/move and touchstart/move with canvas
    // mouseup and touchend should fire regardless of where they end.
    // mouse/touch are separate so that I can have the MouseEvent and TouchEvent
    // in the parameters. it is not necessary though; I think I can just use Event or UIEvent.
    // also, need to actually add the mousemove/touchmove handlers
    //canvas.onMouseDown.listen(register_mousedown);
    //window.onMouseUp.listen(register_mouseup);

    //window.onDeviceMotion.listen(register_devicemotion);

  }

  // These methods are called immediately when a click or keydown is registered, "outside of" the gameloop

  // so it turns out the offsetLeft and offsetTop things are kind of odd but do what they say in the sense that
  // if you scroll down the page, they don't change; it's based on viewport, I guess?
  // I think/it seems you can add window.scrollX and window.scrollY if you care

  //void register_mousedown(MouseEvent e) {
  //  int x = e.client.x-canvas.offsetLeft; int y = e.client.y-canvas.offsetTop;
  //}
  //void register_mouseup(MouseEvent e) {
  //  int x = e.client.x-canvas.offsetLeft; int y = e.client.y-canvas.offsetTop;
  //}
  //void register_touchend(TouchEvent e) {
  //  e.preventDefault();
  //}
  //void register_devicemotion(DeviceMotionEvent e) {
  //  var a = e.acceleration;
  //  if (a.x != null && a.y != null && a.z != null) {
  //    num ss = math.sqrt(a.x*a.x + a.y*a.y + a.z*a.z);
  //    if (ss > 5) { // only send acceleration event if it is significant. 5 is arbitrary
  //    }
  //  }
  //}
  
  void moveTo(int x, int y) {
    int player = world.tagged_entities['player'];
    if (player != null) {
      world.send_event("MoveTo", <String, Object>{'paddle': player, 'x':x});
    }
  }

  void moveLeft() {
    int player = world.tagged_entities['player'];
    if (player != null) {
      world.send_event("MoveLeft", <String, Object>{'paddle': player});
    }
  }
  void stopLeft() {
    int player = world.tagged_entities['player'];
    if (player != null) {
      world.send_event("StopLeft", <String, Object>{'paddle': player});
    }
  }
  void moveRight() {
    int player = world.tagged_entities['player'];
    if (player != null) {
      world.send_event("MoveRight", <String, Object>{'paddle': player});
    }
  }
  void stopRight() {
    int player = world.tagged_entities['player'];
    if (player != null) {
      world.send_event("StopRight", <String, Object>{'paddle': player});
    }
  }
  void openChat() {
    world.input_mode = InputMode.Typing;
    // if i have a bunch of key events queued (somehow)
    // and one of them changes the input type (like opening chat)
    // then the keys typed after that ideally should be for chat inputs
    // so we can't wait for 1 frame delay until process() gets run below
    control_map = typing_control_map;
    world.send_event("OpenChat", <String, Object>{});
  }
  void closeChat() {
    world.input_mode = InputMode.Playing;
    control_map = playing_control_map;
    world.send_event("CloseChat", <String, Object>{});
  }
  void sendChat() {
    world.send_event("SendChatMessage", <String, Object>{});
    closeChat();
  }

  void toggleMuteAudio() {
    world.send_event("ToggleMute", <String, Object>{});
  }

  void register_keydown(KeyboardEvent e) {
    if (control_map.containsKey(e.keyCode)) {
      if (control_map[e.keyCode][0] != null) {
        control_map[e.keyCode][0]();
      }
    }
  }
  void register_keyup(KeyboardEvent e) {
    if (control_map.containsKey(e.keyCode)) {
      if (control_map[e.keyCode][1] != null) {
        control_map[e.keyCode][1]();
      }
    }
  }
  void register_mousemove(MouseEvent e) {
    int x = e.client.x-canvas.offsetLeft; int y = e.client.y-canvas.offsetTop;
    if (control_map.containsKey(MOUSE_MOVE)) {
      control_map[MOUSE_MOVE][0](x, y);
    }
  }
  void register_touchstart(TouchEvent e) {
    e.preventDefault();
    if (e.touches.length > 0) {
      Touch t = e.touches.first;
      int x = t.client.x-canvas.offsetLeft; int y = t.client.y-canvas.offsetTop;
      if (control_map.containsKey(TOUCH_START)) {
        control_map[TOUCH_START][0](x, y);
      }
    }
  }
  void register_touchmove(TouchEvent e) {
    e.preventDefault();
    if (e.touches.length > 0) {
      Touch t = e.touches.first;
      int x = t.client.x-canvas.offsetLeft; int y = t.client.y-canvas.offsetTop;
      if (control_map.containsKey(TOUCH_MOVE)) {
        control_map[TOUCH_MOVE][0](x, y);
      }
    }
  }

  void process() {
    switch (world.input_mode) {
      case InputMode.Playing:
        control_map = playing_control_map;
        break;
      case InputMode.Typing:
        control_map = typing_control_map;
        break;
      case InputMode.UI:
        control_map = ui_control_map;
        break;
    }
  }
  void remove_entity(int e) {}
}
