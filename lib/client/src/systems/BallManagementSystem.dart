part of breakout_client;

class BallManagementSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  BallManagementSystem(World world) : super(world) {
    components_wanted = new Set.from([Ball,]);
  }
  void initialize() {
    world.subscribe_event("NewBallCreated", handle_newball);
    world.subscribe_event("BallDeath", handle_balldeath);
  }

  void handle_newball(Map event) {
    int ball = event['entity'];
    world.add_component(ball, new Renderable("ball"));
    world.add_component(ball, new Position(event['position'][0],event['position'][1]));
    world.add_component(ball, new Velocity(event['velocity'][1], event['velocity'][1]));
    world.add_component(ball, new Ball());
    world.add_component(ball, new Size(event['size'][0],event['size'][1]));
    world.add_component(ball, new Collidable());
    world.add_to_world(ball);
  }

  void handle_balldeath(Map event) {
    world.remove_entity(event['ball']);
  }
}
