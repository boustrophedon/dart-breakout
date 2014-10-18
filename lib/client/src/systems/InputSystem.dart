part of breakout_client;

class InputSystem extends System {
  CanvasElement canvas;

  InputSystem(World world) : super(world) { components_wanted = null; }

  void initialize() {
    canvas = world.globaldata['canvas'];

    window.onKeyDown.listen(register_keydown);
    window.onKeyUp.listen(register_keyup);

    // replace the window mousedown/move and touchstart/move with canvas
    // mouseup and touchend should fire regardless of where they end.
    // mouse/touch are separate so that I can have the MouseEvent and TouchEvent
    // in the parameters. it is not necessary though; I think I can just use Event or UIEvent.
    // also, need to actually add the mousemove/touchmove handlers
    canvas.onMouseDown.listen(register_mousedown);
    canvas.onMouseMove.listen(register_mousemove);
    window.onMouseUp.listen(register_mouseup);
    canvas.onTouchStart.listen(register_touchstart);
    canvas.onTouchMove.listen(register_touchmove);
    window.onTouchEnd.listen(register_touchend);

    window.onDeviceMotion.listen(register_devicemotion);

    world.subscribe_event('KeyDown', handle_keydown);
    world.subscribe_event('KeyUp', handle_keyup);

    world.subscribe_event('MouseDown', handle_mousedown);
    world.subscribe_event('MouseMove', handle_mousemove);
    world.subscribe_event('MouseUp', handle_mouseup);
    world.subscribe_event('TouchStart', handle_touchstart);
    world.subscribe_event('TouchMove', handle_touchmove);
    world.subscribe_event('TouchEnd', handle_touchend);
  }

  // These methods are called immediately when a click or keydown is registered, "outside of" the gameloop
  // They shouldn't change, since they just push input events onto the event queue. it's a bit pointless but it means that all input
  // from the same frame gets dealt with in the same loop rather than getting handled immediately


  // so it turns out the offsetLeft and offsetTop things are kind of odd but do what they say in the sense that
  // if you scroll down the page, they don't change; it's based on viewport, I guess?
  // I think/it seems you can add window.scrollX and window.scrollY if you care
  void register_mousedown(MouseEvent e) {
    int x = e.client.x-canvas.offsetLeft; int y = e.client.y-canvas.offsetTop;
    world.send_event('MouseDown', {'MouseEvent':e,'x':x,'y':y});
  }
  void register_mousemove(MouseEvent e) {
    int x = e.client.x-canvas.offsetLeft; int y = e.client.y-canvas.offsetTop;
    world.send_event('MouseMove', {'MouseEvent':e,'x':x,'y':y});
  }
  void register_mouseup(MouseEvent e) {
    int x = e.client.x-canvas.offsetLeft; int y = e.client.y-canvas.offsetTop;
    world.send_event('MouseUp', {'MouseEvent':e,'x':x,'y':y});
  }
  void register_touchstart(TouchEvent e) {
    e.preventDefault();
    if (e.touches.length > 0) {
      Touch t = e.touches.first;
      int x = t.client.x-canvas.offsetLeft; int y = t.client.y-canvas.offsetTop;
      world.send_event('TouchStart', {'TouchEvent':e,'x':x,'y':y});
    }
  }
  void register_touchmove(TouchEvent e) {
    e.preventDefault();
    if (e.touches.length > 0) {
      Touch t = e.touches.first;
      int x = t.client.x-canvas.offsetLeft; int y = t.client.y-canvas.offsetTop;
      world.send_event('TouchMove', {'TouchEvent':e,'x':x,'y':y});
    }
  }
  void register_touchend(TouchEvent e) {
    e.preventDefault();
    world.send_event('TouchEnd', {'TouchEvent':e});
  }

  void register_keydown(KeyboardEvent e) {
    world.send_event('KeyDown', {'KeyboardEvent':e});
  }
  void register_keyup(KeyboardEvent e) {
    world.send_event('KeyUp', {'KeyboardEvent':e});
  }

  void register_devicemotion(DeviceMotionEvent e) {
    var a = e.acceleration;
    if (a.x != null && a.y != null && a.z != null) {
      num ss = math.sqrt(a.x*a.x + a.y*a.y + a.z*a.z);
      if (ss > 5) { // only send acceleration event if it is significant. 5 is arbitrary
        world.send_event('DeviceMotion', {'DeviceMotionEvent':e});
      }
    }
  }

  // These are called inside process events "inside" the gameloop
  void handle_keydown(Map event) {
    KeyboardEvent e = event['KeyboardEvent'];
  }
  void handle_keyup(Map event) {
    KeyboardEvent e = event['KeyboardEvent'];
  }

  void handle_mousedown(Map event) {
    MouseEvent e = event['MouseEvent'];
  }
  void handle_mousemove(Map event) {
    MouseEvent e = event['MouseEvent'];
  }
  void handle_mouseup(Map event) {
    MouseEvent e = event['MouseEvent'];
  }
  void handle_touchstart(Map event) {
    TouchEvent e = event['TouchEvent'];
  }
  void handle_touchmove(Map event) {
    TouchEvent e = event['TouchEvent'];
  }
  void handle_touchend(Map event) {
    TouchEvent e = event['TouchEvent'];
  }

  void process_entity(Entity entity) {}
  void remove_entity(Entity e) {}
}
