part of breakout_client;

Map control_map = {
  KeyCode.LEFT: 'Left',
  KeyCode.RIGHT: 'Right'
};

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
    //canvas.onMouseDown.listen(register_mousedown);
    //canvas.onMouseMove.listen(register_mousemove);
    //window.onMouseUp.listen(register_mouseup);
    //canvas.onTouchStart.listen(register_touchstart);
    //canvas.onTouchMove.listen(register_touchmove);
    //window.onTouchEnd.listen(register_touchend);

    //window.onDeviceMotion.listen(register_devicemotion);

  }

  // These methods are called immediately when a click or keydown is registered, "outside of" the gameloop

  // so it turns out the offsetLeft and offsetTop things are kind of odd but do what they say in the sense that
  // if you scroll down the page, they don't change; it's based on viewport, I guess?
  // I think/it seems you can add window.scrollX and window.scrollY if you care

  //void register_mousedown(MouseEvent e) {
  //  int x = e.client.x-canvas.offsetLeft; int y = e.client.y-canvas.offsetTop;
  //}
  //void register_mousemove(MouseEvent e) {
  //  int x = e.client.x-canvas.offsetLeft; int y = e.client.y-canvas.offsetTop;
  //}
  //void register_mouseup(MouseEvent e) {
  //  int x = e.client.x-canvas.offsetLeft; int y = e.client.y-canvas.offsetTop;
  //}
  //void register_touchstart(TouchEvent e) {
  //  e.preventDefault();
  //  if (e.touches.length > 0) {
  //    Touch t = e.touches.first;
  //    int x = t.client.x-canvas.offsetLeft; int y = t.client.y-canvas.offsetTop;
  //  }
  //}
  //void register_touchmove(TouchEvent e) {
  //  e.preventDefault();
  //  if (e.touches.length > 0) {
  //    Touch t = e.touches.first;
  //    int x = t.client.x-canvas.offsetLeft; int y = t.client.y-canvas.offsetTop;
  //  }
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

  void register_keydown(KeyboardEvent e) {
    if (control_map.containsKey(e.keyCode)) {
      int player = world.tagged_entities['player'];
      if (player != null) {
        world.send_event("Move"+control_map[e.keyCode], {'paddle': player});
      }
    }
  }
  void register_keyup(KeyboardEvent e) {
    if (control_map.containsKey(e.keyCode)) {
      int player = world.tagged_entities['player'];
      if (player != null) {
        world.send_event("Stop"+control_map[e.keyCode], {'paddle': player});
      }
    }
  }

  void process_entity(int entity) {}
  void remove_entity(int e) {}
}
