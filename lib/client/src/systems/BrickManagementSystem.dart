part of breakout_client;

class BrickManagementSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  BrickManagementSystem(World world) : super(world) {
    components_wanted = new Set.from([Ball,]);
  }
  void initialize() {
    world.subscribe_event("NewBrickCreated", handle_newbrick);
    world.subscribe_event("BrickBreak", handle_brickbreak);
  }

  void handle_newbrick(Map event) {
    int brick = event['entity'];
    world.add_component(brick, new Renderable("brick"));
    world.add_component(brick, new Position(event['position'][0],event['position'][1]));
    world.add_component(brick, new Brick(event['color']));
    world.add_component(brick, new Size(event['size'][0],event['size'][1]));
    //world.add_component(brick, new Collidable());
    world.add_to_world(brick);
  }

  void handle_brickbreak(Map event) {
    world.remove_entity(event['brick']);
  }
}
