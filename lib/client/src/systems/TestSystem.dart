part of breakout_client;

class TestSystem extends System {
  TestSystem(BreakoutClientWorld world) : super(world) {
    components_wanted = null;
  }
  void initialize() {
    //world.send_event("CreateEntity", {"type":"paddle"});
  }
}
