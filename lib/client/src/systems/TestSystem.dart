part of breakout_client;

class TestSystem extends System {
  TestSystem(World world) : super(world) {
    components_wanted = null;
  }
  void initialize() {
    //world.send_event("CreateEntity", {"type":"paddle"});
  }
}
