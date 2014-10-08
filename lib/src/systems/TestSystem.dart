part of breakout;

class TestSystem extends System {
  TestSystem(World world) : super(world) {
    components_wanted = null;
  }
  void initialize() {
    print("hello");
  }
}
