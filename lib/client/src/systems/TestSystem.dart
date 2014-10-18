part of breakout_client;

class TestSystem extends System {
  TestSystem(World world) : super(world) {
    components_wanted = null;
  }
  void initialize() {
    print("hello");
    world.send_event("SpawnEntity", {"type":"paddle"});
  }
}
